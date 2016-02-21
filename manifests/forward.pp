# Class: unbound::forward
#
# Configures a zone for DNS forwarding
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
