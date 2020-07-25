# Class: unbound::forward
#
# Configures a zone for DNS forwarding
#
# == Parameters:
#
# [*zone*]
#   (required) the name of the zone.
#
# [*address*]
#   IP address of server to forward queries to. Can be IP 4 or IP 6 (and an
#   array or a single value. To use a nondefault port for DNS communication
#   append '@' with the port number.
#
# [*host*]
#   Hostname of server to forward queries to. Can be IP 4 or IP 6 (and an array
#   or a single value. To use a nondefault port for DNS communication append
#   '@' with the port number.
#
# [*forward_first*]
#   (optional) If enabled, a query is attempted without the forward clause if
#   it fails.  The data could not be retrieved and would have caused SERVFAIL
#   because the servers are unreachable, instead it is tried without this
#   clause. The default is 'no'.
#
# [*forward_ssl_upstream*]
#   (optional) If enabled, unbound will query the forward DNS server via TLS.
#
# [*config_file*]
#   (optional) name of configuration file
#
define unbound::forward (
  Array $address                          = [],
  Array $host                             = [],
  $zone                                   = $name,
  Pattern[/yes|no/] $forward_first        = 'no',
  Pattern[/yes|no/] $forward_ssl_upstream = 'no',
  Pattern[/yes|no/] $forward_tls_upstream = 'no',
  $config_file                            = $unbound::config_file,
) {
  concat::fragment { "unbound-forward-${name}":
    order   => '20',
    target  => $config_file,
    content => template('unbound/forward.erb'),
  }
}
