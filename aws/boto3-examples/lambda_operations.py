import boto3
import logging
import json
import io
import zipfile
import os
import base64
from botocore.exceptions import ClientError

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Initialize Lambda client
lambda_client = boto3.client('lambda')

def create_function(function_name, runtime, role_arn, handler, code, description=None, timeout=30, memory_size=128):
    """
    Create a new Lambda function
    
    Parameters:
    - function_name: Name of the Lambda function
    - runtime: Runtime environment (e.g., 'python3.9')
    - role_arn: Execution role ARN for the function
    - handler: Function entry point (e.g., 'lambda_function.handler')
    - code: Dictionary containing function code (ZipFile or S3Bucket/S3Key)
    - description: Optional function description
    - timeout: Function timeout in seconds
    - memory_size: Function memory in MB
    """
    try:
        kwargs = {
            'FunctionName': function_name,
            'Runtime': runtime,
            'Role': role_arn,
            'Handler': handler,
            'Code': code,
            'Timeout': timeout,
            'MemorySize': memory_size
        }
        
        if description:
            kwargs['Description'] = description
            
        response = lambda_client.create_function(**kwargs)
        function_arn = response['FunctionArn']
        logger.info(f"Created Lambda function {function_name} with ARN {function_arn}")
        return function_arn
    except ClientError as e:
        logger.error(f"Error creating Lambda function {function_name}: {e}")
        return None

def update_function_code(function_name, code):
    """Update Lambda function code"""
    try:
        response = lambda_client.update_function_code(
            FunctionName=function_name,
            **code
        )
        logger.info(f"Updated code for Lambda function {function_name}")
        return True
    except ClientError as e:
        logger.error(f"Error updating code for Lambda function {function_name}: {e}")
        return False

def update_function_configuration(function_name, **kwargs):
    """Update Lambda function configuration"""
    try:
        response = lambda_client.update_function_configuration(
            FunctionName=function_name,
            **kwargs
        )
        logger.info(f"Updated configuration for Lambda function {function_name}")
        return True
    except ClientError as e:
        logger.error(f"Error updating configuration for Lambda function {function_name}: {e}")
        return False

def delete_function(function_name):
    """Delete a Lambda function"""
    try:
        lambda_client.delete_function(FunctionName=function_name)
        logger.info(f"Deleted Lambda function {function_name}")
        return True
    except ClientError as e:
        logger.error(f"Error deleting Lambda function {function_name}: {e}")
        return False

def list_functions(max_items=None):
    """List Lambda functions"""
    try:
        kwargs = {}
        if max_items:
            kwargs['MaxItems'] = max_items
            
        response = lambda_client.list_functions(**kwargs)
        functions = response.get('Functions', [])
        
        function_data = []
        for function in functions:
            function_data.append({
                'FunctionName': function['FunctionName'],
                'Runtime': function['Runtime'],
                'ARN': function['FunctionArn'],
                'MemorySize': function['MemorySize'],
                'Timeout': function['Timeout']
            })
            
        logger.info(f"Found {len(function_data)} Lambda functions")
        return function_data
    except ClientError as e:
        logger.error(f"Error listing Lambda functions: {e}")
        return []

def get_function(function_name):
    """Get information about a Lambda function"""
    try:
        response = lambda_client.get_function(FunctionName=function_name)
        logger.info(f"Retrieved information for Lambda function {function_name}")
        return {
            'Configuration': response['Configuration'],
            'Code': response['Code'],
            'Tags': response.get('Tags', {})
        }
    except ClientError as e:
        logger.error(f"Error getting Lambda function {function_name}: {e}")
        return None

def invoke_function(function_name, payload=None, invocation_type='RequestResponse'):
    """
    Invoke a Lambda function
    
    Parameters:
    - function_name: Name or ARN of the function
    - payload: Input data for the function (dict or JSON string)
    - invocation_type: RequestResponse, Event, or DryRun
    """
    try:
        kwargs = {
            'FunctionName': function_name,
            'InvocationType': invocation_type
        }
        
        if payload:
            if isinstance(payload, dict):
                payload = json.dumps(payload)
            kwargs['Payload'] = payload.encode() if isinstance(payload, str) else payload
            
        response = lambda_client.invoke(**kwargs)
        
        if invocation_type == 'RequestResponse':
            payload_stream = response['Payload']
            payload_bytes = payload_stream.read()
            result = json.loads(payload_bytes.decode('utf-8'))
            logger.info(f"Invoked Lambda function {function_name}")
            
            # Include function execution info
            status_code = response['StatusCode']
            executed_version = response.get('ExecutedVersion', '$LATEST')
            log_result = None
            
            if 'LogResult' in response:
                log_result = base64.b64decode(response['LogResult']).decode('utf-8')
                
            return {
                'StatusCode': status_code,
                'ExecutedVersion': executed_version,
                'Result': result,
                'LogResult': log_result
            }
        else:
            logger.info(f"Invoked Lambda function {function_name} asynchronously")
            return {'StatusCode': response['StatusCode']}
    except ClientError as e:
        logger.error(f"Error invoking Lambda function {function_name}: {e}")
        return None

def add_permission(function_name, statement_id, action, principal, source_arn=None):
    """Add a permission to a Lambda function policy"""
    try:
        kwargs = {
            'FunctionName': function_name,
            'StatementId': statement_id,
            'Action': action,
            'Principal': principal
        }
        
        if source_arn:
            kwargs['SourceArn'] = source_arn
            
        lambda_client.add_permission(**kwargs)
        logger.info(f"Added permission {statement_id} to Lambda function {function_name}")
        return True
    except ClientError as e:
        logger.error(f"Error adding permission to Lambda function {function_name}: {e}")
        return False

def create_function_zip(files, output_path=None):
    """
    Create a ZIP file for Lambda deployment
    
    Parameters:
    - files: Dict mapping source file paths to destination paths in the ZIP
    - output_path: Optional path to write the ZIP file
    
    Returns:
    - ZIP file as bytes or the path to the ZIP file if output_path is provided
    """
    try:
        buffer = io.BytesIO()
        with zipfile.ZipFile(buffer, 'w', zipfile.ZIP_DEFLATED) as zipf:
            for source_path, dest_path in files.items():
                zipf.write(source_path, dest_path)
        
        buffer.seek(0)
        zip_bytes = buffer.read()
        
        if output_path:
            with open(output_path, 'wb') as f:
                f.write(zip_bytes)
            logger.info(f"Created Lambda ZIP file at {output_path}")
            return output_path
        else:
            logger.info(f"Created Lambda ZIP in memory")
            return zip_bytes
    except Exception as e:
        logger.error(f"Error creating ZIP file: {e}")
        return None

def create_layer(layer_name, description, zip_file, compatible_runtimes=None):
    """Create a Lambda layer"""
    try:
        kwargs = {
            'LayerName': layer_name,
            'Description': description,
            'Content': {'ZipFile': zip_file}
        }
        
        if compatible_runtimes:
            kwargs['CompatibleRuntimes'] = compatible_runtimes
            
        response = lambda_client.publish_layer_version(**kwargs)
        logger.info(f"Created Lambda layer {layer_name} version {response['Version']}")
        return response['LayerVersionArn']
    except ClientError as e:
        logger.error(f"Error creating Lambda layer {layer_name}: {e}")
        return None

def list_layers():
    """List all Lambda layers"""
    try:
        response = lambda_client.list_layers()
        layers = response.get('Layers', [])
        
        layer_data = []
        for layer in layers:
            layer_data.append({
                'LayerName': layer['LayerName'],
                'LatestVersion': layer['LatestMatchingVersion']['Version'],
                'ARN': layer['LayerArn']
            })
            
        logger.info(f"Found {len(layer_data)} Lambda layers")
        return layer_data
    except ClientError as e:
        logger.error(f"Error listing Lambda layers: {e}")
        return []

def create_event_source_mapping(function_name, event_source_arn, batch_size=10, enabled=True):
    """Create an event source mapping for a Lambda function"""
    try:
        response = lambda_client.create_event_source_mapping(
            FunctionName=function_name,
            EventSourceArn=event_source_arn,
            BatchSize=batch_size,
            Enabled=enabled
        )
        uuid = response['UUID']
        logger.info(f"Created event source mapping {uuid} for function {function_name}")
        return uuid
    except ClientError as e:
        logger.error(f"Error creating event source mapping for function {function_name}: {e}")
        return None

# Example usage
if __name__ == "__main__":
    # Replace with your values
    function_name = 'my-lambda-function'
    role_arn = 'arn:aws:iam::123456789012:role/lambda-role'
    
    # Example Lambda function code (Python)
    sample_code = """
def handler(event, context):
    print('Hello from Lambda!')
    return {
        'message': 'Hello, World!'
    }
"""
    
    # Create ZIP file with Lambda code
    with open('/tmp/lambda_function.py', 'w') as f:
        f.write(sample_code)
        
    zip_bytes = create_function_zip(
        {'/tmp/lambda_function.py': 'lambda_function.py'}
    )
    
    # Create function
    function_arn = create_function(
        function_name,
        'python3.9',
        role_arn,
        'lambda_function.handler',
        {'ZipFile': zip_bytes},
        description='Example Lambda function',
        timeout=10,
        memory_size=128
    )
    
    # Invoke function
    if function_arn:
        response = invoke_function(
            function_name,
            payload={'key': 'value'}
        )
        print(json.dumps(response['Result'], indent=2))
