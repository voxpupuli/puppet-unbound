# Class: unbound::params
#
# Set some params for the unbound module
#
class unbound::params {

  case $::operatingsystem {
    'ubuntu', 'debian': {
      $unbound_confdir     = '/etc/unbound'
      $unbound_logdir      = '/var/log'
      $unbound_service     = 'unbound'
      $unbound_package     = 'unbound'
      $unbound_anchor_file = 'root.key'
      $owner               = 'unbound'
    }
    'redhat', 'centos', 'scientific': {
      $unbound_confdir     = '/etc/unbound'
      $unbound_logdir      = '/var/log'
      $unbound_service     = 'unbound'
      $unbound_package     = 'unbound'
      $unbound_anchor_file = 'root.anchor'
      $owner               = 'unbound'
      }
    'darwin': {
      $unbound_confdir     = '/opt/local/etc/unbound'
      $unbound_logdir      = '/opt/local/var/log/unbound'
      $unbound_service     = 'org.macports.unbound'
      $unbound_package     = 'unbound'
      $unbound_anchor_file = 'root.key'
      $owner               = 'unbound'
    }
    'freebsd': {
      $unbound_confdir     = '/usr/local/etc/unbound'
      $unbound_logdir      = '/var/log/unbound'
      $unbound_service     = 'unbound'
      $unbound_package     = 'dns/unbound'
      $unbound_anchor_file = 'root.key'
      $owner               = 'unbound'
    }
    'openbsd': {
      $unbound_confdir     = '/var/unbound/etc'
      $unbound_logdir      = '/var/log/unbound'
      $unbound_service     = 'unbound'
      $unbound_package     = 'unbound'
      $unbound_anchor_file = 'root.key'
      $owner               = '_unbound'
    }
  }

  $unbound_hints_file = 'root.hints'
}
