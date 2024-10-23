#!/bin/bash

# Install necessary packages
sudo yum install git -y
sudo yum install java -y
sudo yum install maven -y

# Uncomment if Docker is required
# sudo yum install docker -y
# sudo systemctl start docker

# Check if the addressbook directory exists
if [ -d "/home/ec2-user/addressbook" ]; then
    echo "Repository is cloned and exists."
    cd /home/ec2-user/addressbook || exit
    git pull origin master
else
    echo "Cloning the repository..."
    git clone https://github.com/preethid/addressbook.git /home/ec2-user/addressbook
    cd /home/ec2-user/addressbook || exit
    git checkout master
fi

# Build the Docker image (ensure you pass arguments $1 and $2 when running the script)
if command -v docker >/dev/null; then
    sudo docker build -t "$1:$2" /home/ec2-user/addressbook
else
    echo "Docker is not installed or not in the PATH."
    exit 1
fi
# Run Maven package command
mvn package