---
title: Creating a Local OSM Extract
separator:  "----"
verticalSeparator: "---"
theme: moon
revealOptions:
  transition: 'fade'
  slideNumber: true
  height: 100%
  width: 100%
  
---

# Creating & Using a Live, Localized Extract of OpenStreetMap

---

# Overview

- Introduction
- OSM Data
- Import Scenarios
- Keeping it Up to Date
- Using it
- Questions

---

## Steal this presentation!

![](./assets/repo-qr.png)

https://github.com/jdcarls2/ilgisa-2023

----

# OpenStreetMap Data

---

## What is OSM?

*"The Wikipedia of Maps"*

OSM is a **dataset**, which is...

- global
- open
- used to map nearly anything
- one of my favorite things

---

## Is anyone actually using it?

- Amazon Logistics <!-- .element: class="fragment fade-in-then-semi-out" -->
- Tesla Smart Summon feature <!-- .element: class="fragment fade-in-then-semi-out" -->
- Esri (basemaps, feature services) <!-- .element: class="fragment fade-in-then-semi-out" -->
- Pokemon Go <!-- .element: class="fragment fade-in-then-semi-out" -->
- Red Cross <!-- .element: class="fragment fade-in-then-semi-out" -->
- Kendall County! <!-- .element: class="fragment fade-in-then-semi-out" -->

Note: The point here is that there's clearly *something* of value in this dataset, if you can just get at it.

---

## OpenStreetMap Data: *It's weird!*

The OSM dataset has:

- NO layers <!-- .element: class="fragment" -->
- NO schema <!-- .element: class="fragment" -->
- NO polygons <!-- .element: class="fragment" -->

![](./assets/lebowski.gif) <!-- .element: class="fragment" -->

---

To be more precise, OSM is an **object-oriented data model**.

Every element in the dataset can have an arbitrary number of key-value pairs

In OSM, we call those "tags".

```js[4-8|11-17]
{
  "elements": [
    {
      "type": "node",
      "id": 1,
      "tags": {
        "amenity": "bench"
      }
    },
    {
      "type": "way",
      "id" 2,
      "tags": {
        "natural": "water",
        "water": "lake",
        "name": "Lake Plano"
      }
    }
  ]
}
```
---

![](./assets/framework.jpg)

---

![](./assets/styled.jpg)

----

# Getting the Data

---

## Sources

https://wiki.openstreetmap.org/wiki/Downloading_data

For very small areas, it may be possible to query the **Overpass API** directly.

State-based extract from GeoFabrik: https://download.geofabrik.de/north-america/us/illinois.html

---

### Osmium
https://osmcode.org/osmium-tool/

A "swiss army knife" for OSM data.

- **Extracting geographic subset**
- Getting metadata about objects
- Extract by attribute
- Generate / apply change files
- and more!

---

### Audience Participation!

http://geojson.io/#map=6.2/39.976/-89.164

---

```properties[1|2|3|4|5]
osmium extract \
  -p /app/city.geojson \
  /app/data/illinois-latest.osm.pbf \
  -o /app/data/city-extract.osm.pbf --overwrite \
  -s smart -S types=any
```

----

# Importing

---

## `imposm`

| Pros | Cons |
|-|-|
|✅ Easy to use and configure | ❌ Relations are harder to work with, and require own tables |
|✅ Built in tag "cleaning" | ❌ Lacks advanced geometry processing or configuration |
|✅ Table generalization | ❌ Area of interest does not apply to relations
|✅ Area of interest filtering for import *and* updating | ❌ Development has plateaued


Note: Tag cleaning meaning yes/no values to boolean fields, numeric values to number fields, etc. Generalization - for a given table, simplify geometries and even drop features smaller than a certain size; useful for small scales

---

Mapping OSM data to tables is done using a YAML config file.

```yaml[1,2|3,4,6,8|3,10-12|16-23|24]
tables:
  roads:
    columns:
    - name: osm_id
      type: id
    - name: the_geom
      type: geometry
    - name: type
      type: mapping_value
    - key: name
      name: name
      type: string
    filters:
      reject:
        area: ["yes"]
    mapping:
      highway:
      - motorway
      - trunk
      - primary
      - secondary
      - tertiary
      - residential
    type: linestring
```

---

### Importing: Single Table

```properties[1|2|3|4]
imposm import \
  -config /app/imposm-scenarios/highways-config.json \
  -read /app/data/city-extract.osm.pbf \
  -deployproduction -optimize -write -overwritecache
```

```json[2|3|4]
{
    "cachedir": "/app/data/cache/highways",
    "mapping": "/app/imposm-scenarios/highways-mapping.yml",
    "connection": "postgis://gis:gis@database:5432/ilgisa2023?prefix=state_highways"
}
```
<!-- .element class="fragment" -->

---

### Additional Scenarios
#### Multiple Tables

```properties
imposm import \
  -config /app/imposm-scenarios/city-parks-config.json \
  -read /app/data/city-extract.osm.pbf \
  -deployproduction -optimize -write -overwritecache
```

#### Importing *EVERYTHING*

And prepping for future updates!

```properties[|5]
imposm import \
  -config /app/imposm-scenarios/city-all-config.json \
  -read /app/data/city-extract.osm.pbf \
  -deployproduction -optimize -write -overwritecache \
  -diff
```

---

## `osm2pgsql`

|Pros|Cons|
|-|-|
|✅ Well established, continued development |❌ Updating requires a replication url, cannot easily be limited to an area of interest
|✅ Extremely configurable |❌ Custom configuration can be harder to adjust / understand
|✅ Allows mid-stream geometry operations |❌ Built-in generalization is still only experimental
|✅ Exports to many coordinate systems

---

Mapping to tables is done with a **Lua** file.

```lua[1|5-7|11-16|18-24]
local nodes = osm2pgsql.define_table({
    name = 'osm2pgsql_nodes',
    ids = { type = 'any', id_column = 'osm_id' },
    columns = {
        { column = 'id', sql_type = 'serial', create_only = true },
        { column = 'tags', type = 'hstore' },
        { column = 'the_geom', type = 'point', not_null = true }
    }
})

function osm2pgsql.process_node(object)
    nodes:insert({
        tags = object.tags,
        the_geom = object:as_point()
    })
end

function osm2pgsql.process_way(object)
    if object.is_closed then
        nodes:insert({
            tags = object.tags,
            the_geom = object:as_polygon():centroid()
        })
    end
```

---

### Importing

#### Points of Interest

```properties[1|2|3|4]
osm2pgsql \
  -j /app/data/city-extract.osm.pbf \
  -d postgres://gis:gis@database:5432/ilgisa2023 \
  -O flex -S /app/osm2pgsql-scenarios/pois.lua
```

#### Everything

```properties
osm2pgsql \
  -j /app/data/city-extract.osm.pbf \
  -d postgres://gis:gis@database:5432/ilgisa2023 \
  -O flex -S /app/osm2pgsql-scenarios/city-all.lua
```

----

# Updating

## The Easy Way

Just re-run the import steps whenever a new extract is available from the original source!

---

## Up-to-the-Minute Updates

### `imposm`

As long as you include `-diff` in the original import command, updating with `imposm` is very simple:

```properties
imposm run -config /app/imposm-scenarios/city-all-config.json
```

---

### `osm2pgsql`

Updating with `osm2pgsql` will only pull apply updates from the original download, i.e., all changes in the GeoFabrik IL extract, or all minutely changes for the entire planet.

To limit said changes to your area of interest is possible, but requires some custom coding to work.

If "live" data is needed, probably just use `imposm`.

----

# Using It

---

## Those "Everything" Tables

Rather than filter the data on import, it is possible to import all elements.

The tags can all be put into a single `jsonb` column.
Attributes stored in the following format: 
```json
{"key_1":"value_1", "key_2":"value_2", ... "key_n":"value_n"}
```

Using the `column -> 'key'` syntax returns the value for the specified key.

```sql[|4,5|7]
SELECT
  osm_id,
  the_geom,
  tags -> 'cuisine' as cuisine,
  tags -> 'name' as name
FROM osm2pgsql_nodes
WHERE tags -> 'amenity' = 'restaurant'
```

---

### Why would I want that?

- Schema remains as flexible as OSM itself
- No re-importing / re-indexing
- As use cases change, only the *queries* need to be modified, not the data
- Query output can be used identically to any SQL table
- QGIS has built-in support to parse *and edit* `jsonb` fields

---

### Some Queries

#### Traffic Roads

```sql
SELECT
  osm_id,
  the_geom,
  tags -> 'name' name,
  tags -> 'highway' class
FROM osm2pgsql_ways
WHERE tags -> 'highway' IN (
  'primary',
  'secondary',
  'tertiary',
  'motorway',
  'trunk',
  'unclassified',
  'residential',
  'service'
)
```

---

#### Natural Areas / Land Cover

```sql
SELECT
	osm_id,
	the_geom,
	COALESCE(tags -> 'natural', tags->'landuse') type,
	tags
FROM osm2pgsql_areas
WHERE COALESCE(tags -> 'natural', tags->'landuse') IS NOT NULL
```

---

#### Cycling Infrastructure
```sql
select
	osm_id,
	the_geom,
	tags -> 'name' name,
	case
		when tags -> 'highway' in ('cycleway', 'footway', 'path') then 'separated'
		else 'on road'
	end class,
	tags -> 'highway' type,
	tags -> 'bicycle' bicycle_access
from osm2pgsql_ways
where tags -> 'bicycle' != 'no'
or tags -> 'cycleway' = 'lane'
```
---

#### Charging Stations!
```sql
select
  osm_id,
  the_geom,
  tags -> 'access' access
from osm2pgsql_nodes
where tags -> 'amenity' = 'charging_station'
```
---

## What to Do

Honestly, once you write the query, you can use the results for **anything** that you would a normal table, including:

- Publishing a feature service to the web
- Generating vector tiles
- Using as input in geoprocessing
- Create an ArcGIS Locator dataset
- Create a routable graph network

----

# Questions?
<!-- .element: class="r-fit-text" -->