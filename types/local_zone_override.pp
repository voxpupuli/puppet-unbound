# @summary custom type for local zone overrides
type Unbound::Local_zone_override = Struct[{
    netblock => String,
    type     => Unbound::Local_zone_type
}]
