#!/bin/bash

# Get the current timestamp
TIME=$(date +"%Y%m%d%H")

# Navigate to the directory containing configuration files
cd /APP01/Ind-app/BackEnd_Apps/config

# Prompt the user to enter the binary name
read -p "Enter the binary name to change the permissions file: " binary

# Check if the directory for the binary exists
if [ ! -d "$binary" ]; then
    echo "Error: Directory for binary '$binary' does not exist"
    exit 1
fi

# Backup the permissions.json file with timestamp
mv "$binary/permissions.json" "$binary/permissions.json.$TIME"
if [ "$?" -eq 0 ]; then
    echo "The permissions file has been backed up"
else
    echo "Error: Failed to backup the permissions file"
    exit 1
fi

# Copy the new permissions.json file from the shared location
cp /mnt/cpbsshare/permissions.json "$binary/permissions.json"
if [ "$?" -eq 0 ]; then
    # Reload the binary using pm2
    cd /APP01/Ind-app/BackEnd_Apps
    pm2 reload "ucpbs-$binary"
    echo "The permissions file has been updated successfully"
else
    echo "Error: Failed to update the permissions file"
    exit 1
fi