FROM debian:buster

LABEL maintainer="hribarsela"
LABEL version="1.0"

RUN echo "deb http://security.debian.org/ buster/updates main contrib non-free" >> /etc/apt/sources.list

RUN apt-get update \
    && apt-get -y install git wget curl ca-certificates gnupg2\
        cmake build-essential  libnode-dev npm clang \
        libsqlite3-mod-spatialite libsqlite3-dev libspatialite-dev \
        autoconf libtool pkg-config libczmq-dev libzmq5 \
        libcurl4-openssl-dev zlib1g-dev jq libgeos-dev \
        libgeos++-dev libprotobuf-dev protobuf-compiler \
        libboost-all-dev liblua5.2-dev spatialite-bin unzip software-properties-common

RUN ln -s /usr/lib/x86_64-linux-gnu/mod_spatialite.so /usr/lib/mod_spatialite

RUN apt-get install software-properties-common

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys D0155F52B2F73663
RUN echo "deb http://ppa.launchpad.net/kevinkreiser/prime-server/ubuntu bionic main" > /etc/apt/sources.list.d/kevinkreiser-ubuntu-prime-server.list
RUN apt-get update

RUN apt install -y libprime-server0.6.5-0 libprime-server0.6.5-dev prime-server0.6.5-bin

RUN mkdir -p /src/valhalla
COPY build.sh /src/valhalla
WORKDIR /src/valhalla
RUN /bin/bash build.sh


# RUN apt-get update \
#     && apt-get -y install \
#         git \
#         dh-make \
#         build-essential \
#         autoconf \
#         autotools-dev \
#         libpcre3 \
#         libpcre3-dev \
#         libz-dev \
#         gnupg \
#         libssl-dev \
#     && apt-get clean \
#     && rm -rf /var/lib/apt/lists/*

#RUN apt-get update && apt-get install -y openssh-server
#RUN mkdir /var/run/sshd
#RUN echo 'root:THEPASSWORDYOUCREATED' | chpasswd
#RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
#RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

#ENV NOTVISIBLE "in users profile"
#RUN echo "export VISIBLE=now" >> /etc/profile

#EXPOSE 22
#CMD ["/usr/sbin/sshd", "-D"]