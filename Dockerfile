# Ubuntu
FROM ubuntu:latest

# Download link
ARG THREEMA_DL=https://releases.threema.ch/web-electron/v1/release/
ARG THREEMA_DEB=Threema-Latest.deb

# Arguments
ARG THREEMA_UID # see build function
ARG THREEMA_GID # see build function

# Home settings for user yed
ARG BASHRC=/home/threema/.bashrc
ARG THREEMA_HOME=/home/threema

# Update OS
RUN apt-get -y update
RUN apt-get -y upgrade

# Get dependencies
RUN apt-get -y install dbus libgtk-3-0 libnotify4 libnss3 libxtst6 xdg-utils libatspi2.0-0 libdrm2 libgbm1 libxcb-dri3-0 kde-cli-tools trash-cli libglib2.0-bin

# Get Threema
RUN apt-get -y install wget
RUN wget $THREEMA_DL$THREEMA_DEB -P /tmp
RUN dpkg -i /tmp/$THREEMA_DEB

# Create new user yed
RUN groupadd -g "${THREEMA_GID}" threema && useradd --create-home --no-log-init -u "${THREEMA_UID}" -g "${THREEMA_GID}" threema
USER threema
WORKDIR $THREEMA_HOME

# Start Threema
ENTRYPOINT ["threema", "--no-sandbox", "--disable-gpu"]
