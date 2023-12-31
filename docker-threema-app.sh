#!/bin/bash

# Generic settings
IMAGE_NAME="docker-threema-app"

# Display
XSOCK=/tmp/.X11-unix
XAUTH=$(mktemp /tmp/.docker.xauth-XXXXX)
xauth nlist :0 | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -

# Workspace
WS="workspace"
WS_DOCKER="/home/threema/$WS"

# Time settings
TIME_LOCATION="/etc/localtime"
TIME_DOCKER=$TIME_LOCATION

# DBUS
DBUS_SOCKET="/var/run/dbus/system_bus_socket"

# Function build
function build()
{
  mkdir -p $WS
  docker build \
    -t $IMAGE_NAME . \
    --build-arg THREEMA_UID=$(id -u) \
    --build-arg THREEMA_GID=$(id -g)
}

# Function run
function run()
{
  docker run \
    -t \
    -i \
    --rm \
    -v $TIME_LOCATION:$TIME_DOCKER:ro \
    -v $XSOCK:$XSOCK \
    -v $XAUTH:$XAUTH \
    -v $1:$WS_DOCKER \
    -v $DBUS_SOCKET:$DBUS_SOCKET \
    -e DISPLAY=unix$DISPLAY \
    -e XAUTHORITY=$XAUTH \
    "$IMAGE_NAME"
  rm $XAUTH
}

# Start script
ARG_BUILD=0
ARG_RUN=0
ARG_WS="/dev/null"

# Parse arguments
while getopts "brw:" opt; do
  case $opt in
    b)
      ARG_BUILD=1
      ;;
    r)
      ARG_RUN=1
      ;;
    w)
      ARG_WS=$OPTARG
      ;;
    *)
      echo "Error: Invalid argument!"
      ;;
  esac
done

# Evaluate given arguments
if [ $ARG_WS = "/dev/null" ]; then
  echo "Error: Missing workspace!"
  exit 1
fi

if [ $ARG_BUILD -ne 0 ]; then
  echo "Building container ..."
  build
fi

if [ $ARG_RUN -ne 0 ]; then
  if [ -d $ARG_WS ]; then
    echo "Running container (workspace = $ARG_WS) ..."
    run $ARG_WS
  else
    echo "Error: Directory $ARG_WS not found!"
    exit 1
  fi
fi
exit 0
