# custom enum type for local-zone types
type Unbound::Local_zone_type = Enum[
  'deny',
  'refuse',
  'static',
  'transparent',
  'redirect',
  'nodefault',
  'typetransparent',
  'inform',
  'inform_deny',
  'always_transparent',
  'always_refuse',
  'always_nxdomain',
]
