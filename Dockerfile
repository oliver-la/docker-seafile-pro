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

# Get latest tarball and extract it
RUN wget "https://download.seafile.com/d/06d4ca0272/files/?p=/seafile-pro-server_${SEAFILE_VERSION}_x86-64.tar.gz&dl=1" -O "seafile-pro-server_${SEAFILE_VERSION}_x86-64.tar.gz"
RUN tar -xzf "seafile-pro-server_${SEAFILE_VERSION}_x86-64.tar.gz"

RUN mkdir installed
RUN mv "seafile-pro-server_${SEAFILE_VERSION}_x86-64.tar.gz" installed

WORKDIR "/seafile/seafile-pro-server-${SEAFILE_VERSION}"

# Setup seafile
RUN ulimit -n 30000
RUN ./setup-seafile.sh auto

RUN mkdir -p /seafile/conf
RUN echo "ENABLE_RESUMABLE_FILEUPLOAD = True" >> /seafile/conf/seahub_settings.py
COPY seafevents.conf /seafile/conf/seafevents.conf

RUN ./seafile.sh start

# Auto start
COPY seafile.conf /etc/init/seafile.conf
COPY seahub.conf /etc/init/seahub.conf

# Clean up
RUN apt-get remove -y wget
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["/bin/bash"]
