#!/bin/sh

# set up directories
mkdir -p scenarios imposm data/cache

# download  and extract imposm 0.11.1
wget -N https://github.com/omniscale/imposm3/releases/download/v0.11.1/imposm-0.11.1-linux-x86-64.tar.gz
tar -xzvf imposm-0.11.1-linux-x86-64.tar.gz -C imposm --strip-components=1

# get latest geofabric extract of IL
cd data
wget -N https://download.geofabrik.de/north-america/us/illinois-latest.osm.pbf

