# Scenario-Specific Commands

Because I'm too lazy to type this all out during a presentation.

These assume you're running things in the container. If not, just adjust the paths accordingly.

If you're on Windows, you can prepend these commands with `docker exec -w /usr/loca/usr/local/osm/imposm/ ilgisa-2023-imposm-1 ...`, or else you can just attach to the container through Docker Desktop or `docker attach`.

# Create a city extract

```shell
osmium extract -p city.geojson ./data/illinois-latest.osm.pbf -o ./data/city-extract.osm.pbf
```

# Imposm

## Major Roads

```shell
imposm import -config /usr/local/osm/imposm-scenarios/highways-config.json -read /usr/local/osm/data/city-extract.osm.pbf -deployproduction -optimize -write -overwritecache
```

## Parks Data in a City

```shell
imposm import -config /usr/local/osm/imposm-scenarios/city-parks-config.json -read /usr/local/osm/data/city-extract.osm.pbf -deployproduction -optimize -write -overwritecache
```

## *Everything* in a City

```shell
imposm import -config /usr/local/osm/imposm-scenarios/city-all-config.json -read /usr/local/osm/data/city-extract.osm.pbf -deployproduction -optimize -write -overwritecache
```

## Updating Everything

```shell
imposm run -config /usr/local/osm/imposmkendall-all/config.json
```