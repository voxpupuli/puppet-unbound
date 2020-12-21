# @summary Type used to validate rzp configueration
# @param primary the primary name server
# @param master another name for the primary name server
# @param url to download the rpz zone
# @param allow_notify list of hosts allowed to notify
# @param zonefile path to zonefile
# @param rpz_action_override  Always use this RPZ action for matching triggers
#        from this zone. Possible action are: nxdomain, nodata, passthru, drop,
#        disabled and cname.
# @param rpz_cname_override The CNAME target domain to use if the cname action
#        is configured for rpz-action-override.
# @param rpz_log Log all applied RPZ actions for this RPZ zone
# @param rpz_log_name Specify a string to be part of the log line, for easy referencing.
# @param tags Limit the policies from this RPZ clause to clients with a matching tag
type Unbound::Rpz = Struct[{
    primary             => Optional[Array[Stdlib::Host]],
    master              => Optional[Array[Stdlib::Host]],
    url                 => Optional[Array[Stdlib::HTTPUrl]],
    allow_notify        => Optional[Array[Stdlib::Host]],
    zonefile            => Optional[Stdlib::Unixpath],
    rpz_action_override => Optional[Unbound::Rpz::Action],
    rpz_cname_override  => Optional[Stdlib::Fqdn],
    rpz_log             => Optional[Boolean],
    rpz_log_name        => Optional[String],
    tags                => Optional[Array[String]],
}]
