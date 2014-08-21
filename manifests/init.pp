# Class: unbound
#
# Installs and configures Unbound, the caching DNS resolver from NLnet Labs
#
class unbound (
    $access                       = $unbound::params::access,
    $anchor_file                  = $unbound::params::anchor_file,
    $chroot                       = $unbound::params::chroot,
    $conf_d                       = $unbound::params::conf_d,
    $confdir                      = $unbound::params::confdir,
    $config_file                  = $unbound::params::config_file,
    $control_enable               = $unbound::params::control_enable,
    $directory                    = $unbound::params::directory,
    $dlv_anchor_file              = $unbound::params::dlv_anchor_file,
    $do_ip4                       = $unbound::params::do_ip4,
    $do_ip6                       = $unbound::params::do_ip6,
    $extended_statistics          = $unbound::params::extended_statistics,
    $group                        = $unbound::params::group,
    $harden_below_nxdomain        = $unbound::params::harden_below_nxdomain,
    $harden_dnssec_stripped       = $unbound::params::harden_dnssec_stripped,
    $harden_glue                  = $unbound::params::harden_glue,
    $harden_referral_path         = $unbound::params::harden_referral_path,
    $hints_file                   = $unbound::params::hints_file,
    $infra_cache_slabs            = $unbound::params::infra_cache_slabs,
    $infra_host_ttl               = $unbound::params::infra_host_ttl,
    $interface                    = $unbound::params::interface,
    $interface_automatic          = $unbound::params::interface_automatic,
    $key_cache_size               = $unbound::params::key_cache_size,
    $key_cache_slabs              = $unbound::params::key_cache_slabs,
    $keys_d                       = $unbound::params::keys_d,
    $local_d                      = $unbound::params::local_d,
    $log_time_ascii               = $unbound::params::log_time_ascii,
    $logdir                       = $unbound::params::logdir,
    $manage_firewall              = $unbound::params::manage_firewall,
    $max_udp_size                 = $unbound::params::max_udp_size,
    $minimal_responses            = $unbound::params::minimal_responses,
    $module_config                = $unbound::params::module_config,
    $msg_cache_size               = $unbound::params::msg_cache_size,
    $msg_cache_slabs              = $unbound::params::msg_cache_slabs,
    $num_queries_per_thread       = $unbound::params::num_queries_per_thread,
    $num_threads                  = $unbound::params::num_threads,
    $outgoing_interface           = $unbound::params::outgoing_interface,
    $outgoing_port_avoid          = $unbound::params::outgoing_port_avoid,
    $outgoing_port_permit         = $unbound::params::outgoing_port_permit,
    $outgoing_range               = $unbound::params::outgoing_range,
    $owner                        = $unbound::params::owner,
    $package_name                 = $unbound::params::package_name,
    $package_provider             = $unbound::params::package_provider,
    $port                         = $unbound::params::port,
    $prefetch                     = $unbound::params::prefetch,
    $prefetch_key                 = $unbound::params::prefetch_key,
    $private_domain               = $unbound::params::private_domain,
    $root_hints_url               = $unbound::params::root_hints_url,
    $rrset_cache_size             = $unbound::params::rrset_cache_size,
    $rrset_cache_slabs            = $unbound::params::rrset_cache_slabs,
    $rrset_roundrobin             = $unbound::params::rrset_roundrobin,
    $service_name                 = $unbound::params::service_name,
    $so_rcvbuf                    = $unbound::params::so_rcvbuf,
    $statistics_cumulative        = $unbound::params::statistics_cumulative,
    $statistics_interval          = $unbound::params::statistics_interval,
    $tcp_upstream                 = $unbound::params::tcp_upstream,
    $trusted_keys_file            = $unbound::params::trusted_keys_file,
    $unwanted_reply_threshold     = $unbound::params::unwanted_reply_threshold,
    $use_caps_for_id              = $unbound::params::use_caps_for_id,
    $val_clean_additional         = $unbound::params::val_clean_additional,
    $val_log_level                = $unbound::params::val_log_level,
    $val_permissive_mode          = $unbound::params::val_permissive_mode,
    $verbosity                    = $unbound::params::verbosity,
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
    command => "curl -o ${hints_file} ${root_hints_url}",
    creates => "${hints_file}",
    path    => ['/usr/bin','/usr/local/bin'],
    before  => [ Concat::Fragment['unbound-header'] ],
  }

  file { [
    $confdir,
    $local_d,
    $conf_d,
    $keys_d
    ]:
    ensure  => directory,
    require => Package[$package_name],
  }

  file { "${hints_file}":
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
  file { $anchor_file:
    owner   => $owner,
    group   => 0,
    content => '. IN DS 19036 8 2 49AAC11D7B6F6446702E54A1607371607A1A41855200FD2CE1CDDE32F24E8FB5',
    replace => false,
    require => Package[$package_name],
  }
  if $manage_firewall {
    case $::osfamily {
        'Suse': {
            susefw::services { "unbound": ensure => present, zone => "ext", type => "service" }
        }
        'Redhat': {
            firewall { '53-tcp accept - unbound': port => '53', proto => 'tcp', action => 'accept', }
            firewall { '53-udp accept - unbound': port => '53', proto => 'udp', action => 'accept', }
        }
        default: {
            fail("Class['unbound']: Manage Firewall Unsupported on: ${::osfamily}")
        }
    }
  }
}
