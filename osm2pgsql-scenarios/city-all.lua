local nodes = osm2pgsql.define_table({
    name = 'osm2pgsql_nodes',
    ids = { type = 'any', type_column = 'osm_type', id_column = 'osm_id' },
    columns = {
        { column = 'tags', type = 'hstore'},
        { column = 'the_geom', type = 'point', not_null = true },
}})

function process_node(object, geom)
    local a = {
        geom = geom,
        tags = object.tags
    }

    nodes:insert(a)
end

function osm2pgsql.process_node(object)
    process_node(object, object:as_point())
end