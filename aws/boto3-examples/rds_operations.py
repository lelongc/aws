import boto3
import logging
from botocore.exceptions import ClientError
import time

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Initialize RDS client
rds_client = boto3.client('rds')

def create_db_instance(db_instance_identifier, db_name, engine, engine_version, 
                      instance_class, storage_size, master_username, master_password,
                      vpc_security_group_ids=None, db_subnet_group_name=None,
                      multi_az=False, publicly_accessible=False):
    """
    Create an RDS database instance
    
    Parameters:
    - db_instance_identifier: Unique identifier for the DB instance
    - db_name: Name for the database to create
    - engine: Database engine (e.g., 'mysql', 'postgres')
    - engine_version: Database engine version
    - instance_class: DB instance class (e.g., 'db.t3.micro')
    - storage_size: Size in GB for the database storage
    - master_username: Master username for the database
    - master_password: Master password for the database
    - vpc_security_group_ids: List of VPC security group IDs
    - db_subnet_group_name: Name of the DB subnet group
    - multi_az: Whether to deploy as Multi-AZ for high availability
    - publicly_accessible: Whether the DB can be publicly accessed
    """
    try:
        kwargs = {
            'DBInstanceIdentifier': db_instance_identifier,
            'DBName': db_name,
            'Engine': engine,
            'EngineVersion': engine_version,
            'DBInstanceClass': instance_class,
            'AllocatedStorage': storage_size,
            'MasterUsername': master_username,
            'MasterUserPassword': master_password,
            'MultiAZ': multi_az,
            'PubliclyAccessible': publicly_accessible
        }
        
        if vpc_security_group_ids:
            kwargs['VpcSecurityGroupIds'] = vpc_security_group_ids
            
        if db_subnet_group_name:
            kwargs['DBSubnetGroupName'] = db_subnet_group_name
            
        response = rds_client.create_db_instance(**kwargs)
        logger.info(f"Creating RDS instance {db_instance_identifier}")
        return response
    except ClientError as e:
        logger.error(f"Error creating RDS instance {db_instance_identifier}: {e}")
        return None

def delete_db_instance(db_instance_identifier, skip_final_snapshot=False, 
                      final_snapshot_identifier=None):
    """Delete an RDS database instance"""
    try:
        kwargs = {
            'DBInstanceIdentifier': db_instance_identifier,
            'SkipFinalSnapshot': skip_final_snapshot
        }
        
        if not skip_final_snapshot and final_snapshot_identifier:
            kwargs['FinalDBSnapshotIdentifier'] = final_snapshot_identifier
            
        response = rds_client.delete_db_instance(**kwargs)
        logger.info(f"Deleting RDS instance {db_instance_identifier}")
        return response
    except ClientError as e:
        logger.error(f"Error deleting RDS instance {db_instance_identifier}: {e}")
        return None

def describe_db_instances(db_instance_identifier=None):
    """Describe RDS instances"""
    try:
        kwargs = {}
        if db_instance_identifier:
            kwargs['DBInstanceIdentifier'] = db_instance_identifier
            
        response = rds_client.describe_db_instances(**kwargs)
        instances = response.get('DBInstances', [])
        
        if db_instance_identifier:
            if instances:
                logger.info(f"Retrieved information for RDS instance {db_instance_identifier}")
                return instances[0]
            else:
                logger.warning(f"No RDS instance found with identifier {db_instance_identifier}")
                return None
        else:
            instance_ids = [instance['DBInstanceIdentifier'] for instance in instances]
            logger.info(f"Found {len(instances)} RDS instances: {', '.join(instance_ids)}")
            return instances
    except ClientError as e:
        error_msg = f"Error describing RDS instance {db_instance_identifier}" if db_instance_identifier else "Error describing RDS instances"
        logger.error(f"{error_msg}: {e}")
        return None

def modify_db_instance(db_instance_identifier, **kwargs):
    """
    Modify an RDS instance
    
    Parameters:
    - db_instance_identifier: ID of the instance to modify
    - **kwargs: Parameters to modify (e.g., DBInstanceClass, AllocatedStorage)
    """
    try:
        kwargs['DBInstanceIdentifier'] = db_instance_identifier
        response = rds_client.modify_db_instance(**kwargs)
        logger.info(f"Modified RDS instance {db_instance_identifier}")
        return response
    except ClientError as e:
        logger.error(f"Error modifying RDS instance {db_instance_identifier}: {e}")
        return None

def create_db_snapshot(db_instance_identifier, snapshot_identifier):
    """Create a snapshot of an RDS instance"""
    try:
        response = rds_client.create_db_snapshot(
            DBSnapshotIdentifier=snapshot_identifier,
            DBInstanceIdentifier=db_instance_identifier
        )
        logger.info(f"Creating snapshot {snapshot_identifier} for RDS instance {db_instance_identifier}")
        return response
    except ClientError as e:
        logger.error(f"Error creating snapshot for RDS instance {db_instance_identifier}: {e}")
        return None

def restore_db_from_snapshot(snapshot_identifier, new_db_instance_identifier, 
                           instance_class=None, vpc_security_group_ids=None, 
                           db_subnet_group_name=None, publicly_accessible=False):
    """Restore an RDS instance from a snapshot"""
    try:
        kwargs = {
            'DBSnapshotIdentifier': snapshot_identifier,
            'DBInstanceIdentifier': new_db_instance_identifier,
            'PubliclyAccessible': publicly_accessible
        }
        
        if instance_class:
            kwargs['DBInstanceClass'] = instance_class
            
        if vpc_security_group_ids:
            kwargs['VpcSecurityGroupIds'] = vpc_security_group_ids
            
        if db_subnet_group_name:
            kwargs['DBSubnetGroupName'] = db_subnet_group_name
            
        response = rds_client.restore_db_instance_from_db_snapshot(**kwargs)
        logger.info(f"Restoring RDS instance {new_db_instance_identifier} from snapshot {snapshot_identifier}")
        return response
    except ClientError as e:
        logger.error(f"Error restoring from snapshot {snapshot_identifier}: {e}")
        return None

def wait_for_db_instance_status(db_instance_identifier, target_status, max_attempts=60, delay_seconds=10):
    """Wait for an RDS instance to reach a specific status"""
    try:
        for attempt in range(1, max_attempts + 1):
            instance_info = describe_db_instances(db_instance_identifier)
            
            if not instance_info:
                logger.warning(f"Instance {db_instance_identifier} not found")
                return False
                
            status = instance_info['DBInstanceStatus']
            logger.info(f"Attempt {attempt}/{max_attempts}: Instance {db_instance_identifier} status: {status}")
            
            if status == target_status:
                logger.info(f"Instance {db_instance_identifier} reached status {target_status}")
                return True
                
            if attempt < max_attempts:
                time.sleep(delay_seconds)
        
        logger.warning(f"Timed out waiting for instance {db_instance_identifier} to reach status {target_status}")
        return False
    except Exception as e:
        logger.error(f"Error waiting for instance status: {e}")
        return False

# Example usage
if __name__ == "__main__":
    # Replace with your values
    db_instance_identifier = 'my-db-instance'
    
    # Create RDS instance
    create_db_instance(
        db_instance_identifier,
        'mydb',
        'mysql',
        '8.0.28',
        'db.t3.micro',
        20,
        'admin',
        'Password123!',
        multi_az=False,
        publicly_accessible=False
    )
    
    # Wait for instance to become available
    wait_for_db_instance_status(db_instance_identifier, 'available')
