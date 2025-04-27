import boto3
import logging
from botocore.exceptions import ClientError

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Initialize EC2 client and resource
ec2_client = boto3.client('ec2')
ec2_resource = boto3.resource('ec2')

def create_vpc(cidr_block, name=None, enable_dns_support=True, enable_dns_hostnames=True):
    """
    Create a new VPC
    
    Parameters:
    - cidr_block: CIDR block for the VPC (e.g., '10.0.0.0/16')
    - name: Name tag for the VPC
    - enable_dns_support: Enable DNS resolution
    - enable_dns_hostnames: Enable DNS hostnames
    """
    try:
        vpc = ec2_resource.create_vpc(
            CidrBlock=cidr_block,
            AmazonProvidedIpv6CidrBlock=False
        )
        
        # Wait until VPC is available
        vpc.wait_until_available()
        
        # Modify VPC attributes
        vpc.modify_attribute(EnableDnsSupport={'Value': enable_dns_support})
        vpc.modify_attribute(EnableDnsHostnames={'Value': enable_dns_hostnames})
        
        # Add name tag if provided
        if name:
            vpc.create_tags(Tags=[{'Key': 'Name', 'Value': name}])
            
        logger.info(f"Created VPC {vpc.id} with CIDR {cidr_block}")
        return vpc
    except ClientError as e:
        logger.error(f"Error creating VPC: {e}")
        return None

def delete_vpc(vpc_id):
    """Delete a VPC"""
    try:
        vpc = ec2_resource.Vpc(vpc_id)
        vpc.delete()
        logger.info(f"Deleted VPC {vpc_id}")
        return True
    except ClientError as e:
        logger.error(f"Error deleting VPC {vpc_id}: {e}")
        return False

def create_subnet(vpc_id, cidr_block, availability_zone=None, name=None, map_public_ip=False):
    """
    Create a subnet in a VPC
    
    Parameters:
    - vpc_id: ID of the VPC
    - cidr_block: CIDR block for the subnet
    - availability_zone: Optional AZ for the subnet
    - name: Name tag for the subnet
    - map_public_ip: Whether to map public IPs to instances in the subnet
    """
    try:
        kwargs = {
            'VpcId': vpc_id,
            'CidrBlock': cidr_block
        }
        
        if availability_zone:
            kwargs['AvailabilityZone'] = availability_zone
            
        subnet = ec2_resource.create_subnet(**kwargs)
        
        # Map public IP addresses on launch if requested
        if map_public_ip:
            ec2_client.modify_subnet_attribute(
                SubnetId=subnet.id,
                MapPublicIpOnLaunch={'Value': map_public_ip}
            )
        
        # Add name tag if provided
        if name:
            subnet.create_tags(Tags=[{'Key': 'Name', 'Value': name}])
            
        logger.info(f"Created subnet {subnet.id} in VPC {vpc_id} with CIDR {cidr_block}")
        return subnet
    except ClientError as e:
        logger.error(f"Error creating subnet in VPC {vpc_id}: {e}")
        return None

def create_internet_gateway(name=None):
    """Create an Internet Gateway"""
    try:
        igw = ec2_resource.create_internet_gateway()
        
        # Add name tag if provided
        if name:
            igw.create_tags(Tags=[{'Key': 'Name', 'Value': name}])
            
        logger.info(f"Created Internet Gateway {igw.id}")
        return igw
    except ClientError as e:
        logger.error(f"Error creating Internet Gateway: {e}")
        return None

def attach_internet_gateway(vpc_id, igw_id):
    """Attach Internet Gateway to a VPC"""
    try:
        vpc = ec2_resource.Vpc(vpc_id)
        igw = ec2_resource.InternetGateway(igw_id)
        vpc.attach_internet_gateway(InternetGatewayId=igw_id)
        logger.info(f"Attached Internet Gateway {igw_id} to VPC {vpc_id}")
        return True
    except ClientError as e:
        logger.error(f"Error attaching Internet Gateway {igw_id} to VPC {vpc_id}: {e}")
        return False

def create_route_table(vpc_id, name=None):
    """Create a route table in a VPC"""
    try:
        vpc = ec2_resource.Vpc(vpc_id)
        route_table = vpc.create_route_table()
        
        # Add name tag if provided
        if name:
            route_table.create_tags(Tags=[{'Key': 'Name', 'Value': name}])
            
        logger.info(f"Created route table {route_table.id} in VPC {vpc_id}")
        return route_table
    except ClientError as e:
        logger.error(f"Error creating route table in VPC {vpc_id}: {e}")
        return None

def create_route(route_table_id, destination_cidr, gateway_id=None, instance_id=None, nat_gateway_id=None):
    """Create a route in a route table"""
    try:
        route_table = ec2_resource.RouteTable(route_table_id)
        
        kwargs = {
            'DestinationCidrBlock': destination_cidr
        }
        
        if gateway_id:
            kwargs['GatewayId'] = gateway_id
        elif instance_id:
            kwargs['InstanceId'] = instance_id
        elif nat_gateway_id:
            kwargs['NatGatewayId'] = nat_gateway_id
        else:
            logger.error("One of gateway_id, instance_id, or nat_gateway_id must be provided")
            return False
            
        route = route_table.create_route(**kwargs)
        logger.info(f"Created route in route table {route_table_id} to {destination_cidr}")
        return route
    except ClientError as e:
        logger.error(f"Error creating route in route table {route_table_id}: {e}")
        return False

def associate_route_table(route_table_id, subnet_id):
    """Associate a subnet with a route table"""
    try:
        route_table = ec2_resource.RouteTable(route_table_id)
        association = route_table.associate_with_subnet(SubnetId=subnet_id)
        logger.info(f"Associated subnet {subnet_id} with route table {route_table_id}")
        return association.id
    except ClientError as e:
        logger.error(f"Error associating subnet {subnet_id} with route table {route_table_id}: {e}")
        return None

def create_nat_gateway(subnet_id, allocation_id=None, name=None):
    """
    Create a NAT Gateway
    
    Parameters:
    - subnet_id: ID of the subnet to place the NAT Gateway
    - allocation_id: Elastic IP allocation ID (if None, a new EIP is allocated)
    - name: Name tag for the NAT Gateway
    """
    try:
        # Allocate an Elastic IP if not provided
        if not allocation_id:
            eip = ec2_client.allocate_address(Domain='vpc')
            allocation_id = eip['AllocationId']
            logger.info(f"Allocated Elastic IP {eip['PublicIp']} with ID {allocation_id}")
            
        # Create NAT Gateway
        response = ec2_client.create_nat_gateway(
            SubnetId=subnet_id,
            AllocationId=allocation_id
        )
        
        nat_gateway_id = response['NatGateway']['NatGatewayId']
        
        # Add name tag if provided
        if name:
            ec2_client.create_tags(
                Resources=[nat_gateway_id],
                Tags=[{'Key': 'Name', 'Value': name}]
            )
            
        logger.info(f"Creating NAT Gateway {nat_gateway_id} in subnet {subnet_id}")
        return nat_gateway_id
    except ClientError as e:
        logger.error(f"Error creating NAT Gateway in subnet {subnet_id}: {e}")
        return None

def create_security_group(vpc_id, name, description):
    """Create a security group in a VPC"""
    try:
        security_group = ec2_resource.create_security_group(
            VpcId=vpc_id,
            GroupName=name,
            Description=description
        )
        
        logger.info(f"Created security group {security_group.id} in VPC {vpc_id}")
        return security_group
    except ClientError as e:
        logger.error(f"Error creating security group in VPC {vpc_id}: {e}")
        return None

def add_security_group_rule(security_group_id, ip_protocol, from_port, to_port, 
                          cidr_ip=None, source_security_group_id=None):
    """Add an inbound rule to a security group"""
    try:
        security_group = ec2_resource.SecurityGroup(security_group_id)
        
        kwargs = {
            'IpProtocol': ip_protocol,
            'FromPort': from_port,
            'ToPort': to_port
        }
        
        if cidr_ip:
            kwargs['CidrIp'] = cidr_ip
        elif source_security_group_id:
            kwargs['SourceSecurityGroupId'] = source_security_group_id
        else:
            logger.error("Either cidr_ip or source_security_group_id must be provided")
            return False
            
        security_group.authorize_ingress(
            GroupId=security_group_id,
            IpPermissions=[kwargs]
        )
        
        logger.info(f"Added inbound rule to security group {security_group_id}")
        return True
    except ClientError as e:
        logger.error(f"Error adding rule to security group {security_group_id}: {e}")
        return False

def get_vpc_info(vpc_id):
    """Get comprehensive information about a VPC and its resources"""
    try:
        vpc = ec2_resource.Vpc(vpc_id)
        
        # Basic VPC info
        vpc_info = {
            'VpcId': vpc.id,
            'CidrBlock': vpc.cidr_block,
            'State': vpc.state,
            'IsDefault': vpc.is_default,
            'DhcpOptionsId': vpc.dhcp_options_id,
            'Tags': vpc.tags or []
        }
        
        # Subnets
        vpc_info['Subnets'] = []
        for subnet in vpc.subnets.all():
            vpc_info['Subnets'].append({
                'SubnetId': subnet.id,
                'CidrBlock': subnet.cidr_block,
                'AvailabilityZone': subnet.availability_zone,
                'State': subnet.state,
                'Tags': subnet.tags or []
            })
            
        # Route tables
        vpc_info['RouteTables'] = []
        for rt in vpc.route_tables.all():
            routes = []
            for route in rt.routes:
                routes.append({
                    'DestinationCidrBlock': route.destination_cidr_block,
                    'GatewayId': getattr(route, 'gateway_id', None),
                    'NatGatewayId': getattr(route, 'nat_gateway_id', None),
                    'State': route.state
                })
                
            vpc_info['RouteTables'].append({
                'RouteTableId': rt.id,
                'Routes': routes,
                'Associations': [assoc.subnet_id for assoc in rt.associations],
                'Tags': rt.tags or []
            })
            
        # Security groups
        vpc_info['SecurityGroups'] = []
        for sg in vpc.security_groups.all():
            vpc_info['SecurityGroups'].append({
                'GroupId': sg.id,
                'GroupName': sg.group_name,
                'Description': sg.description,
                'Tags': sg.tags or []
            })
            
        logger.info(f"Retrieved VPC information for {vpc_id}")
        return vpc_info
    except ClientError as e:
        logger.error(f"Error getting VPC info for {vpc_id}: {e}")
        return None

# Example usage
if __name__ == "__main__":
    # Create a VPC with a public and private subnet
    vpc = create_vpc('10.0.0.0/16', 'MyVPC')
    
    if vpc:
        # Create subnets
        public_subnet = create_subnet(vpc.id, '10.0.1.0/24', name='PublicSubnet', map_public_ip=True)
        private_subnet = create_subnet(vpc.id, '10.0.2.0/24', name='PrivateSubnet')
        
        # Create and attach Internet Gateway
        igw = create_internet_gateway('MyIGW')
        attach_internet_gateway(vpc.id, igw.id)
        
        # Create route tables
        public_rt = create_route_table(vpc.id, 'PublicRouteTable')
        private_rt = create_route_table(vpc.id, 'PrivateRouteTable')
        
        # Add route to IGW in public route table
        create_route(public_rt.id, '0.0.0.0/0', gateway_id=igw.id)
        
        # Associate route tables with subnets
        associate_route_table(public_rt.id, public_subnet.id)
        associate_route_table(private_rt.id, private_subnet.id)
        
        # Create NAT Gateway in public subnet
        nat_gateway_id = create_nat_gateway(public_subnet.id, name='MyNATGateway')
        
        # Add route to NAT Gateway in private route table
        create_route(private_rt.id, '0.0.0.0/0', nat_gateway_id=nat_gateway_id)
        
        # Create security groups
        sg = create_security_group(vpc.id, 'WebServerSG', 'Web Server Security Group')
        add_security_group_rule(sg.id, 'tcp', 80, 80, cidr_ip='0.0.0.0/0')
        add_security_group_rule(sg.id, 'tcp', 22, 22, cidr_ip='10.0.0.0/16')
