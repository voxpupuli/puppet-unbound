# Class: unbound::forward
#
# Configures a zone for DNS forwarding
#
define unbound::forward (
  $address,
) {

  include unbound::params

  $config_file = $unbound::params::config_file
  $zone        = $name

  concat::fragment { "unbound-forward-${name}":
    order   => '05',
    target  => $config_file,
    content => template('unbound/forward.erb'),
  }
}
