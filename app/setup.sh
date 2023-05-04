#!/bin/sh
# set up directories
mkdir -p data/cache
# get latest geofabric extract of IL
cd data
wget -N https://download.geofabrik.de/north-america/us/illinois-latest.osm.pbf
