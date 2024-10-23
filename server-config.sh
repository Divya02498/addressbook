#!/bin/bash

# Function to install a package if not already installed
install_package() {
    if ! command -v "$1" &> /dev/null; then
        echo "Installing $1..."
        sudo yum install "$1" -y
    else
        echo "$1 is already installed."
    fi
}

# Install necessary packages
install_package git
install_package java
install_package maven

# Uncomment if Docker is required
# install_package docker
# sudo systemctl start docker

# Check if the addressbook directory exists
REPO_DIR="/home/ec2-user/addressbook"
if [ -d "$REPO_DIR" ]; then
    echo "Repository is cloned and exists."
    cd "$REPO_DIR" || { echo "Failed to change directory."; exit 1; }
    git pull origin master
else
    echo "Cloning the repository..."
    git clone https://github.com/preethid/addressbook.git "$REPO_DIR"
    cd "$REPO_DIR" || { echo "Failed to change directory."; exit 1; }
    git checkout master
fi

# Build the Docker image (ensure you pass arguments $1 and $2 when running the script)
if command -v docker &> /dev/null; then
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "Usage: $0 <image_name> <image_tag>"
        exit 1
    fi
    sudo docker build -t "$1:$2" "$REPO_DIR"
else
    echo "Docker is not installed or not in the PATH."
    exit 1
fi

# Run Maven package command
if mvn package; then
    echo "Maven package completed successfully."
else
    echo "Maven package failed."
    exit 1
fi
