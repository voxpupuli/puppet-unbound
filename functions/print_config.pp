# @summary Print a configuration value if it is defined and the version is supported
# @param name the config item name
# @param value the config item value
# @param version the version when the config item was introduced
# @return the config item as a string or an empty string if the version is not supported
function unbound::print_config (
  String[1]                                                     $name,
  Optional[Variant[Boolean, Integer, String, Array[String, 1]]] $value   = undef,
  Optional[String[1]]                                           $version = undef,
) >> String {
  $unbound_version = $facts['unbound_version'].lest || { '0.a' }
  if ($value =~ Undef or ($version =~ NotUndef and versioncmp($unbound_version, $version) < 0)) {
    return ''
  }
  $value ? {
    String  => "  ${name}: \"${value}\"",
    Integer => "  ${name}: ${value}",
    Boolean => "  ${name}: ${value.bool2str('yes', 'no')}",
    Array   => $value.map |$v| { "  ${name}: \"${v}\"" }.join("\n"),
  }
}
