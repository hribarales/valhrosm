#!/usr/bin/env bash
if test -f "/custom_conf/valhalla.json"; then
   echo "Found existing config file. Using it instead of a new one. Use at your own risk!";
   valhalla_service /custom_conf/valhalla.json 1;
else
    echo "No custom config found. Using the regular config.";
    valhalla_service /conf/valhalla.json 1;
fi

# Keep docker running easy
exec "$@";
