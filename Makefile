init:
	@echo "FIRST: RUN ./init.sh"

run:
	systemctl daemon-reload
	systemctl enable samba-docker.service
	systemctl start samba-docker.service
	systemctl status samba-docker.service

status:
	systemctl status samba-docker.service
