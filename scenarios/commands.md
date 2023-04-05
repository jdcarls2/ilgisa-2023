# Scenario-Specific Commands

Because I'm too lazy to type this all out during a presentation.

Run these all in the `imposm` directory.

## Major Roads in Illinois

### Local
```
./imposm/imposm import -config ../scenarios/state-highways-config.json -read ../data/illinois-latest.osm.pbf -deployproduction -optimize -write
```

### Docker
```
docker exec -w /usr/local/imposm/imposm ilgisa-2023-imposm-1 ./imposm import -config ../scenarios/state-highways-config.json -read ../data/illinois-latest.osm.pbf -deployproduction -optimize -write
```