import boto3
import logging
from botocore.exceptions import ClientError
import json
from decimal import Decimal

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Initialize DynamoDB client and resource
dynamodb_client = boto3.client('dynamodb')
dynamodb_resource = boto3.resource('dynamodb')

# Helper class to convert between DynamoDB and JSON
class DecimalEncoder(json.JSONEncoder):
    def default(self, o):
        if isinstance(o, Decimal):
            return float(o)
        return super(DecimalEncoder, self).default(o)

def create_table(table_name, key_schema, attribute_definitions, provisioned_throughput):
    """
    Create a DynamoDB table
    
    Parameters:
    - table_name: Name of the table
    - key_schema: List defining the primary key (hash & optional range key)
    - attribute_definitions: List defining the attributes used in key_schema
    - provisioned_throughput: Dict with ReadCapacityUnits and WriteCapacityUnits
    """
    try:
        table = dynamodb_client.create_table(
            TableName=table_name,
            KeySchema=key_schema,
            AttributeDefinitions=attribute_definitions,
            ProvisionedThroughput=provisioned_throughput
        )
        logger.info(f"Created table {table_name}")
        return table
    except ClientError as e:
        logger.error(f"Error creating table {table_name}: {e}")
        return None

def list_tables():
    """List all DynamoDB tables"""
    try:
        response = dynamodb_client.list_tables()
        tables = response.get('TableNames', [])
        logger.info(f"Found {len(tables)} tables: {', '.join(tables)}")
        return tables
    except ClientError as e:
        logger.error(f"Error listing tables: {e}")
        return []

def delete_table(table_name):
    """Delete a DynamoDB table"""
    try:
        dynamodb_client.delete_table(TableName=table_name)
        logger.info(f"Deleted table {table_name}")
        return True
    except ClientError as e:
        logger.error(f"Error deleting table {table_name}: {e}")
        return False

def put_item(table_name, item):
    """Add an item to a DynamoDB table"""
    try:
        table = dynamodb_resource.Table(table_name)
        response = table.put_item(Item=item)
        logger.info(f"Added item to table {table_name}")
        return True
    except ClientError as e:
        logger.error(f"Error adding item to table {table_name}: {e}")
        return False

def get_item(table_name, key):
    """Retrieve an item from a DynamoDB table using its primary key"""
    try:
        table = dynamodb_resource.Table(table_name)
        response = table.get_item(Key=key)
        
        if 'Item' in response:
            logger.info(f"Retrieved item from table {table_name}")
            return response['Item']
        else:
            logger.info(f"No item found with the specified key in table {table_name}")
            return None
    except ClientError as e:
        logger.error(f"Error retrieving item from table {table_name}: {e}")
        return None

def update_item(table_name, key, update_expression, expression_attribute_values):
    """Update an item in a DynamoDB table"""
    try:
        table = dynamodb_resource.Table(table_name)
        response = table.update_item(
            Key=key,
            UpdateExpression=update_expression,
            ExpressionAttributeValues=expression_attribute_values,
            ReturnValues="UPDATED_NEW"
        )
        logger.info(f"Updated item in table {table_name}")
        return response.get('Attributes')
    except ClientError as e:
        logger.error(f"Error updating item in table {table_name}: {e}")
        return None

def delete_item(table_name, key):
    """Delete an item from a DynamoDB table"""
    try:
        table = dynamodb_resource.Table(table_name)
        response = table.delete_item(Key=key)
        logger.info(f"Deleted item from table {table_name}")
        return True
    except ClientError as e:
        logger.error(f"Error deleting item from table {table_name}: {e}")
        return False

def query_items(table_name, key_condition_expression, expression_attribute_values):
    """Query items from a DynamoDB table"""
    try:
        table = dynamodb_resource.Table(table_name)
        response = table.query(
            KeyConditionExpression=key_condition_expression,
            ExpressionAttributeValues=expression_attribute_values
        )
        
        items = response.get('Items', [])
        logger.info(f"Found {len(items)} items in table {table_name}")
        return items
    except ClientError as e:
        logger.error(f"Error querying items from table {table_name}: {e}")
        return []

def scan_table(table_name, filter_expression=None, expression_attribute_values=None):
    """Scan a DynamoDB table with optional filtering"""
    try:
        table = dynamodb_resource.Table(table_name)
        
        scan_kwargs = {}
        if filter_expression:
            scan_kwargs['FilterExpression'] = filter_expression
        if expression_attribute_values:
            scan_kwargs['ExpressionAttributeValues'] = expression_attribute_values
            
        response = table.scan(**scan_kwargs)
        items = response.get('Items', [])
        
        # Handle pagination
        while 'LastEvaluatedKey' in response:
            scan_kwargs['ExclusiveStartKey'] = response['LastEvaluatedKey']
            response = table.scan(**scan_kwargs)
            items.extend(response.get('Items', []))
            
        logger.info(f"Found {len(items)} items in table {table_name}")
        return items
    except ClientError as e:
        logger.error(f"Error scanning table {table_name}: {e}")
        return []

def batch_write(table_name, items):
    """Write multiple items to a DynamoDB table in a batch"""
    try:
        table = dynamodb_resource.Table(table_name)
        with table.batch_writer() as batch:
            for item in items:
                batch.put_item(Item=item)
        
        logger.info(f"Added {len(items)} items to table {table_name} in a batch")
        return True
    except ClientError as e:
        logger.error(f"Error batch writing to table {table_name}: {e}")
        return False

def create_global_secondary_index(table_name, index_name, key_schema, projection, provisioned_throughput):
    """Add a Global Secondary Index (GSI) to an existing DynamoDB table"""
    try:
        dynamodb_client.update_table(
            TableName=table_name,
            AttributeDefinitions=[
                {'AttributeName': key['AttributeName'], 'AttributeType': 'S'} 
                for key in key_schema
            ],
            GlobalSecondaryIndexUpdates=[
                {
                    'Create': {
                        'IndexName': index_name,
                        'KeySchema': key_schema,
                        'Projection': projection,
                        'ProvisionedThroughput': provisioned_throughput
                    }
                }
            ]
        )
        logger.info(f"Created GSI {index_name} on table {table_name}")
        return True
    except ClientError as e:
        logger.error(f"Error creating GSI {index_name} on table {table_name}: {e}")
        return False

def enable_time_to_live(table_name, ttl_attribute_name):
    """Enable Time to Live (TTL) for a DynamoDB table"""
    try:
        dynamodb_client.update_time_to_live(
            TableName=table_name,
            TimeToLiveSpecification={
                'Enabled': True,
                'AttributeName': ttl_attribute_name
            }
        )
        logger.info(f"Enabled TTL on attribute {ttl_attribute_name} for table {table_name}")
        return True
    except ClientError as e:
        logger.error(f"Error enabling TTL for table {table_name}: {e}")
        return False

def backup_table(table_name, backup_name):
    """Create an on-demand backup of a DynamoDB table"""
    try:
        response = dynamodb_client.create_backup(
            TableName=table_name,
            BackupName=backup_name
        )
        backup_arn = response['BackupDetails']['BackupArn']
        logger.info(f"Created backup {backup_name} ({backup_arn}) for table {table_name}")
        return backup_arn
    except ClientError as e:
        logger.error(f"Error creating backup for table {table_name}: {e}")
        return None

# Example usage
if __name__ == "__main__":
    # Replace with your values
    table_name = "Users"
    
    # Create table
    key_schema = [
        {'AttributeName': 'user_id', 'KeyType': 'HASH'},  # Partition key
        {'AttributeName': 'email', 'KeyType': 'RANGE'}    # Sort key
    ]
    attribute_definitions = [
        {'AttributeName': 'user_id', 'AttributeType': 'S'},
        {'AttributeName': 'email', 'AttributeType': 'S'}
    ]
    provisioned_throughput = {'ReadCapacityUnits': 5, 'WriteCapacityUnits': 5}
    
    create_table(table_name, key_schema, attribute_definitions, provisioned_throughput)
    
    # Add item
    user = {
        'user_id': '12345',
        'email': 'user@example.com',
        'name': 'John Doe',
        'age': 30,
        'active': True
    }
    put_item(table_name, user)
    
    # Get item
    retrieved_user = get_item(table_name, {'user_id': '12345', 'email': 'user@example.com'})
    print(json.dumps(retrieved_user, cls=DecimalEncoder))
    
    # Update item
    update_expression = "SET age = :newage, active = :active"
    expression_attribute_values = {':newage': 31, ':active': False}
    update_item(
        table_name, 
        {'user_id': '12345', 'email': 'user@example.com'},
        update_expression,
        expression_attribute_values
    )
    
    # Query items
    users = query_items(
        table_name,
        "user_id = :uid",
        {":uid": "12345"}
    )
    print(json.dumps(users, cls=DecimalEncoder))
