# Class: unbound::remote
#
# Configure remote control of the unbound daemon process
#
class unbound::remote (
  $enable            = true,
  $interface         = ['::1', '127.0.0.1'],
  $port              = 953,
  $server_key_file   = undef,
  $server_cert_file  = undef,
  $control_key_file  = undef,
  $control_cert_file = undef
) {

  include unbound::params

  $config_file = $unbound::params::config_file

  concat::fragment { 'unbound-remote':
    order   => 10,
    target  => $config_file,
    content => template('unbound/remote.erb'),
  }
}
