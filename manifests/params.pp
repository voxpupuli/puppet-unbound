class unbound::params {
  case $operatingsystem {
    'ubuntu', 'debian': {
      $unbound_confdir = '/etc/unbound'
      $unbound_logdir = '/var/log'
      $unbound_service = 'unbound'
      $unbound_package = 'unbound'
    }
    'darwin': {
      $unbound_confdir = '/opt/local/etc/unbound'
      $unbound_logdir  = '/opt/local/var/log/unbound'
      $unbound_service = 'org.macports.unbound'
      $unbound_package = 'unbound'
    }
    'freebsd': {
      $unbound_confdir = '/usr/local/etc/unbound'
      $unbound_logdir  = '/var/log/unbound'
      $unbound_service = 'unbound'
      $unbound_package = 'dns/unbound'
    }
  }
}
