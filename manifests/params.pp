class unbound::params {
 case $operatingsystem {
  'ubuntu', 'debian': {
    $unbound_confdir = '/etc/unbound'
    $unbound_logdir = '/var/log'
    $unbound_service = 'unbound'
  }
  'darwin': {
    $unbound_confdir = '/opt/local/etc/unbound'
    $unbound_logdir = '/opt/local/var/log/unbound'
    $unbound_service = 'org.macports.unbound'
  }
 }
}
