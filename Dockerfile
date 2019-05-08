FROM lordmuffin/alpine:3.9
LABEL lordmuffin <dorkmeisterx69@gmail.com>

RUN	apk --no-cache --no-progress upgrade -f && \
	apk --no-cache --no-progress add \
	su-exec \
	ca-certificates \
	sqlite \
	bash \
	git \
	linux-pam \
	curl \
	openssh \
	tzdata

RUN wget -O gitea https://dl.gitea.io/gitea/1.8/gitea-1.8-linux-amd64 && \
	chmod +x gitea && \
	ls -l

# COPY	s6.d /etc/s6.d
COPY	app.ini /work/tmp/gitea/conf/app.ini
COPY 	entrypoint.sh /work/entrypoint.sh
RUN 	chmod +x entrypoint.sh

# RUN	ln -s /data/ssh/ssh_host_ed25519_key /etc/ssh/ && \
# 	ln -s /data/ssh/ssh_host_rsa_key /etc/ssh/ && \
# 	ln -s /data/ssh/ssh_host_dsa_key /etc/ssh && \
# 	ln -s /data/ssh/ssh_host_ecdsa_key /etc/ssh/ 

ENV	USER=alpine
ENV GITEA_CUSTOM=/work/tmp/gitea

EXPOSE 3000 22

ENTRYPOINT [ "/bin/ash", "./entrypoint.sh"]

WORKDIR /work 