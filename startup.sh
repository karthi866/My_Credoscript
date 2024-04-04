#!/bin/bash

echo "Checking the nginx service"
if [ -e /var/run/nginx.pid ]; then
    echo "Nginx is already started"
else
    systemctl start nginx
    if [ "$?" -ne 0 ]; then
        echo "Failed to start Nginx. Exiting..."
        exit 1
    fi
    echo "Nginx has successfully started"
fi

echo "Need to start pm2"
cd /App/Ind-App/BackEnd_Apps || exit 1
pm2 start switch-*.json
cd - || exit 1

echo "Checking if the folder is already mounted"
if mount | grep -q "/mnt/cpbsshare"; then
    echo "Folder is already mounted"
else
    echo "Need to mount the share folder"
    mkdir -p /mnt/cpbsshare
    mount -a
    if [ "$?" -ne 0 ]; then
        echo "Failed to mount the folder. Exiting..."
        exit 1
    fi
    echo "Folder has been successfully mounted"
fi
