#!/bin/bash
set -e

# Update packages
yum update -y

# Install common utilities
yum install -y htop git curl wget unzip

# Install CloudWatch agent
yum install -y amazon-cloudwatch-agent

# Start CloudWatch agent
systemctl enable amazon-cloudwatch-agent
systemctl start amazon-cloudwatch-agent

# Setup a basic web server
if command -v nginx &>/dev/null; then
    echo "Nginx is already installed"
else
    amazon-linux-extras install nginx1 -y
    systemctl enable nginx
    systemctl start nginx
fi

# Configure the web page
cat <<EOF > /usr/share/nginx/html/index.html
<!DOCTYPE html>
<html>
<head>
    <title>Hello from Terraform</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 50px;
            background-color: #f4f4f4;
        }
        .container {
            background-color: white;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            max-width: 800px;
            margin: 0 auto;
        }
        h1 {
            color: #333;
        }
        .info {
            background-color: #e9f7ef;
            padding: 15px;
            border-radius: 5px;
            margin-top: 20px;
        }
        .env {
            color: #2ecc71;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Hello from Terraform!</h1>
        <p>This server was provisioned using Infrastructure as Code.</p>
        <div class="info">
            <p>Environment: <span class="env">${environment}</span></p>
            <p>Instance ID: <span class="env" id="instance-id">Loading...</span></p>
            <p>Availability Zone: <span class="env" id="az">Loading...</span></p>
        </div>
    </div>
    <script>
        fetch('http://169.254.169.254/latest/meta-data/instance-id')
            .then(response => response.text())
            .then(data => {
                document.getElementById('instance-id').textContent = data;
            });
        fetch('http://169.254.169.254/latest/meta-data/placement/availability-zone')
            .then(response => response.text())
            .then(data => {
                document.getElementById('az').textContent = data;
            });
    </script>
</body>
</html>
EOF

# Set appropriate permissions
chmod 644 /usr/share/nginx/html/index.html
chown root:root /usr/share/nginx/html/index.html
systemctl restart nginx

# Tag the instance (useful for discovery)
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/region)

aws ec2 create-tags \
  --resources $INSTANCE_ID \
  --tags Key=Name,Value="$(hostname)" \
  --region $REGION

echo "User data script completed"
