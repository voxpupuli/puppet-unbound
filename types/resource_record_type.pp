# custom type for resource record used for local-data
type Unbound::Resource_record_type = Struct[{
    'name'      => String,
    'ttl'       => Optional[Integer],
    'class'     => Optional[String],
    'type'      => String,
    'data'      => String,
}]
