# Class: unbound
#
# Installs and configures Unbound, the caching DNS resolver from NLnet Labs
#
class unbound (
  $verbosity             = 1,
  $interface             = ['::0','0.0.0.0'],
  $access                = ['::1','127.0.0.1/8'],
  $do_ip4                = true,
  $do_ip6                = true,
  $interface_automatic   = false,
  $outgoing_interface    = undef,
  $extended_statistics   = no,
  $statistics_interval   = 0,
  $statistics_cumulative = false,
  $control_enable        = 'no',
  $num_threads           = 1,
  $private_domain        = undef,
  $prefetch              = false,
  $infra_host_ttl        = undef,
  $port                  = 53,
  $unbound_package       = $unbound::params::unbound_package,
  $unbound_confdir       = $unbound::params::unbound_confdir,
  $unbound_logdir        = $unbound::params::unbound_logdir,
  $unbound_service       = $unbound::params::unbound_service,
  $unbound_anchor_file   = $unbound::params::unbound_anchor_file,
  $unbound_hints_file    = $unbound::params::unbound_hints_file,
  $unbound_owner         = $unbound::params::owner,
) inherits unbound::params {

  $provider = $::kernel ? {
    Darwin  => 'macports',
    default => undef,
  }

  package { $unbound_package:
    ensure   => installed,
    provider => $provider,
  }

  service { $unbound_service:
    ensure    => running,
    name      => $unbound_service,
    enable    => true,
    hasstatus => false,
    require   => Package[$unbound_package],
  }

  $root_hints_url = 'http://www.internic.net/domain/named.root'

  exec { 'download-roothints':
    command => "curl -o ${unbound_confdir}/${unbound_hints_file} ${root_hints_url}",
    creates => "${unbound_confdir}/${unbound_hints_file}",
    path    => ['/usr/bin','/usr/local/bin'],
    before  => [ Concat::Fragment['unbound-header'] ],
  }

  file { "${unbound_confdir}/${unbound_hints_file}":
    mode => '0444',
  }

  concat::fragment { 'unbound-header':
    order   => '00',
    target  => "${unbound_confdir}/unbound.conf",
    content => template('unbound/unbound.conf.erb'),
    require => Package[$unbound_package],
  }

  concat { "${unbound_confdir}/unbound.conf":
    notify  => Service[$unbound_service],
    require => Package[$unbound_package],
  }

  # Initialize the root key file if it doesn't already exist.
  file { "${unbound_confdir}/${unbound_anchor_file}":
    owner   => $unbound_owner,
    group   => 0,
    content => '. IN DS 19036 8 2 49AAC11D7B6F6446702E54A1607371607A1A41855200FD2CE1CDDE32F24E8FB5',
    replace => false,
    require => Package[$unbound_package],
  }
}
