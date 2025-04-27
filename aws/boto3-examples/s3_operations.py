import boto3
import logging
from botocore.exceptions import ClientError

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Initialize S3 client and resource
s3_client = boto3.client('s3')
s3_resource = boto3.resource('s3')

def create_bucket(bucket_name, region=None):
    """Create an S3 bucket"""
    try:
        if region is None:
            s3_client.create_bucket(Bucket=bucket_name)
        else:
            location = {'LocationConstraint': region}
            s3_client.create_bucket(
                Bucket=bucket_name,
                CreateBucketConfiguration=location
            )
        logger.info(f"Created bucket {bucket_name}")
        return True
    except ClientError as e:
        logger.error(f"Error creating bucket {bucket_name}: {e}")
        return False

def list_buckets():
    """List all S3 buckets"""
    try:
        response = s3_client.list_buckets()
        buckets = [bucket['Name'] for bucket in response['Buckets']]
        logger.info(f"Found {len(buckets)} buckets: {', '.join(buckets)}")
        return buckets
    except ClientError as e:
        logger.error(f"Error listing buckets: {e}")
        return []

def upload_file(file_path, bucket_name, object_name=None):
    """Upload a file to an S3 bucket"""
    if object_name is None:
        import os
        object_name = os.path.basename(file_path)
    
    try:
        s3_client.upload_file(file_path, bucket_name, object_name)
        logger.info(f"Uploaded {file_path} to {bucket_name}/{object_name}")
        return True
    except ClientError as e:
        logger.error(f"Error uploading file {file_path}: {e}")
        return False

def download_file(bucket_name, object_name, file_path):
    """Download a file from an S3 bucket"""
    try:
        s3_client.download_file(bucket_name, object_name, file_path)
        logger.info(f"Downloaded {bucket_name}/{object_name} to {file_path}")
        return True
    except ClientError as e:
        logger.error(f"Error downloading file {object_name}: {e}")
        return False

def list_objects(bucket_name, prefix=''):
    """List objects in an S3 bucket"""
    try:
        response = s3_client.list_objects_v2(
            Bucket=bucket_name,
            Prefix=prefix
        )
        
        if 'Contents' in response:
            objects = [obj['Key'] for obj in response['Contents']]
            logger.info(f"Found {len(objects)} objects in {bucket_name}/{prefix}")
            return objects
        else:
            logger.info(f"No objects found in {bucket_name}/{prefix}")
            return []
    except ClientError as e:
        logger.error(f"Error listing objects in {bucket_name}/{prefix}: {e}")
        return []

def delete_object(bucket_name, object_name):
    """Delete an object from an S3 bucket"""
    try:
        s3_client.delete_object(Bucket=bucket_name, Key=object_name)
        logger.info(f"Deleted {object_name} from {bucket_name}")
        return True
    except ClientError as e:
        logger.error(f"Error deleting object {object_name}: {e}")
        return False

def delete_bucket(bucket_name):
    """Delete an S3 bucket (must be empty)"""
    try:
        s3_client.delete_bucket(Bucket=bucket_name)
        logger.info(f"Deleted bucket {bucket_name}")
        return True
    except ClientError as e:
        logger.error(f"Error deleting bucket {bucket_name}: {e}")
        return False

def enable_bucket_versioning(bucket_name):
    """Enable versioning for a bucket"""
    try:
        s3_client.put_bucket_versioning(
            Bucket=bucket_name,
            VersioningConfiguration={'Status': 'Enabled'}
        )
        logger.info(f"Enabled versioning for bucket {bucket_name}")
        return True
    except ClientError as e:
        logger.error(f"Error enabling versioning for bucket {bucket_name}: {e}")
        return False

def generate_presigned_url(bucket_name, object_name, expiration=3600):
    """Generate a presigned URL for an S3 object"""
    try:
        response = s3_client.generate_presigned_url('get_object',
                                                    Params={'Bucket': bucket_name,
                                                            'Key': object_name},
                                                    ExpiresIn=expiration)
        logger.info(f"Generated presigned URL for {bucket_name}/{object_name}")
        return response
    except ClientError as e:
        logger.error(f"Error generating presigned URL for {object_name}: {e}")
        return None

def copy_object(source_bucket, source_key, dest_bucket, dest_key):
    """Copy an object from one S3 location to another"""
    try:
        copy_source = {
            'Bucket': source_bucket,
            'Key': source_key
        }
        s3_resource.meta.client.copy(copy_source, dest_bucket, dest_key)
        logger.info(f"Copied {source_bucket}/{source_key} to {dest_bucket}/{dest_key}")
        return True
    except ClientError as e:
        logger.error(f"Error copying {source_key}: {e}")
        return False

def create_folder(bucket_name, folder_name):
    """Create a 'folder' in S3 bucket by creating an empty object with trailing /"""
    if not folder_name.endswith('/'):
        folder_name += '/'
    
    try:
        s3_client.put_object(Bucket=bucket_name, Key=folder_name, Body='')
        logger.info(f"Created folder {folder_name} in bucket {bucket_name}")
        return True
    except ClientError as e:
        logger.error(f"Error creating folder {folder_name}: {e}")
        return False

def set_bucket_policy(bucket_name, policy):
    """Set a bucket policy"""
    try:
        s3_client.put_bucket_policy(Bucket=bucket_name, Policy=policy)
        logger.info(f"Set policy for bucket {bucket_name}")
        return True
    except ClientError as e:
        logger.error(f"Error setting policy for bucket {bucket_name}: {e}")
        return False

# Example usage
if __name__ == "__main__":
    # Replace with your values
    bucket_name = "my-test-bucket-12345"
    file_path = "local_file.txt"
    
    # Basic operations
    create_bucket(bucket_name)
    list_buckets()
    upload_file(file_path, bucket_name)
    list_objects(bucket_name)
    download_file(bucket_name, "local_file.txt", "downloaded_file.txt")
    enable_bucket_versioning(bucket_name)
