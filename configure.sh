#!/usr/bin/env bash
cd $1
mkdir -p valhalla_tiles
if [[ -f "$4" ]]; then
    echo ""
    echo "*****************************************************************************"
    echo "*            $4 exists. Using it as the OSM extract                         *"
    echo "*****************************************************************************"
    tile_file=$4
elif curl --output /dev/null --silent --head --fail "$3"; then
    echo ""
    echo "*****************************************************************************"
    echo "* Local OSM extract $4 not found. Using the given URL instead "
    echo "* URL exists: $3                  "
    echo "* Downloading OSM extract         "
    echo "*****************************************************************************"
    curl -O $3
    tile_file=$(ls -t | head -n1)
else
    echo "Please ensure that the tile_file or tile_url are valid"
    exit 1
fi
mjolnir_timezone="";
mjolnir_admin="";
additional_data_elevation="";
if [[ $9 == "True" ]] && [[ "$5" != 0 ]] && [[ "$6" != 0 ]] && [[ "$7" != 0 ]] && [[ "$8" != 0 ]]; then
    echo ""
    echo "******************************************************************************"
    echo "*  Valid bounding box and data elevation parameter added. Adding elevation!  *";
    echo "******************************************************************************"
    valhalla_build_elevation $5 $6 $7 $8 ${PWD}/elevation_tiles;
    additional_data_elevation="--additional-data-elevation ${PWD}/elevation_tiles";
else
    echo ""
    echo "******************************************************************************"
    echo "*    No valid bounding box or elevation parameter set. Skipping elevation!   *";
    echo "******************************************************************************"
fi
if [[ ${10} == "True" ]]; then
    echo ""
    echo "******************************************************************************"
    echo "*                      Adding admin regions                                  *";
    echo "******************************************************************************"
    mjolnir_admin="--mjolnir-admin ${PWD}/valhalla_tiles/admins.sqlite";
else
    echo ""
    echo "******************************************************************************"
    echo "*                      Skipping admin regions                                *";
    echo "******************************************************************************"
fi
if [[ ${11} == "True" ]]; then
    echo ""
    echo "******************************************************************************"
    echo "*                     A dding timezone data                                  *";
    echo "******************************************************************************"
    mjolnir_timezone="--mjolnir-timezone ${PWD}/valhalla_tiles/timezones.sqlite";
else
    echo ""
    echo "******************************************************************************"
    echo "*                    Skipping timezone data                                  *";
    echo "******************************************************************************"
fi
echo ""
echo "**********************************************************************************"
echo "*                         Build the config file                                  *";
echo "**********************************************************************************"
valhalla_build_config --mjolnir-tile-dir ${PWD}/valhalla_tiles --mjolnir-tile-extract ${PWD}/valhalla_tiles.tar ${mjolnir_timezone} ${mjolnir_admin} ${additional_data_elevation} > $2;
if [[ ${10} == "True" ]]; then
    echo ""
    echo "******************************************************************************"
    echo "*                     Build the admin regions                                *";
    echo "******************************************************************************"
    valhalla_build_admins --config ${2} $tile_file;
fi

if [[ ${11} == "True" ]]; then
    # Build the time zones
    echo ""
    echo "******************************************************************************"
    echo "*                     Build the timezone data                                *";
    echo "******************************************************************************"
    ./valhalla_build_timezones $2
fi

# Finally build the tiles
echo ""
echo "**********************************************************************************"
echo "*                         Build the tile files.                                  *"
echo "**********************************************************************************"
valhalla_build_tiles -c $2 $tile_file
# Tar up the tiles in the valhalla_tiles folder
find valhalla_tiles | sort -n | tar cf "valhalla_tiles.tar" --no-recursion -T -
