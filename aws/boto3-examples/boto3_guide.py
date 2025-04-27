"""
GIỚI THIỆU VỀ BOTO3 - AWS SDK CHO PYTHON

Boto3 là AWS SDK (Software Development Kit) chính thức cho Python, được sử dụng để:
1. Tương tác với các dịch vụ AWS từ code Python
2. Tự động hóa các tác vụ AWS
3. Xây dựng ứng dụng sử dụng cơ sở hạ tầng AWS

MỤC ĐÍCH SỬ DỤNG:

1. DevOps và Cloud Infrastructure:
   - Tự động hóa triển khai cơ sở hạ tầng (Infrastructure as Code)
   - Quản lý tài nguyên AWS (EC2, S3, RDS, v.v.)
   - Tự động hóa quy trình CI/CD

2. Development:
   - Xây dựng ứng dụng cloud-native
   - Truy cập dịch vụ AWS từ application code
   - Processing data trên AWS

3. SysOps và Quản trị:
   - Giám sát và quản lý tài nguyên AWS
   - Tự động hóa các tác vụ bảo trì
   - Thực hiện sao lưu và khôi phục

4. AWS Solutions Architect Associate (SAA):
   - Tạo và cấu hình service AWS theo kiến trúc chuẩn
   - Thực hiện proof-of-concept cho các giải pháp AWS
   - Hiểu sâu về AWS services thông qua thao tác trực tiếp

CÁC TÌNH HUỐNG SỬ DỤNG BOTO3:

1. AWS Lambda Functions:
   - Viết Lambda functions bằng Python để tương tác với AWS services khác
   - Tự động hóa các tác vụ định kỳ trên AWS

2. Quản lý EC2:
   - Tạo, khởi động, dừng các EC2 instances
   - Cấu hình security groups, elastic IPs

3. S3 Operations:
   - Upload/download files
   - Quản lý buckets và objects
   - Thiết lập lifecycle policies

4. DynamoDB và Database Operations:
   - CRUD operations trên DynamoDB
   - Quản lý RDS instances

5. Các dịch vụ khác:
   - Cấu hình VPC, subnets, route tables
   - IAM user/role/policy management
   - CloudFormation stacks
   - CloudWatch logs và metrics

LỢI ÍCH CỦA BOTO3:

1. API nhất quán: Interface đồng nhất giữa các dịch vụ AWS
2. Tự động hóa: Thay thế cho thao tác thủ công trên AWS Console
3. Reproducibility: Dễ dàng tái tạo cấu hình AWS thông qua code
4. Lập trình hóa: Tích hợp logic nghiệp vụ cùng quản lý cơ sở hạ tầng
5. Kiểm soát phiên bản: Infrastructure as Code dễ dàng version control
"""

# Ví dụ các tình huống sử dụng boto3 phổ biến:

def example_boto3_usage():
    import boto3
    
    # 1. EC2 Management - Quản lý EC2 instances
    ec2_client = boto3.client('ec2')
    ec2_client.run_instances(
        ImageId='ami-12345678',
        MinCount=1,
        MaxCount=5,
        InstanceType='t2.micro',
        SecurityGroupIds=['sg-12345678']
    )
    
    # 2. S3 Operations - Thao tác với S3
    s3_client = boto3.client('s3')
    s3_client.upload_file('local_file.txt', 'my-bucket', 'remote_file.txt')
    
    # 3. DynamoDB - Thao tác với NoSQL database
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('Users')
    table.put_item(
        Item={
            'user_id': '123',
            'name': 'John Doe',
            'email': 'john@example.com'
        }
    )
    
    # 4. IAM Management - Quản lý Identity and Access Management
    iam_client = boto3.client('iam')
    iam_client.create_user(UserName='new-user')
    
    # 5. CloudWatch Logs & Monitoring - Giám sát và logging
    logs_client = boto3.client('logs')
    logs_client.create_log_group(logGroupName='/aws/lambda/my-function')
    
    # 6. Lambda Management - Quản lý serverless functions
    lambda_client = boto3.client('lambda')
    lambda_client.invoke(
        FunctionName='my-function',
        InvocationType='Event',
        Payload='{"key": "value"}'
    )

# Ví dụ thực tế cho một AWS Solutions Architect
def saa_architecture_automation():
    """
    Ví dụ về cách AWS Solutions Architect có thể sử dụng boto3 để tự động hóa
    việc triển khai một kiến trúc web application 3-tier
    """
    import boto3
    import json
    
    # 1. Tạo VPC và network components
    ec2 = boto3.resource('ec2')
    vpc = ec2.create_vpc(CidrBlock='10.0.0.0/16')
    vpc.create_tags(Tags=[{'Key': 'Name', 'Value': 'Production-VPC'}])
    
    # 2. Tạo security groups
    web_sg = ec2.create_security_group(
        GroupName='WebSG',
        Description='Web Security Group',
        VpcId=vpc.id
    )
    web_sg.authorize_ingress(
        IpProtocol='tcp',
        FromPort=80,
        ToPort=80,
        CidrIp='0.0.0.0/0'
    )
    
    # 3. Deploy RDS database
    rds = boto3.client('rds')
    rds.create_db_instance(
        DBName='proddb',
        DBInstanceIdentifier='prod-mysql',
        AllocatedStorage=20,
        DBInstanceClass='db.t3.micro',
        Engine='mysql',
        MasterUsername='admin',
        MasterUserPassword='securepassword',
        VpcSecurityGroupIds=[web_sg.id]
    )
    
    # 4. Create S3 bucket for static assets
    s3 = boto3.client('s3')
    s3.create_bucket(Bucket='my-web-assets')
    
    # 5. Setup Auto Scaling Group
    autoscaling = boto3.client('autoscaling')
    autoscaling.create_auto_scaling_group(
        AutoScalingGroupName='WebASG',
        MinSize=2,
        MaxSize=5,
        DesiredCapacity=2,
        LaunchConfigurationName='WebServerLC',
        VPCZoneIdentifier='subnet-1234,subnet-5678'
    )
    
    # 6. Create CloudFront distribution
    cloudfront = boto3.client('cloudfront')
    cloudfront.create_distribution(
        DistributionConfig={
            'Origins': {
                'Items': [
                    {
                        'Id': 's3-origin',
                        'DomainName': 'my-web-assets.s3.amazonaws.com',
                        'S3OriginConfig': {
                            'OriginAccessIdentity': ''
                        }
                    }
                ],
                'Quantity': 1
            },
            'DefaultCacheBehavior': {
                'TargetOriginId': 's3-origin',
                'ViewerProtocolPolicy': 'redirect-to-https',
                'AllowedMethods': {
                    'Items': ['GET', 'HEAD'],
                    'Quantity': 2
                }
            },
            'Enabled': True
        }
    )
