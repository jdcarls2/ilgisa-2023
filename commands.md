# Scenario-Specific Commands

Because I'm too lazy to type this all out during a presentation.

These assume you're running things in the container. If not, just adjust the paths accordingly.

If you're on Windows, you can prepend these commands with `docker exec -w /usr/loca/app/imposm/ ilgisa-2023-imposm-1 ...`, or else you can just attach to the container through Docker Desktop or `docker attach`.

# Create a city extract

```shell
osmium extract -p city.geojson /app/data/illinois-latest.osm.pbf -o app/data/city-extract.osm.pbf -s smart
```

# Imposm

## Major Roads

```shell
imposm import -config /app/imposm-scenarios/highways-config.json -read /app/data/city-extract.osm.pbf -deployproduction -optimize -write -overwritecache
```

## Parks Data in a City

```shell
imposm import -config /app/imposm-scenarios/city-parks-config.json -read /app/data/city-extract.osm.pbf -deployproduction -optimize -write -overwritecache
```

## *Everything* in a City

```shell
imposm import -config /app/imposm-scenarios/city-all-config.json -read /app/data/city-extract.osm.pbf -deployproduction -optimize -write -overwritecache
```

## Updating Everything

```shell
imposm run -config /app/imposm-scenarios/city-all-config.json
```

# osm2pgsql

```shell
osm2pgsql -d postgres://gis:gis@database:5432/ilgisa2023 -O flex -S app/osm2pgsql-scenarios/city-all.lua -j app/data/city-extract.osm.pbf
```

## POI Map
One of `osm2pgsql`'s own examples, showcasing the ability to process geometry as part of the process.

```shell
osm2pgsql -d postgres://gis:gis@database:5432/ilgisa2023 -O flex --slim -S ./osm2pgsql-scenarios/pois.lua -j ./data/city-extract.osm.pbf
```
