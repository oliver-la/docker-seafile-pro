FROM ubuntu:14.04
MAINTAINER xama <oliver@xama.us>
ENV SEAFILE_VERSION 5.1.11

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

COPY setup.sh /setup.sh
RUN chmod +x /setup.sh
RUN /setup.sh

COPY seafevents.conf /seafile/conf/seafevents.conf

# Auto start
COPY seafile.conf /etc/init/seafile.conf
COPY seahub.conf /etc/init/seahub.conf

# Clean up
RUN apt-get remove -y wget
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["/bin/bash"]
