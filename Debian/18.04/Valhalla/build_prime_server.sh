#!/usr/bin/env bash

url="https://github.com/kevinkreiser/prime_server.git"
NPROC=$(nproc)

# libcurl4-openssl-dev has a weired package path and if not installed in the script, won't be seen by the ./configure script.
apt-get install -y libcurl4-openssl-dev
git clone $url && cd prime_server
git submodule update --init --recursive
./autogen.sh
./configure --prefix=/usr LIBS="-lpthread"
make all -j$NPROC
make -k test -j$NPROC
make install
