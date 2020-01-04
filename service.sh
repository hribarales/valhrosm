#!/usr/bin/env bash
if test -f "/custom_conf/valhalla.json"; then
   echo "Found /custom_conf/valhalla.json as custom config file.";
   valhalla_service /custom_conf/valhalla.json 1;
else
    echo "No /custom_conf/valhalla.json found. Using the regular config.";
    valhalla_service /conf/valhalla.json 1;
fi