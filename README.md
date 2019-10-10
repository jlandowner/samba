# jlandowner/samba
## samba on Docker
this repo is a dockerfile of a light samba docker image.
you can use only in your local network.

## how to use
### 1. initiarize
move to the directory where git clone, then run the command.
this needs root.
```
$ sudo ./init.sh YOUR_SHARE_DIR USERNAME
ENTER PASSWORD(more then 6 char, exit:q)
```
this script do below.
 1. make user for samba & ask password by commandline.
 2. build samba image.
 3. modify docker start script for a YOUR_SHARE_DIR setting.
 4. make symbolic link /SHARE to $YOUR_SHARE_DIR
 5. copy systemd config file & docker start script to the correct directories.

### 2. run by systemd
samba on Docker start script is managed by systemd so that samba restart even if the host reboot.
```
$ make run
```
this command do below.
 1. systemctl daemon-reload
 2. systemctl enable samba-docker.service
 3. systemctl start samba-docker.service
 
Then you can access share directory smb://$HOSTNAMEorIP
