#!/bin/bash

# Script to install Jenkins on Ubuntu servers

# Update system packages
echo "Updating system packages..."
sudo apt-get update
sudo apt-get upgrade -y

# Install Java
echo "Installing Java..."
sudo apt-get install -y openjdk-11-jdk

# Add Jenkins repository
echo "Adding Jenkins repository..."
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

# Install Jenkins
echo "Installing Jenkins..."
sudo apt-get update
sudo apt-get install -y jenkins

# Start Jenkins
echo "Starting Jenkins service..."
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Install Docker
echo "Installing Docker..."
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Add Jenkins user to Docker group
echo "Adding jenkins user to docker group..."
sudo usermod -aG docker jenkins

# Restart Jenkins
echo "Restarting Jenkins service..."
sudo systemctl restart jenkins

# Install useful tools
echo "Installing additional tools..."
sudo apt-get install -y git maven curl

# Print admin password
echo "Jenkins is installed successfully!"
echo "Your initial admin password is:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
echo ""

# Print Jenkins URL
echo "Access Jenkins at: http://$(hostname -I | awk '{print $1}'):8080"
echo "Follow the setup wizard to complete the installation."
