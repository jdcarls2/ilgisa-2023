For querying your databases in the all-data scenarios.

# Traffic Roads

```sql
SELECT * FROM osm2pgsql_ways
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

# Natural Areas / Land Cover

```sql
select
	osm_id,
	the_geom,
	coalesce(tags -> 'natural', tags->'landuse') type,
	tags
from kendall_areas
where (tags -> 'natural' is not null and tags -> 'natural' != 'water')
or tags -> 'landuse' is not null
```

