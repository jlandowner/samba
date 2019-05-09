#!/bin/bash

docker run -it -d -p 445:445 -p 139:139 -v /YOUR_SHARE_DIR:/home/smbuser jlandowner/samba

docker ps
