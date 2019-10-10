#!/bin/bash

# const
loop_limit=60     # 10s * 600 = 600seconds

# variables
loop_count=0
result=1

# /SHARE mount check
while [ ! -e /SHARE/.health ] && [ $loop_count -lt $loop_limit ]; do
    echo "/SHARE mount check: false: count: $loop_count"
    sleep 10
    loop_count=$(( $loop_count + 1 ))
done

# run docker
if [ -e /SHARE/.health ]; then
    echo "NOW STARTING DOCKER..."
    
    isRunning=`sudo docker ps -f name=samba | wc -l`
    if [ $isRunning -eq 1 ]; then
        sudo docker run -it -d --rm --name samba -p 445:445 -p 139:139 -v /SHARE:/home/neru jlandowner/samba
        if [ $? -eq 0 ]; then
            echo "DOCKER is successfully started."
            result=0
        else
            echo "DOCKER RUN status is NOT good."
        fi
    else
        sudo docker restart samba
        if [ $? -eq 0 ]; then
            echo "DOCKER is successfully restarted."
            result=0
        else
            echo "DOCKER RESTART status is NOT good."
        fi
    fi
fi
exit $result
