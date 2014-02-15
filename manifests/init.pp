# Class: unbound
#
# Installs and configures Unbound, the caching DNS resolver from NLnet Labs
#
class unbound (
  $verbosity              = 1,
  $interface              = ['::0','0.0.0.0'],
  $access                 = ['::1','127.0.0.1/8'],
  $do_ip4                 = true,
  $do_ip6                 = true,
  $interface_automatic    = false,
  $outgoing_interface     = undef,
  $extended_statistics    = no,
  $statistics_interval    = 0,
  $statistics_cumulative  = false,
  $control_enable         = false,
  $num_threads            = 1,
  $private_domain         = undef,
  $prefetch               = false,
  $infra_host_ttl         = undef,
  $port                   = 53,
  $confdir                = $unbound::params::confdir,
  $config_file            = $unbound::params::config_file,
  $logdir                 = $unbound::params::logdir,
  $service_name           = $unbound::params::service_name,
  $package_name           = $unbound::params::package_name,
  $package_provider       = $unbound::params::package_provider,
  $anchor_file            = $unbound::params::anchor_file,
  $hints_file             = $unbound::params::hints_file,
  $owner                  = $unbound::params::owner,
  $root_hints_url         = 'http://www.internic.net/domain/named.root',
  $msg_cache_slabs        = undef,
  $rrset_cache_slabs      = undef,
  $infra_cache_slabs      = undef,
  $key_cache_slabs        = undef,
  $rrset_cache_size       = undef,
  $msg_cache_size         = undef,
  $key_cache_size         = undef,
  $num_queries_per_thread = undef,
  $outgoing_range         = undef,
  $so_rcvbuf              = undef,
  $tcp_upstream           = false
) inherits unbound::params {

  package { $package_name:
    ensure   => installed,
    provider => $package_provider,
  }

  service { $service_name:
    ensure    => running,
    name      => $service_name,
    enable    => true,
    hasstatus => false,
    require   => Package[$package_name],
  }


  exec { 'download-roothints':
    command => "curl -o ${confdir}/${hints_file} ${root_hints_url}",
    creates => "${confdir}/${hints_file}",
    path    => ['/usr/bin','/usr/local/bin'],
    before  => [ Concat::Fragment['unbound-header'] ],
  }

  file { "${confdir}/${hints_file}":
    mode => '0444',
  }

  concat { $config_file:
    notify  => Service[$service_name],
    require => Package[$package_name],
  }

  concat::fragment { 'unbound-header':
    order   => '00',
    target  => $config_file,
    content => template('unbound/unbound.conf.erb'),
  }

  # Initialize the root key file if it doesn't already exist.
  file { "${confdir}/${anchor_file}":
    owner   => $owner,
    group   => 0,
    content => '. IN DS 19036 8 2 49AAC11D7B6F6446702E54A1607371607A1A41855200FD2CE1CDDE32F24E8FB5',
    replace => false,
    require => Package[$package_name],
  }

}
