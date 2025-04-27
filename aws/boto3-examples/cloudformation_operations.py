import boto3
import logging
import json
import time
from botocore.exceptions import ClientError

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Initialize CloudFormation client
cf_client = boto3.client('cloudformation')

def create_stack(stack_name, template_body=None, template_url=None, parameters=None, 
                capabilities=None, timeout_minutes=None, on_failure='ROLLBACK'):
    """
    Create a CloudFormation stack
    
    Parameters:
    - stack_name: Name of the stack
    - template_body: CloudFormation template JSON/YAML as a string
    - template_url: URL to the CloudFormation template
    - parameters: List of parameter dictionaries
    - capabilities: List of capabilities (e.g., ['CAPABILITY_IAM'])
    - timeout_minutes: Stack creation timeout in minutes
    - on_failure: Action to take on failure (DO_NOTHING | ROLLBACK | DELETE)
    """
    try:
        kwargs = {'StackName': stack_name}
        
        # Either template_body or template_url must be provided
        if template_body:
            kwargs['TemplateBody'] = template_body
        elif template_url:
            kwargs['TemplateURL'] = template_url
        else:
            raise ValueError("Either template_body or template_url must be provided")
        
        if parameters:
            kwargs['Parameters'] = parameters
        
        if capabilities:
            kwargs['Capabilities'] = capabilities
            
        if timeout_minutes:
            kwargs['TimeoutInMinutes'] = timeout_minutes
            
        kwargs['OnFailure'] = on_failure
        
        response = cf_client.create_stack(**kwargs)
        stack_id = response['StackId']
        logger.info(f"Creating stack {stack_name} with ID {stack_id}")
        return stack_id
    except ClientError as e:
        logger.error(f"Error creating stack {stack_name}: {e}")
        return None

def update_stack(stack_name, template_body=None, template_url=None, parameters=None, capabilities=None):
    """Update an existing CloudFormation stack"""
    try:
        kwargs = {'StackName': stack_name}
        
        # Either template_body or template_url must be provided
        if template_body:
            kwargs['TemplateBody'] = template_body
        elif template_url:
            kwargs['TemplateURL'] = template_url
            
        if parameters:
            kwargs['Parameters'] = parameters
        
        if capabilities:
            kwargs['Capabilities'] = capabilities
            
        response = cf_client.update_stack(**kwargs)
        stack_id = response['StackId']
        logger.info(f"Updating stack {stack_name} with ID {stack_id}")
        return stack_id
    except ClientError as e:
        if "No updates are to be performed" in str(e):
            logger.info(f"No updates needed for stack {stack_name}")
            return stack_name
        else:
            logger.error(f"Error updating stack {stack_name}: {e}")
            return None

def delete_stack(stack_name):
    """Delete a CloudFormation stack"""
    try:
        cf_client.delete_stack(StackName=stack_name)
        logger.info(f"Deleting stack {stack_name}")
        return True
    except ClientError as e:
        logger.error(f"Error deleting stack {stack_name}: {e}")
        return False

def describe_stack(stack_name):
    """Get information about a stack"""
    try:
        response = cf_client.describe_stacks(StackName=stack_name)
        stack = response['Stacks'][0]
        logger.info(f"Retrieved information for stack {stack_name}")
        return stack
    except ClientError as e:
        logger.error(f"Error describing stack {stack_name}: {e}")
        return None

def list_stacks(status_filters=None):
    """
    List CloudFormation stacks
    
    Parameters:
    - status_filters: List of stack statuses to filter by
                     (e.g., ['CREATE_COMPLETE', 'UPDATE_COMPLETE'])
    """
    try:
        kwargs = {}
        if status_filters:
            kwargs['StackStatusFilter'] = status_filters
            
        response = cf_client.list_stacks(**kwargs)
        stacks = response.get('StackSummaries', [])
        
        stack_data = []
        for stack in stacks:
            stack_data.append({
                'StackName': stack['StackName'],
                'StackId': stack['StackId'],
                'Status': stack['StackStatus'],
                'CreationTime': stack['CreationTime'].isoformat()
            })
            
        logger.info(f"Found {len(stack_data)} CloudFormation stacks")
        return stack_data
    except ClientError as e:
        logger.error(f"Error listing stacks: {e}")
        return []

def get_stack_resources(stack_name):
    """List all resources in a CloudFormation stack"""
    try:
        response = cf_client.list_stack_resources(StackName=stack_name)
        resources = response.get('StackResourceSummaries', [])
        
        resource_data = []
        for resource in resources:
            resource_data.append({
                'LogicalId': resource['LogicalResourceId'],
                'PhysicalId': resource.get('PhysicalResourceId'),
                'Type': resource['ResourceType'],
                'Status': resource['ResourceStatus']
            })
            
        logger.info(f"Found {len(resource_data)} resources in stack {stack_name}")
        return resource_data
    except ClientError as e:
        logger.error(f"Error getting resources for stack {stack_name}: {e}")
        return []

def get_template(stack_name):
    """Get the template for a stack"""
    try:
        response = cf_client.get_template(StackName=stack_name)
        template_body = response['TemplateBody']
        logger.info(f"Retrieved template for stack {stack_name}")
        return template_body
    except ClientError as e:
        logger.error(f"Error getting template for stack {stack_name}: {e}")
        return None

def get_stack_outputs(stack_name):
    """Get outputs from a stack"""
    try:
        stack = describe_stack(stack_name)
        if not stack or 'Outputs' not in stack:
            return {}
        
        outputs = {}
        for output in stack['Outputs']:
            outputs[output['OutputKey']] = {
                'Value': output['OutputValue'],
                'Description': output.get('Description', ''),
                'ExportName': output.get('ExportName')
            }
            
        logger.info(f"Retrieved {len(outputs)} outputs from stack {stack_name}")
        return outputs
    except ClientError as e:
        logger.error(f"Error getting outputs for stack {stack_name}: {e}")
        return {}

def wait_for_stack_completion(stack_name, timeout=900, check_interval=30):
    """
    Wait for a stack operation to complete
    
    Parameters:
    - stack_name: Name of the stack to monitor
    - timeout: Maximum time to wait in seconds
    - check_interval: Time between checks in seconds
    
    Returns:
    - Final stack status or None if timeout reached
    """
    start_time = time.time()
    end_time = start_time + timeout
    
    while time.time() < end_time:
        stack = describe_stack(stack_name)
        if not stack:
            return None
        
        status = stack['StackStatus']
        logger.info(f"Stack {stack_name} status: {status}")
        
        # Check if operation has completed
        if status.endswith('_COMPLETE') or status.endswith('_FAILED'):
            return status
            
        time.sleep(check_interval)
    
    logger.warning(f"Timeout reached waiting for stack {stack_name} to complete")
    return None

def validate_template(template_body=None, template_url=None):
    """
    Validate a CloudFormation template
    
    Parameters:
    - template_body: Template body as string
    - template_url: URL to the template
    
    Returns:
    - Dictionary with validation info or None on error
    """
    try:
        kwargs = {}
        if template_body:
            kwargs['TemplateBody'] = template_body
        elif template_url:
            kwargs['TemplateURL'] = template_url
        else:
            raise ValueError("Either template_body or template_url must be provided")
            
        response = cf_client.validate_template(**kwargs)
        logger.info(f"Template is valid")
        return {
            'Parameters': response.get('Parameters', []),
            'Description': response.get('Description', ''),
            'Capabilities': response.get('Capabilities', []),
            'CapabilitiesReason': response.get('CapabilitiesReason')
        }
    except ClientError as e:
        logger.error(f"Error validating template: {e}")
        return None

def create_change_set(stack_name, change_set_name, template_body=None, template_url=None, 
                     parameters=None, capabilities=None, description=None, change_set_type='UPDATE'):
    """
    Create a change set for an existing or new stack
    
    Parameters:
    - stack_name: Name of the stack
    - change_set_name: Name for the change set
    - template_body: CloudFormation template as string
    - template_url: URL to the template
    - parameters: List of parameter dictionaries
    - capabilities: List of capabilities
    - description: Change set description
    - change_set_type: 'UPDATE' or 'CREATE'
    
    Returns:
    - Change set ID or None on error
    """
    try:
        kwargs = {
            'StackName': stack_name,
            'ChangeSetName': change_set_name,
            'ChangeSetType': change_set_type
        }
        
        # Either template_body or template_url must be provided
        if template_body:
            kwargs['TemplateBody'] = template_body
        elif template_url:
            kwargs['TemplateURL'] = template_url
        
        if parameters:
            kwargs['Parameters'] = parameters
        
        if capabilities:
            kwargs['Capabilities'] = capabilities
            
        if description:
            kwargs['Description'] = description
            
        response = cf_client.create_change_set(**kwargs)
        change_set_id = response['Id']
        logger.info(f"Created change set {change_set_name} with ID {change_set_id}")
        return change_set_id
    except ClientError as e:
        logger.error(f"Error creating change set {change_set_name}: {e}")
        return None

def describe_change_set(change_set_name, stack_name=None):
    """Get information about a change set"""
    try:
        kwargs = {'ChangeSetName': change_set_name}
        if stack_name:
            kwargs['StackName'] = stack_name
            
        response = cf_client.describe_change_set(**kwargs)
        logger.info(f"Retrieved information for change set {change_set_name}")
        return response
    except ClientError as e:
        logger.error(f"Error describing change set {change_set_name}: {e}")
        return None

def execute_change_set(change_set_name, stack_name=None):
    """Execute a change set"""
    try:
        kwargs = {'ChangeSetName': change_set_name}
        if stack_name:
            kwargs['StackName'] = stack_name
            
        cf_client.execute_change_set(**kwargs)
        logger.info(f"Executing change set {change_set_name}")
        return True
    except ClientError as e:
        logger.error(f"Error executing change set {change_set_name}: {e}")
        return False

# Example usage
if __name__ == "__main__":
    # Replace with your values
    stack_name = 'my-cf-stack'
    
    # Sample CloudFormation template
    template = {
        "AWSTemplateFormatVersion": "2010-09-09",
        "Description": "Sample CloudFormation template",
        "Resources": {
            "S3Bucket": {
                "Type": "AWS::S3::Bucket",
                "Properties": {
                    "BucketName": "my-cf-bucket-12345"
                }
            }
        },
        "Outputs": {
            "BucketName": {
                "Description": "Name of the S3 bucket",
                "Value": {"Ref": "S3Bucket"}
            }
        }
    }
    
    # Validate template
    validate_template(template_body=json.dumps(template))
    
    # Create stack
    stack_id = create_stack(
        stack_name,
        template_body=json.dumps(template),
        capabilities=['CAPABILITY_IAM']
    )
    
    # Wait for stack to complete
    final_status = wait_for_stack_completion(stack_name)
    
    # Get stack outputs
    if final_status and final_status.endswith('_COMPLETE'):
        outputs = get_stack_outputs(stack_name)
        print("Stack Outputs:")
        for key, info in outputs.items():
            print(f"{key}: {info['Value']}")
