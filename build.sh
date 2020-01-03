#!/usr/bin/env bash

url="https://github.com/valhalla/valhalla"
NPROC=$(nproc)

git clone $url
cd valhalla
npm i --save-dev node-cmake nan
git submodule sync
git submodule update --init --recursive
mkdir build
cmake . -Bbuild \
  -DCMAKE_C_FLAGS:STRING="${CFLAGS}" \
  -DCMAKE_CXX_FLAGS:STRING="${CXXFLAGS}" \
  -DCMAKE_EXE_LINKER_FLAGS:STRING="${LDFLAGS}" \
  -DCMAKE_INSTALL_LIBDIR=lib \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=/usr \
  -DENABLE_DATA_TOOLS=On \
  -DENABLE_PYTHON_BINDINGS=On \
  -DENABLE_NODE_BINDINGS=On \
  -DENABLE_SERVICES=On \
  -DENABLE_HTTP=On

