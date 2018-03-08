# cs350-docker
A containerized [CS 350](https://www.student.cs.uwaterloo.ca/~cs350) development environment.

## Prerequisites
* *nix environment
* Docker 

To install Docker, refer to the official [documentation](https://docs.docker.com/install/).

## Installation
To set-up the environment, create a dedicated directory for CS 350 and then download + run `install.sh`:

```
mkdir cs350
cd cs350
curl -O https://raw.githubusercontent.com/shakeelrao/cs350-docker/master/install.sh
bash install.sh
```

The installation script will pull the image from Docker Hub and create the following directory structure:

```
cs350/
|-- install.sh
|-- cs350-os161/
|   |-- os161-1.99/
|   |   |-- Makefile
|   |   |-- ...
```

The `cs350-os161` directory contains the OS/161 source code. 

## Configuration
The next step is to start the container and set-up the volume. In the root directory, run:

```
docker run -v "$(pwd)/cs350-os161:/root/cs350-os161" -it 3uclid/cs350:1.0 /bin/bash
```

This will create an interactive shell attached to the container:

```
root@dcc24ce3533d:~# ls
archive  cs350-os161  init.sh  sys161
```

Next, run `bash init.sh` to build the kernel. After the script finishes, press `CTRL p+q` to detach from the container.

## Workflow
1. Modify the kernel source code locally
2. Attach to the container: `docker exec -it CONTAINER_ID /bin/bash`
3. Build and run the kernel
4. Repeat!

##
