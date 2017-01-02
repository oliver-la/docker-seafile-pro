FROM phusion/baseimage:0.9.18
MAINTAINER xama <oliver@xama.us>
ENV SEAFILE_VERSION 6.0.5

EXPOSE 8082 8000

RUN mkdir /seafile
VOLUME /seafile
WORKDIR /seafile

# Required packages for pro edition
RUN apt-get update && apt-get install -y \
  openjdk-7-jre poppler-utils libpython2.7 python-pip \
  python-setuptools python-imaging python-mysqldb python-memcache python-ldap \
  python-urllib3 sqlite3 wget \
  libreoffice libreoffice-script-provider-python fonts-vlgothic ttf-wqy-microhei ttf-wqy-zenhei xfonts-wqy && pip install boto

# Create service directories
RUN mkdir /etc/service/{seafile,seahub}

# Install Seafile service.
ADD service-seafile-run.sh /etc/service/seafile/run
ADD service-seafile-stop.sh /etc/service/seafile/stop

# Install Seahub service.
ADD service-seahub-run.sh /etc/service/seahub/run
ADD service-seahub-stop.sh /etc/service/seahub/stop

# Set permissions
RUN chmod +x /etc/service/seafile/* && chmod +x /etc/service/seahub/*

# Add custom configuration
COPY seafevents.conf /seafevents.conf

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD setup.sh /usr/local/sbin/setup
ADD upgrade.sh /usr/local/sbin/upgrade
RUN chmod +x /usr/local/sbin/setup && chmod +x /usr/local/sbin/upgrade
CMD /sbin/my_init
