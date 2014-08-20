# Class: unbound::remote
#
# Configure remote control of the unbound daemon process
#
class unbound::remote (
    $enable                 = true,
    $interface              = ['::1', '127.0.0.1'],
    $port                   = 953,
    $server_key_file        = undef,
    $server_cert_file       = undef,
    $control_key_file       = undef,
    $control_cert_file      = undef,
    $manage_remote_firewall = $unbound::params::manage_remote_firewall
) {

  include unbound::params

  $config_file = $unbound::params::config_file

  concat::fragment { 'unbound-remote':
    order   => 10,
    target  => $config_file,
    content => template('unbound/remote.erb'),
  }
  if $manage_remote_firewall {
    case $::osfamily {
        'Suse': {
            susefw::services { "$port": ensure => present, zone => "ext", type => "tcpport" }
        }
        'Redhat': {
            firewall { '$port accept - unbound': port => '$port', proto => 'tcp', action => 'accept', }
        }
        default: {
            fail("Class['unbound::remote']: Manage Firewall Unsupported on: ${::osfamily}")
        }
    }
  }
}
