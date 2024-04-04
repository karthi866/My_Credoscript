echo "check the nginx service"
ls -al /var/run/nginx.pid
if [ "$?" -eq 0 ]
the nginx is already started
else
systemctl start nginx
exit 1
echo "The Nginx has successfully started"

echo "Need to start the pm2 "
cd /App/Ind-App/BackEnd_Apps
pm2 start switch-*.json
cd -

ls -al /mnt/ | grep cpbsshare
echo "folder is aldready mounted"
echo "need to mount a the share folder"
mkdir /mnt/cpbsshare
mount -a



