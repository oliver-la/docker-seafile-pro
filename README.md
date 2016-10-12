# Docker Image for Seafile 5 Pro Edition

## Introduction

This image will pull the latest pro version of seafile and helps you set it up in a docker environment.

You'll be guided through the setup procedure. It's kept very basic.

Advanced configurations can be done directly via the configuration files generated in the setup.

## Setup

Execute the following simple command.

This will pull the latest image and start the setup process automatically.
Don't worry, you'll see it's very simple. I promise! ;)

```
docker run -it --rm \
	--name=seafile-setup \
	-v /var/seafile:/seafile \
	xama/docker-seafile-pro setup
```

PLEASE NOTE THE "setup" AFTER THE IMAGE NAME!

## Run it

Almost the same command as above:

```
docker run -d \
	--name=seafile \
	-p 8082:8082 \
	-p 8000:8000 \
	-v /var/seafile:/seafile \
	xama/docker-seafile-pro
```

## Upgrade (EXPERIMENTAL)

CAUTION: THIS FEATURE IS IN ITS CURRENT STATE EXPERIMENTAL. USE AT YOUR OWN RISK!

This image supports upgrading seafile too!

First, remove the seafile image. (You have to stop your container first)

```
docker stop seafile
docker rm seafile
docker rmi xama/docker-seafile-pro
```

Proceed to run the container the same way you ran the setup. (except you need to add "upgrade" instead of "setup")

In our example you'll have to run the container by:

```
docker run -it --rm \
	--name=seafile-upgrade \
	-v /var/seafile:/seafile \
	xama/docker-seafile-pro upgrade
```

This procedure requires a few minutes to complete. Please be patient and grab a coffee.

If for some reason seafile fails to start or you weren't patient, you can restore a backup of the state before seafile has been upgraded.
Backups are located under (in our example) `/var/seafile/backup` in .tar.gz format.
Start the container as usual after restoring the backup (see "Run it").

## Contribute

This solution is quick'n'dirty, but works.
If you have any suggestions in order to improve this image, create a pull request. Thank you!
