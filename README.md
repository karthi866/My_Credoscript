# My_Credoscript
#Shell scripts
#!/bin/bash

# Using date to get the timestamp

TIME=$(date +"%Y%m%d%H")
#read binary
read -p "Enter Your Binary Name: " binary

JSON="$binary.testing.json"
# Change to the desired directory
cd /APP01/Ind-app/BackEnd_Apps/

# Stop and delete the 'process' using pm2
pm2 stop $binary && pm2 delete $binary

# Check if the pm2 command was successful
if [ "$?" -eq 0 ]; then
    echo "pm2 stopped and deleted successfully"

    # Move the task file to the backup folder with a timestamp
    mv $binary /SharedDisk/Files/switch-app$binary$TIME

    # Check if the move was successful
    if [ "$?" -eq 0 ]; then
        echo "The current-binary file has been moved to the backup folder"

        # Copy files from source to destination
        cp /mnt/cpbsshare/$binary /APP01/Ind-app/BackEnd_Apps/

        # Check if the copy was successful
        if [ "$?" -eq 0 ]; then
            echo "Files copied successfully and move to Deployment direcory"
                        # Start pm2 using a JSON configuration file
            pm2 start $JSON

            pm2 log $binary

                exit 0

            # Check if pm2 started successfully
            if [ "$?" -ne 0 ]; then
                echo "pm2 did not start successfully, the deployment was not completed."
            fi
        else
            echo "The file was not copied from the bucket"
        fi
    else
        echo "The task file was not moved to the backup folder"
    fi
else
    echo "pm2 was not stopped and not deleted "
fi
