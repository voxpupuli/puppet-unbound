# Class: unbound
#
# Installs and configures Unbound, the caching DNS resolver from NLnet Labs
#
class unbound (
  Hash $forward                      = {},
  Hash $stub                         = {},
  Hash $record                       = {},
  Array $access,
  String $anchor_fetch_command,
  String $auto_trust_anchor_file,
  Optional[String] $chroot,
  String $conf_d,
  String $confdir,
  String $config_file,
  Boolean $control_enable,
  String $control_setup_path,
  String $control_path,
  String $directory,
  Optional[String] $dlv_anchor_file,
  Boolean $do_ip4,
  Boolean $do_ip6,
  Optional[Integer] $edns_buffer_size,
  Boolean $extended_statistics,
  String $fetch_client,
  String $group,
  Boolean $harden_below_nxdomain,
  Boolean $harden_dnssec_stripped,
  Boolean $harden_glue,
  Boolean $harden_referral_path,
  Boolean $hide_identity,
  Boolean $hide_version,
  String $hints_file,
  Optional[Integer] $infra_cache_slabs,
  Optional[Integer] $infra_host_ttl,
  Array $interface,
  Boolean $interface_automatic,
  $key_cache_size,
  Optional[Integer] $key_cache_slabs,
  String $keys_d,
  Boolean $log_time_ascii,
  String $logdir,
  Optional[String] $module_config,
  Optional[String] $msg_cache_size,
  Optional[Integer] $msg_cache_slabs,
  Optional[Integer] $num_queries_per_thread,
  Integer $num_threads,
  $outgoing_interface,
  $outgoing_port_avoid,
  $outgoing_port_permit,
  $outgoing_range,
  $owner,
  String $package_name,
  $package_provider,
  $port,
  $prefetch,
  $prefetch_key,
  $private_domain,
  $root_hints_url,
  $runtime_dir,
  $rrset_cache_size,
  Optional[Integer] $rrset_cache_slabs,
  $service_name,
  Optional[String] $so_rcvbuf, #bytes, 1024, 1k, etc.
  Optional[String] $so_sndbuf, #bytes, 1024, 1k, etc.
  Boolean $statistics_cumulative,
  Optional[Integer] $statistics_interval,
  Boolean $tcp_upstream,
  $trusted_keys_file,
  $unwanted_reply_threshold,
  $use_caps_for_id,
  $val_clean_additional,
  $val_log_level,
  $val_permissive_mode,
  $validate_cmd,
  $verbosity,
  Optional[Integer] $cache_max_ttl,
  Optional[Integer] $cache_max_negative_ttl,
  $custom_server_conf,
  $skip_roothints_download,
) {

  unless $package_name.empty {
    package { $package_name:
      ensure   => installed,
      #provider => $package_provider,
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
      restart   => "${control_path} reload",
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

  if $forward {
    create_resources('unbound::forward', $forward)
  }

  if $stub {
    create_resources('unbound::stub', $stub)
  }

  if $record {
    create_resources('unbound::record', $record)
  }

}
