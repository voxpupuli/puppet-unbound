# @summary Configures a zone for DNS forwarding
# @param zone the name of the zone.
# @param address
#   IP address of server to forward queries to. Can be IP 4 or IP 6 (and an
#   array or a single value. To use a nondefault port for DNS communication
#   append '@' with the port number.
# @param host
#   Hostname of server to forward queries to. Can be IP 4 or IP 6 (and an array
#   or a single value. To use a nondefault port for DNS communication append
#   '@' with the port number.
# @param forward_first
#   If enabled, a query is attempted without the forward clause if
#   it fails.  The data could not be retrieved and would have caused SERVFAIL
#   because the servers are unreachable, instead it is tried without this
#   clause. The default is 'no'.
# @param forward_ssl_upstream
#   If enabled, unbound will query the forward DNS server via TLS.
# @param forward_tls_upstream
#   If enabled, unbound will query the forward DNS server via TLS.
# @param config_file name of configuration file
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
  $content = @("CONTENT")
    forward-zone:
    ${unbound::print_config('name', $zone)}
    ${unbound::print_config('forward-addr', $address)}
    ${unbound::print_config('forward-host', $host)}
    ${unbound::print_config('forward-first', $forward_first)}
    ${unbound::print_config('forward-ssl-upstream', $forward_ssl_upstream)}
    ${unbound::print_config('forward-tls-upstream', $forward_tls_upstream)}
    | CONTENT
  concat::fragment { "unbound-forward-${name}":
    order   => '20',
    target  => $config_file,
    content => $content.extlib::remove_blank_lines(),
  }
}
