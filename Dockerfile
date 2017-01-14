FROM phusion/baseimage:0.9.18
MAINTAINER xama <oliver@xama.us>
ENV SEAFILE_VERSION 5.1.11
ENV ADMIN_EMAIL admin@example.com
ENV ADMIN_PASSWORD admin

EXPOSE 8082 8000

RUN mkdir /seafile
VOLUME /seafile
WORKDIR /seafile

# Required packages for pro edition
RUN apt-get update && apt-get install -y \
  openjdk-7-jre poppler-utils libpython2.7 python-pip \
  python-setuptools python-imaging python-mysqldb python-memcache python-ldap \
  python-urllib3 sqlite3 wget \
  libreoffice libreoffice-script-provider-python fonts-vlgothic ttf-wqy-microhei ttf-wqy-zenhei xfonts-wqy

RUN pip install boto

# Download seafile binary
RUN wget "https://download.seafile.com/d/06d4ca0272/files/?p=/seafile-pro-server_${SEAFILE_VERSION}_x86-64.tar.gz&dl=1" -O "/seafile-pro-server_${SEAFILE_VERSION}_x86-64.tar.gz"

# Install Seafile service.
RUN mkdir /etc/service/seafile
ADD service-seafile-run.sh /etc/service/seafile/run
RUN chmod +x /etc/service/seafile/run
ADD service-seafile-stop.sh /etc/service/seafile/stop
RUN chmod +x /etc/service/seafile/stop

# Install Seahub service.
RUN mkdir /etc/service/seahub
ADD service-seahub-run.sh /etc/service/seahub/run
RUN chmod +x /etc/service/seahub/run
ADD service-seahub-stop.sh /etc/service/seahub/stop
RUN chmod +x /etc/service/seahub/stop

COPY seafevents.conf /seafevents.conf

# Clean up
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD setup.sh /usr/local/sbin/setup
RUN chmod +x /usr/local/sbin/setup
ADD upgrade.sh /usr/local/sbin/upgrade
RUN chmod +x /usr/local/sbin/upgrade
CMD /sbin/my_init
