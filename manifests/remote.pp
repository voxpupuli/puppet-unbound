# Class: unbound::remote
#
# Configure remote control of the unbound daemon process
#
class unbound::remote (
  $enable            = true,
  $interface         = ['::1', '127.0.0.1'],
  $port              = 953,
  $server_key_file   = "${unbound::confdir}/unbound_server.key",
  $server_cert_file  = "${unbound::confdir}/unbound_server.pem",
  $control_key_file  = "${unbound::confdir}/unbound_control.key",
  $control_cert_file = "${unbound::confdir}/unbound_control.pem",
  $group             = $unbound::group,
  $confdir           = $unbound::confdir,
) inherits unbound {

  $config_file = $unbound::config_file

  concat::fragment { 'unbound-remote':
    order   => '10',
    target  => $config_file,
    content => template('unbound/remote.erb'),
  }

  exec { 'unbound-control-setup':
    command => "unbound-control-setup -d ${confdir}",
    creates => $server_key_file,
  } ->
  file { [ $server_key_file, $server_cert_file, $control_key_file, $control_cert_file ]:
    owner => 'root',
    group => $group,
    mode  => '0640',
  }
}
