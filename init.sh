#!/bin/bash

# COMPONENT FILES
F_SH_RUN_DOCKER=samba-docker-start.sh 
F_LST_SMBUSER=smbusrs.lst
F_SYSTEMD_SERVICE=samba-docker.service

# CHECK EXECUSER
if [ `whoami` != "root" ]; then
   echo "ERR: Run by root."
   exit 1
fi

# CHECK PRMS
if [ $# -ne 2 ]; then
   echo "ERR: ARGS: arg1:YOUR_SHARE_DIR args2:USERNAME"
   exit 1
fi

YOUR_SHARE_DIR=$1
USERNAME=$2

if [ ! -e $DIRPATH_YOU_SHARE ]; then
   echo "ERR: DIRPATH_YOU_SHARE DOES NOT EXIST: $YOUR_SHARE_DIR"
   exit 1
fi

# SET USER/PASSWORD
sed -i "s/USER/$USERNAME/" $F_SH_RUN_DOCKER
if [[ $? -ne 0 ]]; then
    echo "ERR: SET USER is failed"
    exit 2
fi

echo "ENTER PASSWORD(more then 6 char, exit:q)"
read -s input
if [ -z $input ]; then
    echo "ERR: input valid password."
    exit 1
elif [ $input == "q" ]; then
    echo "cancel"
    exit 0
elif [ ${#input} -lt 6 ]; then
    echo "ERR: PASSWORD must be longer than 6 char"
    exit 1
fi
echo "$USERNAME,$input" > $F_LST_SMBUSER

# DOCKER BUILD
docker build -t jlandowner/samba .
if [ $? -ne 0 ]; then
    echo "ERR: DOCKER BUILD is failed"
    exit 2
fi
rm -f $F_LST_SMBUSER

# LINK SHARE
if [ -e /SHARE ]; then
    echo "ERR: /SHARE already exists."
    echo "exit"
    exit 1
fi
ln -s $YOUR_SHARE_DIR /SHARE
if [ $? -ne 0 ]; then
    echo "ERR: LINK SHARE is failed"
    exit 2
fi

# Make healthcheck file
if [ -f /SHARE/.health ]; then
    echo "ERR: /SHARE/.health already exists."
else
    touch /SHARE/.health
fi

# Assign system files
cp $F_SYSTEMD_SERVICE /etc/systemd/system/
if [ $? -ne 0 ]; then
    echo "ERR: COPY $F_SYSTEMD_SERVICE is failed"
    exit 2
fi

cp $F_SH_RUN_DOCKER /opt/
if [ $? -ne 0 ]; then
    echo "ERR: COPY $F_SH_RUN_DOCKER is failed"
    exit 2
fi

echo "COMPLETED: initiarize is done"
exit 0
