# @summary custom type for access chroot dir to allow support for empty string
type Unbound::Chroot = Variant[Enum[''], Stdlib::Absolutepath]
