# Create an unbound forward zone
define unbound::forward (
  $address,
) {

  include unbound::params

  $unbound_confdir = $unbound::params::unbound_confdir

  concat::fragment { "unbound-forward-${name}":
    order   => '05',
    target  => "${unbound_confdir}/unbound.conf",
    content => template('unbound/forward.erb'),
  }
}
