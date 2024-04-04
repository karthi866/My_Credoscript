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
# Check if MySQL service is running
if systemctl is-active --quiet mysqld.service; then
    echo "MySQL service is running."
else
    systemctl start mysqld.service
    if systemctl is-active --quiet mysqld.service; then
        echo "MySQL service has started successfully."
    else
        echo "Failed to start MySQL service."
        systemctl status mysqld.service
    fi
fi

# Check if jpos service is running

if systemctl is-active --quiet jpos.service; then
    echo "jpos service is running."
else
    systemctl start jpos.service
    if systemctl is-active --quiet jpos.service; then
        echo "jpos service has started successfully."
    else
        echo "Failed to start jpos.service."
        systemctl status jpos.service
    fi
fi

# Check if cpbs_switch.service service is running

if systemctl is-active --quiet cpbs_switch.service; then
    echo "cpbs_switch.service is running."
else
    systemctl start cpbs_switch.service
    if systemctl is-active --quiet cpbs_switch.service; then
        echo "cpbs_switch.service has started successfully."
    else
        echo "Failed to start cpbs_switch.service."
        systemctl status cpbs_switch.service
    fi
fi

# Start Tomcat app
echo "Starting Tomcat app..."
cd /App/apache-tomcat-9.0.82
if bash -x bin/startup.sh; then
    echo "Tomcat has been started successfully"
else
    echo "Tomcat is not started"
fi