# GIS • OPS docker repository  
This tutorial holds the GIS • OPS docker files. For detailed descriptions on how to build and run the docker files read below.

# Technical details  
The docker setups in this repository can be build using the latest [Docker](https://docs.docker.com) and [Docker-Compose](https://docs.docker.com/compose/).

## Valhalla   
The Valhalla docker files are building the latest version of [Valhalla](https://github.com/valhalla/valhalla). For a detailed tutorial on how to run and use the [Valhalla](https://github.com/valhalla/valhalla) docker see our tutorial [How to setup and run Valhalla with Docker on Ubuntu 18.04](foo).  

### Details    
The docker file uses Ubuntu 18.04 as a base system and builds the `prime_server` dependency during the setup. The standard OSM extract is the latest of Albania.

### Setup    
-   You can run this docker-compose setup simply by running the command `docker-compose up --build -d` in the folder where the `docker-compose.yml` is located.
-   Once build, the server will run on `port 8002` with the latest OSM extract of Albania (a small OSM extract that you can quickly setup without any increased hardware).  
-   To change the OSM extract that Valhalla is using, open the `docker-compose.yml` file and point the `tile_url` to your desired OSM extract. [Geofabrik](https://download.geofabrik.de) is a good choice to download the extracts. Just make sure you copy the link for the `*.osm.pbf` file.

### Features    
-   DATA_TOOLS Enabled
-   PYTHON_BINDINGS Enabled
-   NODE_BINDINGS Enabled (Node is installed during the setup)
-   SERVICES Enabled
-   HTTP Enabled
If you want to have a different set of Valhalla features, just open the `build_valhalla.sh` and change the `cmake -H. -Bbuild \` command according to your needs.
