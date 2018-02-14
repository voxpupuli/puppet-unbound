type Unbound::Access_control = Struct[{
  action    => Optiona[Enum['deny', 'refuse', 'allow', 'allow_snoop', 'deny_non_local', 'refuse_non_local']],
  tags      => Optional[Array[String]],
  rr_string => Optional[String],
  view      => Optional[String],
}]
