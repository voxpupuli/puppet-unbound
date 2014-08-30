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
      $fetch_client = 'wget -O'
    }
    'redhat', 'centos', 'scientific': {
      $confdir      = '/etc/unbound'
      $logdir       = '/var/log'
      $service_name = 'unbound'
      $package_name = 'unbound'
      $anchor_file  = 'root.anchor'
      $owner        = 'unbound'
      $fetch_client = 'wget -O'
      }
    'darwin': {
      $confdir          = '/opt/local/etc/unbound'
      $logdir           = '/opt/local/var/log/unbound'
      $service_name     = 'org.macports.unbound'
      $package_name     = 'unbound'
      $package_provider = 'macports'
      $anchor_file      = 'root.key'
      $owner            = 'unbound'
      $fetch_client     = 'curl -o'
    }
    'freebsd': {
      $confdir      = '/usr/local/etc/unbound'
      $logdir       = '/var/log/unbound'
      $service_name = 'unbound'
      $package_name = 'dns/unbound'
      $anchor_file  = 'root.key'
      $owner        = 'unbound'
      $fetch_client = 'fetch -o'
    }
    'openbsd': {
      $confdir      = '/var/unbound/etc'
      $logdir       = '/var/log/unbound'
      $service_name = 'unbound'
      if versioncmp($::operatingsystemrelease, '5.6') < 0 {
        $package_name = 'unbound'
      } else {
        $package_name = undef
      }
      $anchor_file  = 'root.key'
      $owner        = '_unbound'
      $fetch_client = 'ftp -o'
    }
    default: {
      $confdir      = '/etc/unbound'
      $logdir       = '/var/log'
      $service_name = 'unbound'
      $package_name = 'unbound'
      $anchor_file  = 'root.key'
      $owner        = 'unbound'
      $fetch_client = 'wget -O'
    }
  }

  $config_file = "${confdir}/unbound.conf"
  $hints_file  = 'root.hints'
}
