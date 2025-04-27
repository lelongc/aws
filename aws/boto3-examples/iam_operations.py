import boto3
import json
import logging
from botocore.exceptions import ClientError

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Initialize IAM client and resource
iam_client = boto3.client('iam')
iam_resource = boto3.resource('iam')

def create_user(username):
    """Create an IAM user"""
    try:
        user = iam_resource.create_user(UserName=username)
        logger.info(f"Created IAM user {username}")
        return user
    except ClientError as e:
        logger.error(f"Error creating IAM user {username}: {e}")
        return None

def delete_user(username):
    """Delete an IAM user"""
    try:
        user = iam_resource.User(username)
        
        # Remove user from all groups
        for group in user.groups.all():
            group.remove_user(UserName=username)
            
        # Detach all user policies
        for policy in user.attached_policies.all():
            user.detach_policy(PolicyArn=policy.arn)
            
        # Delete all inline policies
        for policy in user.policies.all():
            policy.delete()
            
        # Delete all access keys
        for access_key in user.access_keys.all():
            access_key.delete()
            
        # Delete login profile if exists
        try:
            user.LoginProfile().delete()
        except ClientError as e:
            if 'NoSuchEntity' not in str(e):
                raise
        
        # Delete MFA devices
        for mfa in user.mfa_devices.all():
            mfa.delete()
            
        # Finally delete the user
        user.delete()
        logger.info(f"Deleted IAM user {username}")
        return True
    except ClientError as e:
        logger.error(f"Error deleting IAM user {username}: {e}")
        return False

def list_users():
    """List all IAM users"""
    try:
        users = list(iam_resource.users.all())
        user_data = []
        for user in users:
            user_data.append({
                'UserName': user.user_name,
                'UserId': user.user_id,
                'Arn': user.arn,
                'CreateDate': user.create_date.isoformat()
            })
            
        logger.info(f"Found {len(user_data)} IAM users")
        return user_data
    except ClientError as e:
        logger.error(f"Error listing IAM users: {e}")
        return []

def create_access_key(username):
    """Create an access key for an IAM user"""
    try:
        user = iam_resource.User(username)
        access_key_pair = user.create_access_key_pair()
        
        # Access key info to return - keep this info, it won't be accessible again
        key_info = {
            'AccessKeyId': access_key_pair.id,
            'SecretAccessKey': access_key_pair.secret
        }
        
        logger.info(f"Created access key for user {username}")
        return key_info
    except ClientError as e:
        logger.error(f"Error creating access key for user {username}: {e}")
        return None

def delete_access_key(username, access_key_id):
    """Delete an IAM user access key"""
    try:
        iam_resource.User(username).AccessKey(access_key_id).delete()
        logger.info(f"Deleted access key {access_key_id} for user {username}")
        return True
    except ClientError as e:
        logger.error(f"Error deleting access key {access_key_id} for user {username}: {e}")
        return False

def create_group(group_name, description=None):
    """Create an IAM group"""
    try:
        group = iam_resource.create_group(GroupName=group_name)
        logger.info(f"Created IAM group {group_name}")
        return group
    except ClientError as e:
        logger.error(f"Error creating IAM group {group_name}: {e}")
        return None

def delete_group(group_name):
    """Delete an IAM group"""
    try:
        group = iam_resource.Group(group_name)
        
        # Remove all users from the group
        for user in group.users.all():
            group.remove_user(UserName=user.name)
            
        # Detach all managed policies
        for policy in group.attached_policies.all():
            group.detach_policy(PolicyArn=policy.arn)
            
        # Delete all inline policies
        for policy in group.policies.all():
            policy.delete()
            
        # Delete the group
        group.delete()
        logger.info(f"Deleted IAM group {group_name}")
        return True
    except ClientError as e:
        logger.error(f"Error deleting IAM group {group_name}: {e}")
        return False

def add_user_to_group(username, group_name):
    """Add an IAM user to a group"""
    try:
        iam_resource.Group(group_name).add_user(UserName=username)
        logger.info(f"Added user {username} to group {group_name}")
        return True
    except ClientError as e:
        logger.error(f"Error adding user {username} to group {group_name}: {e}")
        return False

def remove_user_from_group(username, group_name):
    """Remove an IAM user from a group"""
    try:
        iam_resource.Group(group_name).remove_user(UserName=username)
        logger.info(f"Removed user {username} from group {group_name}")
        return True
    except ClientError as e:
        logger.error(f"Error removing user {username} from group {group_name}: {e}")
        return False

def create_policy(policy_name, policy_document, description=None):
    """Create an IAM policy"""
    try:
        kwargs = {
            'PolicyName': policy_name,
            'PolicyDocument': json.dumps(policy_document) if isinstance(policy_document, dict) else policy_document
        }
        
        if description:
            kwargs['Description'] = description
            
        response = iam_client.create_policy(**kwargs)
        policy_arn = response['Policy']['Arn']
        logger.info(f"Created IAM policy {policy_name} with ARN {policy_arn}")
        return policy_arn
    except ClientError as e:
        logger.error(f"Error creating IAM policy {policy_name}: {e}")
        return None

def delete_policy(policy_arn):
    """Delete an IAM policy"""
    try:
        # Delete all versions except the default
        policy = iam_resource.Policy(policy_arn)
        for version in policy.versions.all():
            if not version.is_default_version:
                version.delete()
                
        # Delete the policy
        policy.delete()
        logger.info(f"Deleted IAM policy {policy_arn}")
        return True
    except ClientError as e:
        logger.error(f"Error deleting IAM policy {policy_arn}: {e}")
        return False

def attach_policy_to_user(policy_arn, username):
    """Attach an IAM policy to a user"""
    try:
        iam_resource.User(username).attach_policy(PolicyArn=policy_arn)
        logger.info(f"Attached policy {policy_arn} to user {username}")
        return True
    except ClientError as e:
        logger.error(f"Error attaching policy {policy_arn} to user {username}: {e}")
        return False

def detach_policy_from_user(policy_arn, username):
    """Detach an IAM policy from a user"""
    try:
        iam_resource.User(username).detach_policy(PolicyArn=policy_arn)
        logger.info(f"Detached policy {policy_arn} from user {username}")
        return True
    except ClientError as e:
        logger.error(f"Error detaching policy {policy_arn} from user {username}: {e}")
        return False

def attach_policy_to_group(policy_arn, group_name):
    """Attach an IAM policy to a group"""
    try:
        iam_resource.Group(group_name).attach_policy(PolicyArn=policy_arn)
        logger.info(f"Attached policy {policy_arn} to group {group_name}")
        return True
    except ClientError as e:
        logger.error(f"Error attaching policy {policy_arn} to group {group_name}: {e}")
        return False

def detach_policy_from_group(policy_arn, group_name):
    """Detach an IAM policy from a group"""
    try:
        iam_resource.Group(group_name).detach_policy(PolicyArn=policy_arn)
        logger.info(f"Detached policy {policy_arn} from group {group_name}")
        return True
    except ClientError as e:
        logger.error(f"Error detaching policy {policy_arn} from group {group_name}: {e}")
        return False

def create_role(role_name, assume_role_policy_document, description=None):
    """
    Create an IAM role
    
    Parameters:
    - role_name: Name for the role
    - assume_role_policy_document: Policy that grants an entity permission to assume the role
    - description: Optional role description
    """
    try:
        kwargs = {
            'RoleName': role_name,
            'AssumeRolePolicyDocument': json.dumps(assume_role_policy_document) if isinstance(assume_role_policy_document, dict) else assume_role_policy_document
        }
        
        if description:
            kwargs['Description'] = description
            
        role = iam_resource.create_role(**kwargs)
        logger.info(f"Created IAM role {role_name}")
        return role
    except ClientError as e:
        logger.error(f"Error creating IAM role {role_name}: {e}")
        return None

def delete_role(role_name):
    """Delete an IAM role"""
    try:
        role = iam_resource.Role(role_name)
        
        # Detach all policies
        for policy in role.attached_policies.all():
            role.detach_policy(PolicyArn=policy.arn)
            
        # Delete all inline policies
        for policy in role.policies.all():
            policy.delete()
            
        # Delete all instance profiles
        for profile in role.instance_profiles.all():
            profile.remove_role(RoleName=role_name)
            # Delete the instance profile if it has same name as role
            if profile.name == role_name:
                profile.delete()
                
        # Delete the role
        role.delete()
        logger.info(f"Deleted IAM role {role_name}")
        return True
    except ClientError as e:
        logger.error(f"Error deleting IAM role {role_name}: {e}")
        return False

def attach_policy_to_role(policy_arn, role_name):
    """Attach an IAM policy to a role"""
    try:
        iam_resource.Role(role_name).attach_policy(PolicyArn=policy_arn)
        logger.info(f"Attached policy {policy_arn} to role {role_name}")
        return True
    except ClientError as e:
        logger.error(f"Error attaching policy {policy_arn} to role {role_name}: {e}")
        return False

def detach_policy_from_role(policy_arn, role_name):
    """Detach an IAM policy from a role"""
    try:
        iam_resource.Role(role_name).detach_policy(PolicyArn=policy_arn)
        logger.info(f"Detached policy {policy_arn} from role {role_name}")
        return True
    except ClientError as e:
        logger.error(f"Error detaching policy {policy_arn} from role {role_name}: {e}")
        return False

def create_instance_profile(profile_name):
    """Create an IAM instance profile"""
    try:
        profile = iam_resource.create_instance_profile(InstanceProfileName=profile_name)
        logger.info(f"Created instance profile {profile_name}")
        return profile
    except ClientError as e:
        logger.error(f"Error creating instance profile {profile_name}: {e}")
        return None

def add_role_to_instance_profile(role_name, profile_name):
    """Add a role to an instance profile"""
    try:
        iam_resource.InstanceProfile(profile_name).add_role(RoleName=role_name)
        logger.info(f"Added role {role_name} to instance profile {profile_name}")
        return True
    except ClientError as e:
        logger.error(f"Error adding role {role_name} to instance profile {profile_name}: {e}")
        return False

def create_service_linked_role(aws_service_name, description=None):
    """Create a service-linked role"""
    try:
        kwargs = {'AWSServiceName': aws_service_name}
        if description:
            kwargs['Description'] = description
            
        response = iam_client.create_service_linked_role(**kwargs)
        role = iam_resource.Role(response['Role']['RoleName'])
        logger.info(f"Created service-linked role for {aws_service_name}")
        return role
    except ClientError as e:
        logger.error(f"Error creating service-linked role for {aws_service_name}: {e}")
        return None

# Example usage
if __name__ == "__main__":
    # Create a user and group
    username = "test-user"
    group_name = "test-group"
    
    user = create_user(username)
    group = create_group(group_name)
    
    # Create a policy
    policy_document = {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": "s3:ListAllMyBuckets",
                "Resource": "*"
            }
        ]
    }
    
    policy_arn = create_policy("TestPolicy", policy_document, "Test policy for S3 bucket listing")
    
    if user and group and policy_arn:
        # Add user to group
        add_user_to_group(username, group_name)
        
        # Attach policy to group
        attach_policy_to_group(policy_arn, group_name)
        
        # Create access keys
        keys = create_access_key(username)
        if keys:
            print(f"Access Key ID: {keys['AccessKeyId']}")
            print(f"Secret Access Key: {keys['SecretAccessKey']}")
            
            # Delete access keys
            delete_access_key(username, keys['AccessKeyId'])
        
        # Clean up
        detach_policy_from_group(policy_arn, group_name)
        remove_user_from_group(username, group_name)
        delete_policy(policy_arn)
        delete_group(group_name)
        delete_user(username)
