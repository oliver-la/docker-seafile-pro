FROM		phusion/baseimage:0.9.18
MAINTAINER	contact@oliver.la
ENV		SEAFILE_VERSION 6.3.7

EXPOSE		8082 8000

VOLUME		/seafile
WORKDIR		/seafile

# Required packages for pro edition
# Taken from https://manual.seafile.com/deploy_pro/download_and_setup_seafile_professional_server.html
RUN		apt-get update && \
		DEBIAN_FRONTEND=noninteractive apt-get install -y \
		openjdk-7-jre \
		poppler-utils libpython2.7 python-pip python-setuptools python-imaging python-mysqldb python-memcache python-ldap python-urllib3 \
		sqlite3 wget \
		libreoffice libreoffice-script-provider-python \
		fonts-vlgothic ttf-wqy-microhei ttf-wqy-zenhei xfonts-wqy && \
		apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
		pip install boto

# Download seafile binary
# List of binaries are here: https://download.seafile.com/d/6e5297246c/files/?p=/pro/
RUN		wget "https://download.seafile.com/d/6e5297246c/files/?p=/pro/seafile-pro-server_${SEAFILE_VERSION}_x86-64.tar.gz&dl=1" -O "/seafile-pro-server_${SEAFILE_VERSION}_x86-64.tar.gz"

# Add seafile service.
ADD		service/seafile/run.sh /etc/service/seafile/run
ADD		service/seafile/stop.sh /etc/service/seafile/stop

# Add seahub service
ADD		service/seahub/run.sh /etc/service/seahub/run
ADD		service/seahub/stop.sh /etc/service/seahub/stop

# Custom configuration
COPY	config/seafevents.conf /seafevents.conf

# Custom scripts
ADD		bin/setup.sh /usr/local/sbin/setup
ADD		bin/upgrade.sh /usr/local/sbin/upgrade

# Set permissions
RUN		chmod +x /usr/local/sbin/setup && \
		chmod +x /usr/local/sbin/upgrade && \
		chmod +x /etc/service/seafile/* && \
		chmod +x /etc/service/seahub/*

CMD		/sbin/my_init
