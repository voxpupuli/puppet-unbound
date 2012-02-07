class unbound::params {
 case $operatingsystem {
  'ubuntu', 'debian': {
    $unboudn_package = 'unbound'
    $unbound_confdir = '/etc/unbound'
    $unbound_logdir  = '/var/log'
    $unbound_service = 'unbound'
  }
  'darwin': {
    $unboudn_package = 'unbound'
    $unbound_confdir = '/opt/local/etc/unbound'
    $unbound_logdir  = '/opt/local/var/log/unbound'
    $unbound_service = 'org.macports.unbound'
  }
  'freebsd': {
    $unboudn_package = 'dns/unbound'
    $unbound_confdir = '/usr/local/etc/unbound'
    $unbound_logdir  = '/usr/local/var/log/unbound'
    $unbound_service = 'unbound'
  }
 }
}
