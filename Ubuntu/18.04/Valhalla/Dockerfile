FROM ubuntu:18.04
MAINTAINER Julian Psotta <julian@gis-ops.com>

# Set standard args
ARG tile_url

# Set docker specific settings
ENV TERM xterm
RUN export DEBIAN_FRONTEND=noninteractive

# Install deps
RUN apt-get update
RUN apt-get update --fix-missing

# Docker specific deps
RUN apt-get install -y apt-utils dialog locales aptitude

# Set locales
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Build chain
RUN apt-get install -y cmake build-essential autoconf pkg-config

# Standard ubuntu tools
RUN apt-get install -y wget curl ca-certificates gnupg2 git

# Prime server deps
# libcurl4 and libcurl4-openssl-dev are installed in the prime server script directly to avoid path problems.
RUN apt-get install -y libczmq-dev libzmq5

# Valhalla deps
RUN apt-get install -y spatialite-bin unzip libtool zlib1g-dev libsqlite3-mod-spatialite jq libgeos-dev libgeos++-dev libprotobuf-dev protobuf-compiler libboost-all-dev libsqlite3-dev libspatialite-dev  liblua5.2-dev

# set paths to fix the libspatialite error
RUN ln -s /usr/lib/x86_64-linux-gnu/mod_spatialite.so /usr/lib/mod_spatialite

# Create necessary folders
RUN mkdir -p /foo
RUN mkdir /conf
RUN mkdir /scripts

# Copy scripts
COPY build_prime_server.sh /foo
COPY build_valhalla.sh /foo

WORKDIR /foo

# Build Prime Server
RUN /bin/bash build_prime_server.sh

# Build Valhalla
RUN /bin/bash build_valhalla.sh

# Export path variables
ENV SCRIPTS_DIR ${SCRIPTS_DIR:-"/scripts"}
ENV CONFIG_PATH ${CONFIG_PATH:-"/conf/valhalla.json"}

# Copy the configure scripts
RUN cp -r /foo/valhalla/scripts/.  /scripts
COPY configure_valhalla.sh ${SCRIPTS_DIR}
COPY run.sh ${SCRIPTS_DIR}

# configure Valhalla
WORKDIR /${SCRIPTS_DIR}
RUN /bin/bash configure_valhalla.sh ${SCRIPTS_DIR} ${CONFIG_PATH} ${tile_url}

# Cleaning process
WORKDIR /
RUN rm -rf /foo
RUN apt-get autoclean -y && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Expose and run Valhalla
EXPOSE 8002
RUN chmod +x /scripts/run.sh
ENTRYPOINT ["/scripts/run.sh", "/conf/valhalla.json"]
