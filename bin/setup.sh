#!/bin/bash

set -e

# There should be an archive in the root directory already. (included in image)
# Download is being done in the Dockerfile.
cd /seafile

echo "Extracting server binary ..."
tar -xzf "/seafile-pro-server_${SEAFILE_VERSION}_x86-64.tar.gz"

mkdir installed
mv "/seafile-pro-server_${SEAFILE_VERSION}_x86-64.tar.gz" installed

cd "/seafile/seafile-pro-server-${SEAFILE_VERSION}"

# "Since Seafile uses persistent connections between client and server, 
# you should increase Linux file descriptors by ulimit if you have a large number of clients before start Seafile, like:"
# See https://manual.seafile.com/deploy/using_sqlite.html
ulimit -n 30000

# Launch interactive seafile setup
./setup-seafile.sh

mkdir -p /seafile/conf
echo "ENABLE_RESUMABLE_FILEUPLOAD = True" >> /seafile/conf/seahub_settings.py # Ability to resume uploads in browser after pausing.
mv /seafevents.conf /seafile/conf/

# Launch seafile for the first time (setup)
./seafile.sh start
./seahub.sh start
./seafile.sh stop
./seahub.sh stop
