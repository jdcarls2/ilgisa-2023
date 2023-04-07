# Scenario-Specific Commands

Because I'm too lazy to type this all out during a presentation.

Run these all in the `imposm` directory.

If you're on Windows, you can prepend these commands with `docker exec -w /usr/local/imposm/ ilgisa-2023-imposm-1 ...`, or else you can just attach to the container through Docker Desktop or `docker attach`.

## Major Roads in Illinois

```
./imposm/imposm import -config ./scenarios/state-highways-config.json -read ./data/illinois-latest.osm.pbf -deployproduction -optimize -write -overwritecache
```

## Parks Data in a City

```
./imposm/imposm import -config ./scenarios/city-parks-config.json -read ./data/illinois-latest.osm.pbf -deployproduction -optimize -write -overwritecache
```

## *Everything* in a City

```
./imposm/imposm import -config ./scenarios/city-all-config.json -read ./data/illinois-latest.osm.pbf -deployproduction -optimize -write -overwritecache
```

## Updating Everything

```
./imposm/imposm run -config ../kendall-all/config.json
```