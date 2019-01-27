#!/usr/bin/env bash
valhalla_service /conf/valhalla.json 1
# Keep docker running easy
exec "$@";
