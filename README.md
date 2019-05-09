# jlandowner/samba
## samba on Docker
this repo is a dockerfile of a light samba docker image.
you can use only in your local network.

## how to use
### 1. edit smbusrs.lst
smbusrs.lst
```
smbuser,YOUR_PASSWORD
```

CAITON: password is a plain text.

### 2. build image
move to the directory where Dockerfile is, then command below
```
docker build -t jlandowner/samba .
```

### 3. run image
```
docker run -it -d -p 139:139 -p 445:445 -v {YOUR_SHARE_DIR}:/home/smbuser jlandowner/samba
```
change YOUR_SHARE_DIR to the host dir where you want to share.

you can also docker-run by 'samba-docker-start.sh'.
change YOUR_SHARE_DIR, then exec below.
```
./samba-docker-start.sh
```

you can use this shell when the host reboots.
copy this shell to /etc/init.d and so on.

