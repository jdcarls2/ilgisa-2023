For querying your databases in the all-data scenarios.

# Traffic Roads

```sql
SELECT * FROM city_all_ways
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