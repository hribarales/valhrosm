#!/usr/bin/env bash
# Go into scripts folder
cd $1
# Create the tiles folder
mkdir -p valhalla_tiles
# Get the osm extract
curl -O $3
# Assign the file name of the osm extract for later used
tile_file=$(ls -t | head -n1)
# Check for bounding box
if [[ "$4" != 0 ]] && [[ "$5" != 0 ]] && [[ "$6" != 0 ]] && [[ "$7" != 0 ]]; then
    echo "Adding elevation";
    # Build the elevation data
    valhalla_build_elevation $4 $5 $6 $7 ${PWD}/elevation_tiles;
    # Build the config file with elevation
    valhalla_build_config --mjolnir-tile-dir ${PWD}/valhalla_tiles --mjolnir-tile-extract ${PWD}/valhalla_tiles.tar --mjolnir-timezone ${PWD}/valhalla_tiles/timezones.sqlite --mjolnir-admin ${PWD}/valhalla_tiles/admins.sqlite --additional-data-elevation ${PWD}/elevation_tiles > $2;
else 
    echo "Skipping elevation";
    # Build the config file without elevation
    valhalla_build_config --mjolnir-tile-dir ${PWD}/valhalla_tiles --mjolnir-tile-extract ${PWD}/valhalla_tiles.tar --mjolnir-timezone ${PWD}/valhalla_tiles/timezones.sqlite --mjolnir-admin ${PWD}/valhalla_tiles/admins.sqlite > $2;
fi
# Build the admin regions
valhalla_build_admins --config $2 $tile_file
# Build the time zones
./valhalla_build_timezones $2
# Finally build the tiles
valhalla_build_tiles -c $2 $tile_file
# Tar up the tiles in the valhalla_tiles folder
find valhalla_tiles | sort -n | tar cf "valhalla_tiles.tar" --no-recursion -T -
