FROM		phusion/baseimage:0.9.18
MAINTAINER	xama <oliver@xama.us>
ENV		SEAFILE_VERSION 6.1.3

EXPOSE		8082 8000

VOLUME		/seafile
WORKDIR		/seafile

# Required packages for pro edition
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
RUN		wget "https://download.seafile.com/d/06d4ca0272/files/?p=/seafile-pro-server_${SEAFILE_VERSION}_x86-64.tar.gz&dl=1" -O "/seafile-pro-server_${SEAFILE_VERSION}_x86-64.tar.gz"

# Install Seafile service.
ADD		service/seafile/run.sh /etc/service/seafile/run
ADD		service/seafile/stop.sh /etc/service/seafile/stop

# Install Seahub service.
ADD		service/seahub/run.sh /etc/service/seahub/run
ADD		service/seahub/stop.sh /etc/service/seahub/stop

# Add custom configuration
COPY		config/seafevents.conf /seafevents.conf

ADD		bin/setup.sh /usr/local/sbin/setup
ADD		bin/upgrade.sh /usr/local/sbin/upgrade

# Set permissions
RUN		chmod +x /usr/local/sbin/setup && \
		chmod +x /usr/local/sbin/upgrade && \
		chmod +x /etc/service/seafile/* && \
		chmod +x /etc/service/seahub/*

CMD		/sbin/my_init
