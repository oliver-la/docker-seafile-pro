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
docker run -it \
	--name=seafile-setup \
	-p 8082:8082 \
	-p 8000:8000 \
	-v /var/seafile:/seafile \
	xama/docker-seafile-pro setup
	
docker rm seafile-setup
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

## Contribute

This solution is quick'n'dirty, but works.
If you have any suggestions in order to improve this image, create a pull request. Thank you!
