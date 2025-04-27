# @summary Create an unbound stub zone for caching upstream name resolvers
# @param address
#   IP address of server to forward to. Can be IP 4 or IP 6 (and an
#   array or a single value. To use a nondefault port for DNS communication
#   append  '@' with the port number.
# @param nameservers Name of stub zone nameserver. Is itself resolved before it is used.
# @param insecure
#   Sets domain name to be insecure, DNSSEC chain
#   of trust is ignored towards the domain name.  So a trust anchor  above the
#   domain  name can not make the domain secure with a DS record, such a DS
#   record is then ignored.  Also keys from DLV are ignored for the domain.
#   Can be given multiple times to specify multiple domains  that  are  treated
#   as  if unsigned.  If you set trust anchors for the domain they override
#   this setting (and the domain is secured).
#   This can be useful if you want to make sure a trust anchor for external
#   lookups does not affect an (unsigned) internal domain.  A DS record
#   externally can create validation failures for that internal domain.
# @param no_cache don't cache
# @param stub_first
#   Controls 'stub-first' stub zone option.
#   If true, a query that fails with the stub clause is attempted again
#   without the stub clause.
# @param type
#   can be 'deny', 'refuse', 'static', 'transparent', 'typetransparent', 'redirect' or 'nodefault'.
# @param config_file Name of the unbound config file
#
define unbound::stub (
  Variant[Array[Unbound::Address], Unbound::Address] $address,
  Array[Stdlib::Host]                                 $nameservers = [],
  # lint:ignore:quoted_booleans
  Variant[Boolean, Enum['true', 'false']]            $insecure    = false,
  Variant[Boolean, Enum['true', 'false']]            $no_cache    = false,
  Variant[Boolean, Enum['true', 'false']]            $stub_first  = false,
  # lint:endignore
  Unbound::Local_zone_type                           $type        = 'transparent',
  Optional[Stdlib::Unixpath]                         $config_file = undef,
) {
  include unbound
  $_config_file = pick($config_file, $unbound::config_file)
  $content = @("CONFIG")
    stub-zone:
    ${unbound::print_config('name', $name)}
    ${unbound::print_config('stub-addr', $address)}
    ${unbound::print_config('stub-host', $nameservers)}
    ${unbound::print_config('stub-first', $stub_first)}
    ${unbound::print_config('stub-no-cache', $no_cache)}
    | CONFIG
  concat::fragment { "unbound-stub-${name}":
    order   => '15',
    target  => $_config_file,
    content => $content.extlib::remove_blank_lines(),
  }

  if str2bool($insecure) == true {
    concat::fragment { "unbound-stub-${name}-insecure":
      order   => '01',
      target  => $_config_file,
      content => "  domain-insecure: \"${name}\"\n",
    }
  }

  concat::fragment { "unbound-stub-${name}-local-zone":
    order   => '02',
    target  => $_config_file,
    content => "  local-zone: \"${name}\" ${type} \n",
  }
}
