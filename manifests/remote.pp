# Class: unbound::remote
#
# Configure remote control of the unbound daemon process
#
class unbound::remote (
  $interface         = ['::1', '127.0.0.1'],
  $port              = 953,
  $server_key_file   = undef,
  $server_cert_file  = undef,
  $control_key_file  = undef,
  $control_cert_file = undef
) {
  include unbound::params

  $unbound_confdir = "${unbound::params::unbound_confdir}/"

  concat::fragment { 'unbound-remote':
    order   => 10,
    target  => "${unbound_confdir}unbound.conf",
    content => template('unbound/remote.erb'),
  }
}
