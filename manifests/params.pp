class unbound::params {
  case $operatingsystem {
    'ubuntu', 'debian': {
      $unbound_confdir = '/etc/unbound'
      $unbound_logdir = '/var/log'
      $unbound_service = 'unbound'
      $unbound_package = 'unbound'
      $unbound_anchor_file = 'root.key'
    }
    'redhat', 'centos', 'scientific': {
      $unbound_confdir = '/etc/unbound'
      $unbound_logdir = '/var/log'
      $unbound_service = 'unbound'
      $unbound_package = 'unbound'
      $unbound_anchor_file = 'root.anchor'
    }
    'darwin': {
      $unbound_confdir = '/opt/local/etc/unbound'
      $unbound_logdir  = '/opt/local/var/log/unbound'
      $unbound_service = 'org.macports.unbound'
      $unbound_package = 'unbound'
      $unbound_anchor_file = 'root.key'
    }
    'freebsd': {
      $unbound_confdir = '/usr/local/etc/unbound'
      $unbound_logdir  = '/var/log/unbound'
      $unbound_service = 'unbound'
      $unbound_package = 'dns/unbound'
      $unbound_anchor_file = 'root.key'
    }
  }
  $unbound_hints_file = 'root.hints'
  $ipaddress_array = split("${::ipaddress_all}::0", ",")
}
