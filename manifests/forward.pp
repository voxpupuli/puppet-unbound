# Class: unbound::forward
#
# Configures a zone for DNS forwarding
#
define unbound::forward (
  $address,
  $zone = $name,
) {

  include unbound::params

  $config_file = $unbound::params::config_file

  concat::fragment { "unbound-forward-${name}":
    order   => '05',
    target  => $config_file,
    content => template('unbound/forward.erb'),
  }
}
