# Class: unbound::forward
#
# Configures a zone for DNS forwarding
#
define unbound::forward (
  $address,
  $zone = $name,
) {

  $config_file = $unbound::config_file

  concat::fragment { "unbound-forward-${name}":
    order   => '20',
    target  => $config_file,
    content => template('unbound/forward.erb'),
  }
}
