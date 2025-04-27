import boto3
import logging
from botocore.exceptions import ClientError

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Initialize EC2 client and resource
ec2_client = boto3.client('ec2')
ec2_resource = boto3.resource('ec2')

def describe_instances(filters=None):
    """Describe EC2 instances with optional filters"""
    try:
        if filters:
            response = ec2_client.describe_instances(Filters=filters)
        else:
            response = ec2_client.describe_instances()
            
        instances = []
        for reservation in response['Reservations']:
            for instance in reservation['Instances']:
                instances.append(instance)
                
        logger.info(f"Found {len(instances)} instances")
        return instances
    except ClientError as e:
        logger.error(f"Error describing instances: {e}")
        return []

def create_instance(image_id, instance_type, key_name, security_group_ids=None, 
                   subnet_id=None, user_data=None, count=1, tag_specifications=None):
    """Launch new EC2 instances"""
    try:
        run_args = {
            'ImageId': image_id,
            'InstanceType': instance_type,
            'KeyName': key_name,
            'MinCount': count,
            'MaxCount': count
        }
        
        if security_group_ids:
            run_args['SecurityGroupIds'] = security_group_ids
            
        if subnet_id:
            run_args['SubnetId'] = subnet_id
            
        if user_data:
            run_args['UserData'] = user_data
            
        if tag_specifications:
            run_args['TagSpecifications'] = tag_specifications
            
        response = ec2_client.run_instances(**run_args)
        instance_ids = [instance['InstanceId'] for instance in response['Instances']]
        logger.info(f"Launched {len(instance_ids)} instances: {', '.join(instance_ids)}")
        return instance_ids
    except ClientError as e:
        logger.error(f"Error launching instances: {e}")
        return []

def stop_instances(instance_ids):
    """Stop EC2 instances"""
    try:
        response = ec2_client.stop_instances(InstanceIds=instance_ids)
        stopped_instances = [instance['InstanceId'] for instance in response['StoppingInstances']]
        logger.info(f"Stopped instances: {', '.join(stopped_instances)}")
        return stopped_instances
    except ClientError as e:
        logger.error(f"Error stopping instances: {e}")
        return []

def start_instances(instance_ids):
    """Start EC2 instances"""
    try:
        response = ec2_client.start_instances(InstanceIds=instance_ids)
        started_instances = [instance['InstanceId'] for instance in response['StartingInstances']]
        logger.info(f"Started instances: {', '.join(started_instances)}")
        return started_instances
    except ClientError as e:
        logger.error(f"Error starting instances: {e}")
        return []

def terminate_instances(instance_ids):
    """Terminate EC2 instances"""
    try:
        response = ec2_client.terminate_instances(InstanceIds=instance_ids)
        terminated_instances = [instance['InstanceId'] for instance in response['TerminatingInstances']]
        logger.info(f"Terminated instances: {', '.join(terminated_instances)}")
        return terminated_instances
    except ClientError as e:
        logger.error(f"Error terminating instances: {e}")
        return []

def reboot_instances(instance_ids):
    """Reboot EC2 instances"""
    try:
        ec2_client.reboot_instances(InstanceIds=instance_ids)
        logger.info(f"Rebooted instances: {', '.join(instance_ids)}")
        return True
    except ClientError as e:
        logger.error(f"Error rebooting instances: {e}")
        return False

def create_tags(resource_ids, tags):
    """Add tags to EC2 resources"""
    try:
        ec2_client.create_tags(
            Resources=resource_ids,
            Tags=tags
        )
        logger.info(f"Added tags to resources: {', '.join(resource_ids)}")
        return True
    except ClientError as e:
        logger.error(f"Error adding tags: {e}")
        return False

def create_security_group(group_name, description, vpc_id):
    """Create security group"""
    try:
        response = ec2_client.create_security_group(
            GroupName=group_name,
            Description=description,
            VpcId=vpc_id
        )
        security_group_id = response['GroupId']
        logger.info(f"Created security group {security_group_id} in vpc {vpc_id}")
        return security_group_id
    except ClientError as e:
        logger.error(f"Error creating security group: {e}")
        return None

def add_security_group_rule(security_group_id, ip_protocol, from_port, to_port, cidr_ip):
    """Add a rule to a security group"""
    try:
        ec2_client.authorize_security_group_ingress(
            GroupId=security_group_id,
            IpPermissions=[
                {
                    'IpProtocol': ip_protocol,
                    'FromPort': from_port,
                    'ToPort': to_port,
                    'IpRanges': [{'CidrIp': cidr_ip}]
                }
            ]
        )
        logger.info(f"Added {ip_protocol} rule to security group {security_group_id}")
        return True
    except ClientError as e:
        logger.error(f"Error adding security group rule: {e}")
        return False

def create_key_pair(key_name):
    """Create a key pair"""
    try:
        response = ec2_client.create_key_pair(KeyName=key_name)
        logger.info(f"Created key pair {key_name}")
        # Make sure to save the private key
        return response['KeyMaterial']
    except ClientError as e:
        logger.error(f"Error creating key pair: {e}")
        return None

def describe_images(owners=None, filters=None):
    """Find AMIs based on owners and filters"""
    try:
        params = {}
        if owners:
            params['Owners'] = owners
        if filters:
            params['Filters'] = filters
            
        response = ec2_client.describe_images(**params)
        images = response['Images']
        logger.info(f"Found {len(images)} AMIs")
        return images
    except ClientError as e:
        logger.error(f"Error describing AMIs: {e}")
        return []

def get_latest_ami(owners, name_pattern):
    """Get the latest AMI matching the name pattern from specified owners"""
    try:
        filters = [{'Name': 'name', 'Values': [name_pattern]}]
        images = describe_images(owners=owners, filters=filters)
        
        if not images:
            return None
            
        # Sort by creation date (newest first)
        sorted_images = sorted(images, key=lambda x: x['CreationDate'], reverse=True)
        latest_image = sorted_images[0]
        
        logger.info(f"Found latest AMI: {latest_image['ImageId']} ({latest_image['Name']})")
        return latest_image
    except ClientError as e:
        logger.error(f"Error getting latest AMI: {e}")
        return None

def create_snapshot(volume_id, description=None):
    """Create a snapshot of an EBS volume"""
    try:
        params = {'VolumeId': volume_id}
        if description:
            params['Description'] = description
            
        response = ec2_client.create_snapshot(**params)
        snapshot_id = response['SnapshotId']
        logger.info(f"Created snapshot {snapshot_id} of volume {volume_id}")
        return snapshot_id
    except ClientError as e:
        logger.error(f"Error creating snapshot: {e}")
        return None

def wait_for_instance_status(instance_ids, target_state):
    """Wait for instances to reach a specific state"""
    waiter = ec2_client.get_waiter(f'instance_{target_state}')
    try:
        waiter.wait(InstanceIds=instance_ids)
        logger.info(f"Instances {', '.join(instance_ids)} reached state: {target_state}")
        return True
    except Exception as e:
        logger.error(f"Error waiting for instances to reach {target_state}: {e}")
        return False

# Example usage
if __name__ == "__main__":
    # Replace with your values
    vpc_id = "vpc-12345"
    ami_id = "ami-12345"
    
    # Basic operations
    instances = describe_instances()
    
    security_group_id = create_security_group("my-security-group", "My security group", vpc_id)
    add_security_group_rule(security_group_id, "tcp", 22, 22, "0.0.0.0/0")
    
    key_material = create_key_pair("my-key-pair")
    with open("my-key-pair.pem", "w") as f:
        f.write(key_material)
    
    instance_ids = create_instance(
        ami_id,
        "t2.micro",
        "my-key-pair",
        security_group_ids=[security_group_id],
        tag_specifications=[
            {
                'ResourceType': 'instance',
                'Tags': [{'Key': 'Name', 'Value': 'MyInstance'}]
            }
        ]
    )
    
    wait_for_instance_status(instance_ids, "running")
