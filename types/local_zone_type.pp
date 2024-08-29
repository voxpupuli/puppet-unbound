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
  'inform_redirect',
  'always_transparent',
  'block_a',
  'always_refuse',
  'always_nxdomain',
  'always_null',
  'noview',
  'nodefault',
]
