FROM debian:latest
MAINTAINER Aleš Hribar <ales.hribar@outlook.com>

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

# Standard debian tools
RUN apt-get install -y wget curl ca-certificates gnupg2 git parallel

# Prime server deps
RUN apt-get install -y libczmq-dev libzmq5

# Valhalla deps
RUN apt-get install -y spatialite-bin unzip libtool zlib1g-dev libsqlite3-mod-spatialite jq libgeos-dev libgeos++-dev libprotobuf-dev protobuf-compiler libboost-all-dev libsqlite3-dev libspatialite-dev  liblua5.2-dev

# set paths to fix the libspatialite error
RUN ln -s /usr/lib/x86_64-linux-gnu/mod_spatialite.so /usr/lib/mod_spatialite

# Create necessary folders
RUN mkdir -p /valhrsrc
RUN mkdir /conf
RUN mkdir /scripts

# Copy scripts
COPY build_valhalla.sh /valhrsrc

WORKDIR /valhrsrc


# Build Valhalla
RUN /bin/bash build_valhalla.sh

# Set link to osm file
ARG tile_url
ARG tile_file

# Set elevation boundary after the whole building crap else it will always build again when the coords change
ARG min_x
ARG min_y
ARG max_x
ARG max_y
ARG build_admins
ARG build_elevation
ARG build_time_zones

# Export path variables
ENV SCRIPTS_DIR ${SCRIPTS_DIR:-"/scripts/"}
ENV CONFIG_PATH ${CONFIG_PATH:-"/conf/valhalla.json"}

# Copy the configure scripts
RUN cp -r /valhrsrc/valhalla/scripts/.  /scripts
COPY configure_valhalla.sh ${SCRIPTS_DIR}

# Copy the tile file if it exists
COPY blank ${tile_file}* ${SCRIPTS_DIR}


# configure Valhalla
WORKDIR /${SCRIPTS_DIR}
RUN /bin/bash configure_valhalla.sh ${SCRIPTS_DIR} ${CONFIG_PATH} ${tile_url} ${tile_file} ${min_x} ${max_x} ${min_y} ${max_y} ${build_elevation} ${build_admins} ${build_time_zones}

# Cleaning process
WORKDIR /
RUN rm -rf /valhrsrc
RUN apt-get autoclean -y && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Expose and run Valhalla
EXPOSE 8002
COPY run.sh ${SCRIPTS_DIR}
RUN chmod +x /scripts/run.sh
ENTRYPOINT ["/scripts/run.sh", "/conf/valhalla.json"]
