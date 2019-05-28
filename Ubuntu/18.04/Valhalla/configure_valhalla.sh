#!/usr/bin/env bash
# Go into scripts folder
cd $1
# Create the tiles folder
mkdir -p valhalla_tiles

# Check if the local extract exists or else download from an external URL
if [[ -f "$4" ]]; then
    echo "$4 exists. Using it as the OSM extract"
     # Assign the file name of the osm extract for later used
    tile_file=$4
elif curl --output /dev/null --silent --head --fail "$3"; then
  echo "Local OSM extract $4 not found. Using the given URL instead."
  echo "URL exists: $3"
  echo "Downloading OSM extract"
  curl -O $3
  # Assign the file name of the osm extract for later use
  tile_file=$(ls -t | head -n1)
else
    echo "Please ensure that the tile_file or tile_url are valid"
    exit 1
fi
# Check for bounding box
if [[ "$5" != 0 ]] && [[ "$6" != 0 ]] && [[ "$7" != 0 ]] && [[ "$8" != 0 ]]; then
    echo "Valid bounding box added. Adding elevation!";
    # Build the elevation data
    valhalla_build_elevation $5 $6 $7 $8 ${PWD}/elevation_tiles;
    # Build the config file with elevation
    valhalla_build_config --mjolnir-tile-dir ${PWD}/valhalla_tiles --mjolnir-tile-extract ${PWD}/valhalla_tiles.tar --mjolnir-timezone ${PWD}/valhalla_tiles/timezones.sqlite --mjolnir-admin ${PWD}/valhalla_tiles/admins.sqlite --additional-data-elevation ${PWD}/elevation_tiles > $2;
else 
    echo "No valid bounding box set. Skipping elevation!";
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
