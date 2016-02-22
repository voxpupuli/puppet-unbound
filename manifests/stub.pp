# Class: unbound::stub
#
# Create an unbound stub zone for caching upstream name resolvers
#
# === Parameters:
#
# [*address*]
#   (required) IP address of server to forward to. Can be IP 4 or IP 6 (and an
#   array or a single value. To use a nondefault port for DNS communication
#   append  '@' with the port number.
#
# [*insecure*]
#   (optional) Defaults to false. Sets domain name to be insecure, DNSSEC chain
#   of trust is ignored towards the domain name.  So a trust anchor  above the
#   domain  name can not make the domain secure with a DS record, such a DS
#   record is then ignored.  Also keys from DLV are ignored for the domain.
#   Can be given multiple times to specify multiple domains  that  are  treated
#   as  if unsigned.  If you set trust anchors for the domain they override
#   this setting (and the domain is secured).
#   This can be useful if you want to make sure a trust anchor for external
#   lookups does not affect an (unsigned) internal domain.  A DS record
#   externally can create validation failures for that internal domain.
#
# [*type*]
#   (optional) Defaults to 'transparent', can be 'deny', 'refuse', 'static',
#   'transparent', 'typetransparent', 'redirect' or 'nodefault'.
#
# [*config_file*]
#   (optional) Name of the unbound config file
#
define unbound::stub (
  $address,
  $insecure    = false,
  $type        = 'transparent',
  $config_file = $unbound::params::config_file,
) {

  if ! $address {
    fail('unbound::stub: address(es) must be specified.')
  }

  validate_unbound_addr($address)

  include ::unbound::params

  concat::fragment { "unbound-stub-${name}":
    order   => '15',
    target  => $config_file,
    content => template('unbound/stub.erb'),
  }

  if str2bool($insecure) == true {
    concat::fragment { "unbound-stub-${name}-insecure":
      order   => '01',
      target  => $config_file,
      content => "  domain-insecure: \"${name}\"\n",
    }
  }

  concat::fragment { "unbound-stub-${name}-local-zone":
    order   => '02',
    target  => $config_file,
    content => "  local-zone: \"${name}\" ${type} \n",
  }
}
