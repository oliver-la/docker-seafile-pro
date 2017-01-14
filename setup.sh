#!/bin/bash

set -e

# Get latest tarball and extract it
cd /seafile

echo "Extracting server binary ..."
tar -xzf "/seafile-pro-server_${SEAFILE_VERSION}_x86-64.tar.gz"

mkdir installed
mv "/seafile-pro-server_${SEAFILE_VERSION}_x86-64.tar.gz" installed

cd "/seafile/seafile-pro-server-${SEAFILE_VERSION}"

# Setup seafile
ulimit -n 30000
./setup-seafile.sh

# Custom configurations
mkdir -p /seafile/conf
echo "ENABLE_RESUMABLE_FILEUPLOAD = True" >> /seafile/conf/seahub_settings.py
mv /seafevents.conf /seafile/conf/

# Launch setup
./seafile.sh start
./seahub.sh start
./seafile.sh stop
./seahub.sh stop
