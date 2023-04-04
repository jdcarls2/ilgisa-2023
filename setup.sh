#!/bin/sh

# set up directories
mkdir imposm
mkdir data
mkdir scenarios

# download  and extract imposm 0.11.1
wget https://github.com/omniscale/imposm3/releases/download/v0.11.1/imposm-0.11.1-linux-x86-64.tar.gz 
tar -xzvf imposm-0.11.1-linux-x86-64.tar.gz

# get latest geofabric extract of IL
cd data
wget https://download.geofabrik.de/north-america/us/illinois-latest.osm.pbf

