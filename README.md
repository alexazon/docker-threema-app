# docker-threema-app

Install and run Threema desktop app in a Docker container.

`Caution: This is still experimental!`

![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/alexazon/docker-threema-app/build.yml)
![GitHub](https://img.shields.io/github/license/alexazon/docker-threema-app)

# Table of Contents

- [Quick Start](#quick-start)
  - [Build and Start](#build-and-start)
  - [Workspace](#workspace)
  - [Bash Alias](#bash-alias)
- [FAQ and Common Problems](#faq-and-common-problems)
  - [Got Permission Denied](#got-permission-denied)
  - [Remove Container](#remove-container)
  - [Generic Docker Issues](#generic-docker-issues)
    - [Other X11 and Wayland Problems](#other-x11-and-wayland-problems)

# Quick Start

## Build and Start

Just run `make`, this will build and start the container.

Threema should open automatically.

## Workspace

- Inside the container: You can save Threema downloads in `/home/threema/workspace`
- Outside the container: You can access your Threema downloads in `${GIT-PATH}/docker-threema-app/workspace`

If you want to send files via Threema, simply place them in the workspace directory.

You can specify your own custom workspace directory by passing WORKSPACE=$DIRECTORY as an argument.

Example: `make WORKSPACE=/opt`

## Bash Alias

Put this in your .bashrc (or elsewhere) to start the container and yEd:

Default workspace:

```bash
alias threema='make -C ${GIT-PATH}/docker-threema-app'
```

Custom workspace:

```bash
alias threema='make -C ${GIT-PATH}/docker-threema-app WORKSPACE=${OWN_WORKSPACE_PATH}'
```

# FAQ and Common Problems

## Got Permission Denied

Error:

```
Got permission denied while trying to connect to the Docker daemon socket at ...:
Post ...: dial ...: connect: permission denied
```

Solution (add your user to docker group):

```bash
sudo groupadd docker
sudo usermod -aG docker ${USER}
su -s ${USER}
```

## Docker is not running

Error:

```
ERROR: Cannot connect to the Docker daemon at unix:///var/run/docker.sock.
Is the docker daemon running?
```

Solution (start docker service):

```bash
sudo systemctl start docker
sudo systemctl enable docker    # optional, docker will now start automatically
```

## Remove Container

List docker-yed container(s):

```bash
docker images | grep docker-threema-app    # list containers, we only care about docker-yed container(s)
```

Remove container(s):

```bash
docker image rm docker-threema-app   # by name
docker image rm ${ID}                # by ID, alternative option
```

Stop container(s):

```bash
docker container stop ${ID}
```

## Generic Docker Issues

### Other X11 and Wayland Problems

Please check this link: https://github.com/mviereck/x11docker
