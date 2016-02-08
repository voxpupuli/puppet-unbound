# Class: unbound
#
# Installs and configures Unbound, the caching DNS resolver from NLnet Labs
#
class unbound (
  $forward                      = {},
  $stub                         = {},
  $record                       = {},
  $access                       = $unbound::params::access,
  $anchor_fetch_command         = $unbound::params::anchor_fetch_command,
  $auto_trust_anchor_file       = $unbound::params::auto_trust_anchor_file,
  $chroot                       = $unbound::params::chroot,
  $conf_d                       = $unbound::params::conf_d,
  $confdir                      = $unbound::params::confdir,
  $config_file                  = $unbound::params::config_file,
  $control_enable               = $unbound::params::control_enable,
  $directory                    = $unbound::params::directory,
  $dlv_anchor_file              = $unbound::params::dlv_anchor_file,
  $do_ip4                       = $unbound::params::do_ip4,
  $do_ip6                       = $unbound::params::do_ip6,
  $edns_buffer_size             = $unbound::params::edns_buffer_size,
  $extended_statistics          = $unbound::params::extended_statistics,
  $fetch_client                 = $unbound::params::fetch_client,
  $group                        = $unbound::params::group,
  $harden_below_nxdomain        = $unbound::params::harden_below_nxdomain,
  $harden_dnssec_stripped       = $unbound::params::harden_dnssec_stripped,
  $harden_glue                  = $unbound::params::harden_glue,
  $harden_referral_path         = $unbound::params::harden_referral_path,
  $hide_identity                = $unbound::params::hide_identity,
  $hide_version                 = $unbound::params::hide_version,
  $hints_file                   = $unbound::params::hints_file,
  $infra_cache_slabs            = $unbound::params::infra_cache_slabs,
  $infra_host_ttl               = $unbound::params::infra_host_ttl,
  $interface                    = $unbound::params::interface,
  $interface_automatic          = $unbound::params::interface_automatic,
  $key_cache_size               = $unbound::params::key_cache_size,
  $key_cache_slabs              = $unbound::params::key_cache_slabs,
  $keys_d                       = $unbound::params::keys_d,
  $log_time_ascii               = $unbound::params::log_time_ascii,
  $logdir                       = $unbound::params::logdir,
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
  $runtime_dir                  = $unbound::params::runtime_dir,
  $rrset_cache_size             = $unbound::params::rrset_cache_size,
  $rrset_cache_slabs            = $unbound::params::rrset_cache_slabs,
  $service_name                 = $unbound::params::service_name,
  $so_rcvbuf                    = $unbound::params::so_rcvbuf,
  $so_sndbuf                    = $unbound::params::so_sndbuf,
  $statistics_cumulative        = $unbound::params::statistics_cumulative,
  $statistics_interval          = $unbound::params::statistics_interval,
  $tcp_upstream                 = $unbound::params::tcp_upstream,
  $trusted_keys_file            = $unbound::params::trusted_keys_file,
  $unwanted_reply_threshold     = $unbound::params::unwanted_reply_threshold,
  $use_caps_for_id              = $unbound::params::use_caps_for_id,
  $val_clean_additional         = $unbound::params::val_clean_additional,
  $val_log_level                = $unbound::params::val_log_level,
  $val_permissive_mode          = $unbound::params::val_permissive_mode,
  $validate_cmd                 = $unbound::params::validate_cmd,
  $verbosity                    = $unbound::params::verbosity,
  $custom_server_conf           = $unbound::params::custom_server_conf,
  $skip_roothints_download      = $unbound::params::skip_roothints_download,
) inherits unbound::params {

  if $package_name {
    package { $package_name:
      ensure   => installed,
      provider => $package_provider,
    }
    Package[$package_name] -> Service[$service_name]
    Package[$package_name] -> Concat[$config_file]
    Package[$package_name] -> File[$confdir]
    Package[$package_name] -> File[$conf_d]
    Package[$package_name] -> File[$keys_d]
    Package[$package_name] -> File[$runtime_dir]
    Package[$package_name] -> Exec['download-roothints']
    Package[$package_name] -> File[$hints_file]
  }

  service { $service_name:
    ensure    => running,
    name      => $service_name,
    enable    => true,
    hasstatus => false,
  }
  if $control_enable {
    Service[$service_name] {
      restart   => 'unbound-control reload',
      require   => Class['unbound::remote'],
    }
    Package<| title == $package_name |> -> Class['unbound::remote']
    include unbound::remote
  }

  if $skip_roothints_download {
    File[$hints_file] -> Exec['download-roothints']
  } else {
    Exec['download-roothints'] -> File[$hints_file]
  }
  
  file { [
    $confdir,
    $conf_d,
    $keys_d
    ]:
    ensure  => directory,
  } ->

  exec { 'download-roothints':
    command => "${fetch_client} ${hints_file} ${root_hints_url}",
    creates => $hints_file,
    path    => ['/usr/bin','/usr/local/bin'],
    before  => [ Concat::Fragment['unbound-header'] ],
  }
  
  if $confdir == $runtime_dir {
    File[$confdir] {
      owner => $owner,
    }
  } else {
    file { $runtime_dir:
      ensure => directory,
      owner  => $owner,
    }
  }

  exec { 'download-anchor-file':
    command => $anchor_fetch_command,
    creates => $auto_trust_anchor_file,
    user    => $owner,
    path    => ['/usr/sbin','/usr/local/sbin'],
    returns => 1,
    before  => [ Concat::Fragment['unbound-header'] ],
    require => File[$runtime_dir],
  }

  file { $hints_file:
    ensure => file,
    mode   => '0444',
  }

  concat { $config_file:
    validate_cmd => $validate_cmd,
    notify       => Service[$service_name],
  }

  concat::fragment { 'unbound-header':
    order   => '00',
    target  => $config_file,
    content => template('unbound/unbound.conf.erb'),
  }

  validate_hash($forward)
  if $forward {
    create_resources('unbound::forward', $forward)
  }
  validate_hash($stub)
  if $stub {
    create_resources('unbound::stub', $stub)
  }
  validate_hash($record)
  if $record {
    create_resources('unbound::record', $record)
  }

}
