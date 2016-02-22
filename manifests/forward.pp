# Class: unbound::forward
#
# Configures a zone for DNS forwarding
#
# == Parameters:
#
# [*address*]
#   (required) IP address of server to forward to. Can be IP 4 or IP 6 (and an
#   array or a single value. To use a nondefault port for DNS communication
#   append  '@' with the port number.
#
# [*zone*]
#   (required) the name of the zone.
#
# [*forward_first*]
#   (optional) If enabled, a query is attempted without the forward clause if
#   it fails.  The data could not be retrieved and would have caused SERVFAIL
#   because the servers are unreachable, instead it is tried without this
#   clause. The default is 'no'.
#
# [*config_file*]
#   (optional) name of configuration file
#
define unbound::forward (
  $address,
  $zone          = $name,
  $forward_first = 'no',
  $config_file   = $unbound::params::config_file,
) {

  # Validate yes/no
  $r_yesno = [ 'yes', 'no' ]
  validate_re($forward_first, $r_yesno)

  include ::unbound::params

  concat::fragment { "unbound-forward-${name}":
    order   => '20',
    target  => $config_file,
    content => template('unbound/forward.erb'),
  }
}
