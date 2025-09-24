# @summary custom type for access control lists
type Unbound::Access_control = Struct[{
  action    => Optional[Enum['deny', 'refuse', 'allow', 'allow_setrd', 'allow_snoop', 'allow_cookie', 'deny_non_local', 'refuse_non_local']],
  tags      => Optional[Array[String]],
  rr_string => Optional[String],
  view      => Optional[String],
}]
