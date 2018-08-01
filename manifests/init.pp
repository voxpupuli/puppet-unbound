# Class: unbound
#
# Installs and configures Unbound, the caching DNS resolver from NLnet Labs
#
class unbound (
  Integer[0,5]                                         $verbosity,
  Optional[Integer]                                    $statistics_interval,
  Boolean                                              $statistics_cumulative,
  Boolean                                              $extended_statistics,
  Integer[1]                                           $num_threads,
  Integer[0, 65535]                                    $port,
  Optional[Array[String]]                              $interface,
  Boolean                                              $interface_automatic,
  Optional[Array[String]]                              $outgoing_interface,           # version 1.5.10
  Optional[Integer[1]]                                 $outgoing_range,
  Unbound::Range                                       $outgoing_port_permit,
  Unbound::Range                                       $outgoing_port_avoid,
  Boolean                                              $outgoing_port_permit_first,
  Optional[Integer[0]]                                 $outgoing_num_tcp,
  Optional[Integer[0]]                                 $incoming_num_tcp,
  Integer[0,4096]                                      $edns_buffer_size,
  Optional[Integer[0,65536]]                           $max_udp_size,
  Optional[Unbound::Size]                              $msg_cache_size,
  Optional[Integer]                                    $msg_cache_slabs,
  Optional[Integer]                                    $num_queries_per_thread,
  Optional[Integer[1]]                                 $jostle_timeout,
  Optional[Integer[0]]                                 $delay_close,
  Optional[Unbound::Size]                              $so_rcvbuf,
  Optional[Unbound::Size]                              $so_sndbuf,
  Boolean                                              $so_reuseport,                 # Version 1.4.22
  Boolean                                              $ip_transparent,               # version 1.5.4
  Boolean                                              $ip_freebind,                  # version 1.5.9
  Optional[Unbound::Size]                              $rrset_cache_size,
  Optional[Integer]                                    $rrset_cache_slabs,
  Optional[Integer]                                    $cache_max_ttl,
  Optional[Integer]                                    $cache_max_negative_ttl,
  Optional[Integer]                                    $cache_min_ttl,
  Optional[Integer]                                    $infra_host_ttl,
  Optional[Integer]                                    $infra_cache_numhosts,
  Optional[Integer]                                    $infra_cache_slabs,
  Optional[Integer]                                    $infra_cache_min_rtt,
  Optional[Array[String]]                              $define_tag,                   # version 1.5.10
  Boolean                                              $do_ip4,
  Boolean                                              $do_ip6,
  Boolean                                              $prefer_ip6,                   # version 1.5.10
  Boolean                                              $do_udp,
  Boolean                                              $do_tcp,
  Optional[Integer[0]]                                 $tcp_mss,                      # version 1.5.8
  Optional[Integer[0]]                                 $outgoing_tcp_mss,             # version 1.5.8
  Boolean                                              $tcp_upstream,
  Boolean                                              $udp_upstream_without_downstream,
  Boolean                                              $ssl_upstream,
  Optional[Stdlib::Absolutepath]                       $ssl_service_key,
  Optional[Stdlib::Absolutepath]                       $ssl_service_pem,
  Optional[Integer[0,65535]]                           $ssl_port,
  Boolean                                              $use_systemd,                  # version 1.6.1
  Boolean                                              $do_daemonize,
  Optional[Hash[String, Unbound::Access_control]]      $access_control,               # version 1.5.10
  Optional[Variant[Enum[''],Stdlib::Absolutepath]]     $chroot,
  Optional[String]                                     $username,
  Stdlib::Absolutepath                                 $directory,
  Optional[Stdlib::Absolutepath]                       $logfile,
  Optional[String]                                     $log_identity,                 # version 1.6.0 
  Boolean                                              $log_time_ascii,
  Boolean                                              $log_queries,
  Boolean                                              $log_replies,                  # version 1.6.1
  Optional[Stdlib::Absolutepath]                       $pidfile,
  Stdlib::Absolutepath                                 $hints_file,
  Boolean                                              $hide_identity,
  Optional[String]                                     $identity,
  Boolean                                              $hide_version,
  Optional[String]                                     $version,
  Boolean                                              $hide_trustanchor,             # version 1.6.2
  Optional[Array[Integer]]                             $target_fetch_policy,
  Boolean                                              $harden_short_bufsize,
  Boolean                                              $harden_large_queries,
  Boolean                                              $harden_glue,
  Boolean                                              $harden_dnssec_stripped,
  Boolean                                              $harden_below_nxdomain,
  Boolean                                              $harden_referral_path,
  Boolean                                              $harden_algo_downgrade,        # Version 1.5.3
  Boolean                                              $use_caps_for_id,
  Optional[Array[String]]                              $caps_whitlist,
  Boolean                                              $qname_minimisation,           # version 1.5.7
  Boolean                                              $qname_minimisation_strict,    # version 1.6.0
  Optional[Array[String]]                              $private_address,
  Optional[Array[String]]                              $private_domain,
  Integer[0]                                           $unwanted_reply_threshold,
  Optional[Array[String]]                              $do_not_query_address,
  Boolean                                              $do_not_query_localhost,
  Boolean                                              $prefetch,
  Boolean                                              $prefetch_key,
  Boolean                                              $rrset_roundrobin,
  Boolean                                              $minimal_responses,
  Boolean                                              $disable_dnssec_lame_check,    # version 1.5.9
  Optional[Stdlib::Absolutepath]                       $trust_anchor_file,
  Stdlib::Absolutepath                                 $auto_trust_anchor_file,
  Optional[Array[String]]                              $trust_anchor,
  Stdlib::Absolutepath                                 $trusted_keys_file,
  Boolean                                              $trust_anchor_signaling,       # version 1.6.4
  Optional[Array[String]]                              $domain_insecure,
  Optional[Integer[1]]                                 $val_sig_skew_min,
  Optional[Integer[1]]                                 $val_sig_skew_max,
  Optional[Integer[1]]                                 $val_bogus_ttl,
  Boolean                                              $val_clean_additional,
  Optional[Integer[0,2]]                               $val_log_level,
  Boolean                                              $val_permissive_mode,
  Boolean                                              $ignore_cd_flag,
  Boolean                                              $serve_expired,                # version 1.6.0
  Optional[Array[Integer[1]]]                          $val_nsec3_keysize_iterations,
  Optional[Integer[0]]                                 $add_holddown,
  Optional[Integer[0]]                                 $del_holddown,
  Optional[Integer[0]]                                 $keep_missing,
  Boolean                                              $permit_small_holddown,         # Version 1.5.5
  Optional[Unbound::Size]                              $key_cache_size,
  Optional[Integer]                                    $key_cache_slabs,
  Optional[Unbound::Size]                              $neg_cache_size,
  Boolean                                              $unblock_lan_zones,
  Boolean                                              $insecure_lan_zones,            # version 1.5.8 
  Optional[Unbound::Local_zone]                        $local_zone,
  Optional[Array[String]]                              $local_data,
  Optional[Array[String]]                              $local_data_ptr,
  Optional[Hash[String, Array[String]]]                $local_zone_tag,               # version 1.5.10
  Optional[Hash[String, Unbound::Local_zone_override]] $local_zone_override,          # version 1.5.10
  Optional[Integer[0]]                                 $ratelimit,
  Optional[Unbound::Size]                              $ratelimit_size,
  Optional[Integer[0]]                                 $ratelimit_slabs,
  Optional[Integer[0]]                                 $ratelimit_factor,
  Optional[Hash[String,Integer[0]]]                    $ratelimit_for_domain,
  Optional[Hash[String,Integer[0]]]                    $ratelimit_below_domain,
  Optional[Integer[0]]                                 $ip_ratelimit,                 # version 1.6.1
  Optional[Unbound::Size]                              $ip_ratelimit_size,            # version 1.6.1
  Optional[Integer[0]]                                 $ip_ratelimit_slabs,           # version 1.6.1
  Optional[Integer[0]]                                 $ip_ratelimit_factor,
  Hash                                                 $forward,
  Hash                                                 $stub,
  Hash                                                 $record,
  Array                                                $access,
  String                                               $anchor_fetch_command,
  String                                               $conf_d,
  String                                               $confdir,
  String                                               $config_file,
  Boolean                                              $control_enable,
  String                                               $control_setup_path,
  String                                               $control_path,
  String                                               $fetch_client,
  String                                               $group,
  String                                               $keys_d,
  Optional[Array[Unbound::Module]]                     $module_config,
  String                                               $owner,
  String                                               $package_name,
  Optional[String]                                     $package_provider,
  String                                               $root_hints_url,
  Stdlib::Absolutepath                                 $runtime_dir,
  String                                               $service_name,
  Boolean                                              $service_hasstatus,
  String                                               $validate_cmd,
  String                                               $restart_cmd,
  Array[String]                                        $custom_server_conf,
  Boolean                                              $skip_roothints_download,
  Optional[Stdlib::Absolutepath]                       $python_script,
  Optional[String]                                     $dns64_prefix,
  Boolean                                              $dns64_synthall,
  Optional[Array[String]]                              $send_client_subnet,
  Optional[Array[String]]                              $client_subnet_zone,
  Boolean                                              $client_subnet_always_forward,
  Integer[0,128]                                       $max_client_subnet_ipv6,
  Integer[0,32]                                        $max_client_subnet_ipv4,
  Boolean                                              $ipsecmod_enabled,
  Optional[Stdlib::Absolutepath]                       $ipsecmod_hook,
  Boolean                                              $ipsecmod_strict,
  Integer[1]                                           $ipsecmod_max_ttl,
  Boolean                                              $ipsecmod_ignore_bogus,
  Optional[Array[String]]                              $ipsecmod_whitelist,
  Optional[String]                                     $backend,
  String                                               $secret_seed,
  String                                               $redis_server_host,
  Integer[1,65536]                                     $redis_server_port,
  Integer[1]                                           $redis_timeout,
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
  $dirs = $pidfile ? {
    undef => unique([$confdir, $conf_d, $keys_d, $runtime_dir]),
    default => unique([$confdir, $conf_d, $keys_d, $runtime_dir, dirname($pidfile)]),
  }
  ensure_resource('file', $dirs, {ensure => directory})
  if $pidfile {
    File[unique([$runtime_dir, dirname($pidfile)])] {
      owner => $owner,
    }
  } else {
    File[$runtime_dir] {
      owner => $owner,
    }
  }

  service { $service_name:
    ensure    => running,
    name      => $service_name,
    enable    => true,
    hasstatus => $service_hasstatus,
  }

  if $control_enable {
    file {"${confdir}/interfaces.txt":
      ensure  => file,
      notify  => Exec[$restart_cmd],
      content => template('unbound/interfaces.txt.erb'),
    }
    exec {$restart_cmd:
      refreshonly => true,
    }
    Service[$service_name] {
      restart   => "${control_path} reload",
      require   => Class['unbound::remote'],
    }
    Package<| title == $package_name |> -> Class['unbound::remote']
    include ::unbound::remote
  }

  if $skip_roothints_download {
    File[$hints_file] -> Exec['download-roothints']
  } else {
    Exec['download-roothints'] -> File[$hints_file]
  }

  exec { 'download-roothints':
    command => "${fetch_client} ${hints_file} ${root_hints_url}",
    creates => $hints_file,
    path    => ['/usr/bin','/usr/local/bin'],
    before  => [ Concat::Fragment['unbound-header'] ],
    require => File[$dirs],
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
    require      => Exec['download-anchor-file'],
  }

  concat::fragment { 'unbound-header':
    order   => '00',
    target  => $config_file,
    content => template('unbound/unbound.conf.erb'),
  }
  concat::fragment { 'unbound-modules':
    order   => '09',
    target  => $config_file,
    content => template('unbound/unbound.modules.conf.erb'),
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
