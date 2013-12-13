# Class: unbound::params
#
# Set some params for the unbound module
#
class unbound::params {

  case $::operatingsystem {
    'ubuntu', 'debian': {
      $confdir      = '/etc/unbound'
      $logdir       = '/var/log'
      $service_name = 'unbound'
      $package_name = 'unbound'
      $anchor_file  = 'root.key'
      $owner        = 'unbound'
    }
    'redhat', 'centos', 'scientific': {
      $confdir      = '/etc/unbound'
      $logdir       = '/var/log'
      $service_name = 'unbound'
      $package_name = 'unbound'
      $anchor_file  = 'root.anchor'
      $owner        = 'unbound'
      }
    'darwin': {
      $confdir          = '/opt/local/etc/unbound'
      $logdir           = '/opt/local/var/log/unbound'
      $service_name     = 'org.macports.unbound'
      $package_name     = 'unbound'
      $package_provider = 'macports'
      $anchor_file      = 'root.key'
      $owner            = 'unbound'
    }
    'freebsd': {
      $confdir      = '/usr/local/etc/unbound'
      $logdir       = '/var/log/unbound'
      $service_name = 'unbound'
      $package_name = 'dns/unbound'
      $anchor_file  = 'root.key'
      $owner        = 'unbound'
    }
    'openbsd': {
      $confdir      = '/var/unbound/etc'
      $logdir       = '/var/log/unbound'
      $service_name = 'unbound'
      $package_name = 'unbound'
      $anchor_file  = 'root.key'
      $owner        = '_unbound'
    }
  }

  $config_file = "${confdir}/unbound.conf"
  $hints_file  = 'root.hints'
}
