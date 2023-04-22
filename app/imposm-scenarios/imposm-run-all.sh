#!/bin/sh

(trap 'kill 0' SIGINT; imposm import -config ./highways-config.json -read ../data/city-extract.osm.pbf -deployproduction -optimize -write -overwritecache &
imposm import -config ./city-parks-config.json -read ../data/city-extract.osm.pbf -deployproduction -optimize -write -overwritecache &
imposm import -config ./city-all-config.json -read ../data/city-extract.osm.pbf -deployproduction -optimize -write -overwritecache -diff )
