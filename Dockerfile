FROM alpine:latest
MAINTAINER jlandowner samba

WORKDIR .

RUN apk --no-cache --no-progress upgrade 

RUN apk --no-cache --no-progress add tzdata && ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

RUN apk --no-cache --no-progress add samba tini
COPY smb.conf /etc/samba/smb.conf
COPY smbusrs.lst .
COPY smbstart.sh /usr/bin/

RUN cat smbusrs.lst | awk -F ',' -e '{print "adduser -D" ,$1}' | /bin/sh
RUN cat smbusrs.lst | awk -F ',' -e '{print "(echo ",$2"; echo ",$2") | pdbedit -a ",$1 " -t" }' | /bin/sh

RUN rm -f smbusrs.lst

ENTRYPOINT ["/sbin/tini", "--","/usr/bin/smbstart.sh"]

EXPOSE 139 445 137/udp 138/udp
