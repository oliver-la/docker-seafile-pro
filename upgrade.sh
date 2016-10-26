#!/bin/bash

cd /seafile

# Check whether seafile is installed.
echo "Checking if Seafile is installed ..."
if [ ! -d "/seafile/seafile-server-latest" ]; then
	echo "[FAILED] Seafile is not installed!"
	exit 0
fi

# Get versions.
CURRENT_VERSION=$(ls -lah | grep 'seafile-server-latest' | awk -F"seafile-pro-server-" '{print $2}')
NEW_VERSION=$SEAFILE_VERSION

# Do I even need to upgrade?
echo "Checking if there is an update available ..."
if [ "$CURRENT_VERSION" == "$NEW_VERSION" ]; then
	echo "[FAILED] You already have the most recent version installed"
	exit 0
fi

# Great, you think there's an update. Let's try.
echo "Grabbing latest server binary ..."
wget "https://download.seafile.com/d/06d4ca0272/files/?p=/seafile-pro-server_${NEW_VERSION}_x86-64.tar.gz&dl=1" -O "seafile-pro-server_${NEW_VERSION}_x86-64.tar.gz" > /dev/null 2>&1
echo "Extracting server binary ..."
tar -xzf "seafile-pro-server_${NEW_VERSION}_x86-64.tar.gz" > /dev/null 2>&1
mv "seafile-pro-server_${NEW_VERSION}_x86-64.tar.gz" installed/

cd "/seafile/seafile-pro-server-${NEW_VERSION}"

# Backup the current version first.
echo "Creating backup of existing seafile ..."
mkdir -p "/seafile/backup"
tar --exclude='/seafile/backup' -zcvf "/seafile/backup/seafile-pro-server-$CURRENT_VERSION-backup.tar.gz" "/seafile" > /dev/null 2>&1

# First we need to check if it's a maintenance update, since the process is different from a major/minor version upgrade
CURRENT_MAJOR_VERSION=$(echo $CURRENT_VERSION | awk -F"." '{print $1}')
CURRENT_MINOR_VERSION=$(echo $CURRENT_VERSION | awk -F"." '{print $2}')
CURRENT_MAINTENANCE_VERSION=$(echo $CURRENT_VERSION | awk -F"." '{print $3}')

NEW_MAJOR_VERSION=$(echo $NEW_VERSION | awk -F"." '{print $1}')
NEW_MINOR_VERSION=$(echo $NEW_VERSION | awk -F"." '{print $2}')
NEW_MAINTENANCE_VERSION=$(echo $NEW_VERSION | awk -F"." '{print $3}')

if [ "$CURRENT_MAJOR_VERSION" == "$NEW_MAJOR_VERSION" ] && [ "$CURRENT_MINOR_VERSION" == "$NEW_MINOR_VERSION" ]; then
  # Alright, this is only a maintenance update.
  echo "Performing minor upgrade ..."
  sh ./upgrade/minor-upgrade.sh
  cd /seafile
  rm -rf "/seafile/seafile-pro-server-${CURRENT_VERSION}"
else
  # Big version jump
  for file in ./upgrade/upgrade_*.sh
  do
    UPGRADE_FROM=$(echo "$file" | awk -F"_" '{print $2}')
    UPGRADE_TO=$(echo "$file" | awk -F"_" '{print $3}' | sed 's/\.sh//g')

    echo "Upgrading from $UPGRADE_FROM to $UPGRADE_TO ..."
    if [ "$UPGRADE_FROM" == "$CURRENT_MAJOR_VERSION.$CURRENT_MINOR_VERSION" ]; then
      eval $file
      CURRENT_MAJOR_VERSION=$(echo $UPGRADE_TO | awk -F"." '{print $1}')
      CURRENT_MINOR_VERSION=$(echo $UPGRADE_TO | awk -F"." '{print $2}')
    fi
  done
fi

echo "All done! Bye."
