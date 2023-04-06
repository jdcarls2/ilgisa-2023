#!/bin/sh

(trap 'kill 0' SIGINT; \
./imposm/imposm import -config ./scenarios/state-highways-config.json -read ./data/illinois-latest.osm.pbf -deployproduction -optimize -write -overwritecache &
./imposm/imposm import -config ./scenarios/city-parks-config.json -read ./data/illinois-latest.osm.pbf -deployproduction -optimize -write -overwritecache &
./imposm/imposm import -config ./scenarios/city-all-config.json -read ./data/illinois-latest.osm.pbf -deployproduction -optimize -write -overwritecache )
