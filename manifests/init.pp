# Class: unbound
#
# Installs and configures Unbound, the caching DNS resolver from NLnet Labs
#
# @param hints_file
#   File path to the root-hints. Set to 'builtin' to remove root-hint option from unbound.conf and use built-in hints.
# @param hints_file_content
#   Contents of the root hints file, if it's not remotely fetched.
# @param unbound_version
#   the version of the installed unbound instance. defaults to the fact, but you can overwrite it. this reduces the initial puppet runs from two to one
class unbound (
  Boolean                                       $manage_service                  = true,
  Integer[0,5]                                  $verbosity                       = 1,
  Optional[Integer]                             $statistics_interval             = undef,
  Boolean                                       $statistics_cumulative           = false,
  Boolean                                       $extended_statistics             = false,
  Integer[1]                                    $num_threads                     = 1,
  Integer[0, 65535]                             $port                            = 53,
  Array[String[1]]                              $interface                       = [],
  Boolean                                       $interface_automatic             = false,
  Array[String[1]]                              $outgoing_interface              = [],  # version 1.5.10
  Optional[Integer[1]]                          $outgoing_range                  = undef,
  Unbound::Range                                $outgoing_port_permit            = '32768-65535',
  Unbound::Range                                $outgoing_port_avoid             = '0-32767',
  Boolean                                       $outgoing_port_permit_first      = true,
  Optional[Integer[0]]                          $outgoing_num_tcp                = undef,
  Optional[Integer[0]]                          $incoming_num_tcp                = undef,
  Integer[0,4096]                               $edns_buffer_size                = 1232,
  Optional[Integer[0,65536]]                    $max_udp_size                    = undef,
  Optional[Unbound::Size]                       $stream_wait_size                = undef,  # version 1.9.0
  Optional[Unbound::Size]                       $msg_cache_size                  = undef,
  Optional[Integer]                             $msg_cache_slabs                 = undef,
  Optional[Integer]                             $num_queries_per_thread          = undef,
  Optional[Integer[1]]                          $jostle_timeout                  = undef,
  Optional[Integer[0]]                          $delay_close                     = undef,
  Optional[Integer[1]]                          $unknown_server_time_limit       = undef,  # version 1.8.2
  Optional[Unbound::Size]                       $so_rcvbuf                       = undef,
  Optional[Unbound::Size]                       $so_sndbuf                       = undef,
  Boolean                                       $so_reuseport                    = false,  # Version 1.4.22
  Boolean                                       $ip_transparent                  = false,  # version 1.5.4
  Boolean                                       $ip_freebind                     = false,  # version 1.5.9
  Optional[Unbound::Size]                       $rrset_cache_size                = undef,
  Optional[Integer]                             $rrset_cache_slabs               = undef,
  Optional[Integer]                             $cache_max_ttl                   = undef,
  Optional[Integer]                             $cache_max_negative_ttl          = undef,
  Optional[Integer]                             $cache_min_ttl                   = undef,
  Optional[Integer]                             $infra_host_ttl                  = undef,
  Optional[Integer]                             $infra_cache_numhosts            = undef,
  Optional[Integer]                             $infra_cache_slabs               = undef,
  Optional[Integer]                             $infra_cache_min_rtt             = undef,
  Array[String[1]]                              $define_tag                      = [],     # version 1.5.10
  Boolean                                       $do_ip4                          = true,
  Boolean                                       $do_ip6                          = true,
  Boolean                                       $prefer_ip6                      = false,  # version 1.5.10
  Boolean                                       $do_udp                          = true,
  Boolean                                       $do_tcp                          = true,
  Optional[Integer[0]]                          $tcp_mss                         = undef,  # version 1.5.8
  Optional[Stdlib::Absolutepath]                $tls_cert_bundle                 = undef,  # version 1.7.0
  Boolean                                       $tls_upstream                    = false,  # version 1.7.0
  Optional[Integer[0]]                          $outgoing_tcp_mss                = undef,  # version 1.5.8
  Optional[Integer[0]]                          $tcp_idle_timeout                = undef,  # version 1.8.0
  Boolean                                       $edns_tcp_keepalive              = false,  # version 1.8.0
  Optional[Integer[0]]                          $edns_tcp_keepalive_timeout      = undef,  # version 1.8.0
  Boolean                                       $tcp_upstream                    = false,
  Boolean                                       $udp_upstream_without_downstream = false,
  Boolean                                       $ssl_upstream                    = false,  # version 1.7.0
  Optional[Stdlib::Absolutepath]                $ssl_service_key                 = undef,  # version 1.7.0
  Optional[Stdlib::Absolutepath]                $ssl_service_pem                 = undef,  # version 1.7.0
  Optional[Integer[0,65535]]                    $ssl_port                        = undef,  # version 1.7.0
  Optional[String[1]]                           $tls_ciphers                     = undef,  # version 1.9.0
  Optional[String[1]]                           $tls_ciphersuites                = undef,  # version 1.9.0
  Boolean                                       $use_systemd                     = false,  # version 1.6.1
  Boolean                                       $do_daemonize                    = true,
  Hash[String[1], Unbound::Access_control]      $access_control                  = {},  # version 1.5.10
  Optional[Unbound::Chroot]                     $chroot                          = undef,
  Optional[Stdlib::Absolutepath]                $logfile                         = undef,
  Optional[String[1]]                           $log_identity                    = undef,  # version 1.6.0
  Boolean                                       $log_time_ascii                  = false,
  Boolean                                       $log_queries                     = false,
  Boolean                                       $log_replies                     = false,  # version 1.6.1
  Boolean                                       $log_tag_queryreply              = false,  # version 1.9.0
  Boolean                                       $log_local_actions               = false,  # version 1.8.0
  Boolean                                       $log_servfail                    = false,  # version 1.8.0
  Stdlib::Absolutepath                          $pidfile                         = '/var/run/unbound/unbound.pid',
  Boolean                                       $hide_identity                   = true,
  Optional[String[1]]                           $identity                        = undef,
  Boolean                                       $hide_version                    = true,
  Optional[String[1]]                           $version                         = undef,
  Boolean                                       $hide_trustanchor                = true,   # version 1.6.2
  Array[Integer]                                $target_fetch_policy             = [],
  Boolean                                       $harden_short_bufsize            = false,
  Boolean                                       $harden_large_queries            = false,
  Boolean                                       $harden_glue                     = true,
  Boolean                                       $harden_dnssec_stripped          = true,
  Boolean                                       $harden_below_nxdomain           = true,
  Boolean                                       $harden_referral_path            = false,
  Boolean                                       $harden_algo_downgrade           = false,  # Version 1.5.3
  Boolean                                       $use_caps_for_id                 = false,
  Array[String[1]]                              $caps_whitlist                   = [],
  Boolean                                       $qname_minimisation              = false,  # version 1.5.7
  Boolean                                       $qname_minimisation_strict       = false,  # version 1.6.0
  Array[String[1]]                              $private_address                 = [],
  Array[String[1]]                              $private_domain                  = [],
  Integer[0]                                    $unwanted_reply_threshold        = 10000000,
  Array[String[1]]                              $do_not_query_address            = [],
  Boolean                                       $do_not_query_localhost          = true,
  Boolean                                       $prefetch                        = false,
  Boolean                                       $prefetch_key                    = false,
  Boolean                                       $deny_any                        = false,  # version 1.8.2
  Boolean                                       $rrset_roundrobin                = false,
  Boolean                                       $minimal_responses               = false,
  Boolean                                       $disable_dnssec_lame_check       = false,  # version 1.5.9
  Optional[Stdlib::Absolutepath]                $trust_anchor_file               = undef,
  Array[String[1]]                              $trust_anchor                    = [],
  Boolean                                       $trust_anchor_signaling          = true,  # version 1.6.4
  Array[String[1]]                              $domain_insecure                 = [],
  Optional[Integer[1]]                          $val_sig_skew_min                = undef,
  Optional[Integer[1]]                          $val_sig_skew_max                = undef,
  Optional[Integer[1]]                          $val_bogus_ttl                   = undef,
  Boolean                                       $val_clean_additional            = true,
  Optional[Integer[0,2]]                        $val_log_level                   = undef,
  Boolean                                       $val_permissive_mode             = false,
  Boolean                                       $ignore_cd_flag                  = false,
  Boolean                                       $serve_expired                   = false,  # version 1.6.0
  Optional[Integer[0]]                          $serve_expired_ttl               = undef,  # version 1.8.0
  Boolean                                       $serve_expired_ttl_reset         = false,  # version 1.8.0
  Optional[Integer[0]]                          $serve_expired_reply_ttl         = undef,  # version 1.8.0
  Optional[Integer[0]]                          $serve_expired_client_timeout    = undef,  # version 1.8.0
  Array[Integer[1]]                             $val_nsec3_keysize_iterations    = [],
  Optional[Integer[0]]                          $add_holddown                    = undef,
  Optional[Integer[0]]                          $del_holddown                    = undef,
  Optional[Integer[0]]                          $keep_missing                    = undef,
  Boolean                                       $permit_small_holddown           = false,  # Version 1.5.5
  Optional[Unbound::Size]                       $key_cache_size                  = undef,
  Optional[Integer]                             $key_cache_slabs                 = undef,
  Optional[Unbound::Size]                       $neg_cache_size                  = undef,
  Boolean                                       $unblock_lan_zones               = false,
  Boolean                                       $insecure_lan_zones              = false,  # version 1.5.8 
  Unbound::Local_zone                           $local_zone                      = {},
  Array[String[1]]                              $local_data                      = [],
  Array[String[1]]                              $local_data_ptr                  = [],
  Hash[String[1], Array[String[1]]]             $local_zone_tag                  = {},     # version 1.5.10
  Hash[String[1], Unbound::Local_zone_override] $local_zone_override             = {},     # version 1.5.10
  Optional[Integer[0]]                          $ratelimit                       = undef,
  Optional[Unbound::Size]                       $ratelimit_size                  = undef,
  Optional[Integer[0]]                          $ratelimit_slabs                 = undef,
  Optional[Integer[0]]                          $ratelimit_factor                = undef,
  Hash[String[1], Integer[0]]                   $ratelimit_for_domain            = {},
  Hash[String[1], Integer[0]]                   $ratelimit_below_domain          = {},
  Optional[Integer[0]]                          $ip_ratelimit                    = undef,  # version 1.6.1
  Optional[Unbound::Size]                       $ip_ratelimit_size               = undef,  # version 1.6.1
  Optional[Integer[0]]                          $ip_ratelimit_slabs              = undef,  # version 1.6.1
  Optional[Integer[0]]                          $ip_ratelimit_factor             = undef,
  Optional[Integer[0,1000]]                     $fast_server_permil              = undef,  # version 1.8.2
  Optional[Integer[1]]                          $fast_server_num                 = undef,  # version 1.8.2
  Hash                                          $forward                         = {},
  Hash                                          $stub                            = {},
  Hash                                          $record                          = {},
  Array                                         $access                          = ['::1', '127.0.0.1'],
  String[1]                                     $confdir                         = '/etc/unbound',
  Stdlib::Absolutepath                          $directory                       = $confdir,
  String[1]                                     $conf_d                          = "${confdir}/conf.d",
  String[1]                                     $config_file                     = "${confdir}/unbound.conf",
  Boolean                                       $control_enable                  = false,
  String[1]                                     $control_setup_path              = '/usr/sbin/unbound-control-setup',
  String[1]                                     $control_path                    = '/usr/sbin/unbound-control',
  String[1]                                     $fetch_client                    = 'wget -O',
  String[1]                                     $group                           = 'unbound',
  String[1]                                     $keys_d                          = "${confdir}/keys.d",
  Stdlib::Absolutepath                          $trusted_keys_file               = "${keys_d}/*.key",
  Array[Unbound::Module]                        $module_config                   = [],
  String[1]                                     $owner                           = 'unbound',
  String[1]                                     $username                        = $owner,
  # OpenBSD sets this to an empty string
  String                                        $package_name                    = 'unbound',
  String[1]                                     $package_ensure                  = 'installed',
  Boolean                                       $purge_unbound_conf_d            = false,
  String[1]                                     $root_hints_url                  = 'https://www.internic.net/domain/named.root',
  Stdlib::Absolutepath                          $runtime_dir                     = $confdir,
  Stdlib::Absolutepath                          $auto_trust_anchor_file          = "${runtime_dir}/root.key",
  String[1]                                     $anchor_fetch_command            = "unbound-anchor -a ${auto_trust_anchor_file}",
  String[1]                                     $service_name                    = 'unbound',
  Boolean                                       $service_hasstatus               = true,
  Enum['running', 'stopped']                    $service_ensure                  = 'running',
  Boolean                                       $service_enable                  = true,
  String[1]                                     $validate_cmd                    = '/usr/sbin/unbound-checkconf %',
  String[1]                                     $restart_cmd                     = "/bin/systemctl restart ${service_name}",
  Array[String[1]]                              $custom_server_conf              = [],
  Boolean                                       $skip_roothints_download         = false,
  Optional[Stdlib::Absolutepath]                $python_script                   = undef,
  String[1]                                     $dns64_prefix                    = '64:ff9b::/96',
  Boolean                                       $dns64_synthall                  = false,
  Array[String[1]]                              $send_client_subnet              = [],
  Array[String[1]]                              $client_subnet_zone              = [],
  Boolean                                       $client_subnet_always_forward    = false,
  Integer[0,128]                                $max_client_subnet_ipv6          = 56,
  Integer[0,32]                                 $max_client_subnet_ipv4          = 24,
  Optional[Integer[0,128]]                      $min_client_subnet_ipv6          = undef,  # version 1.8.2
  Optional[Integer[0,32]]                       $min_client_subnet_ipv4          = undef,  # version 1.8.2
  Optional[Integer[0]]                          $max_ecs_tree_size_ipv4          = undef,  # version 1.8.2
  Optional[Integer[0]]                          $max_ecs_tree_size_ipv6          = undef,  # version 1.8.2
  Boolean                                       $ipsecmod_enabled                = true,
  Optional[Stdlib::Absolutepath]                $ipsecmod_hook                   = undef,
  Boolean                                       $ipsecmod_strict                 = false,
  Integer[1]                                    $ipsecmod_max_ttl                = 3600,
  Boolean                                       $ipsecmod_ignore_bogus           = false,
  Array[String[1]]                              $ipsecmod_whitelist              = [],
  Optional[String[1]]                           $backend                         = undef,
  String[1]                                     $secret_seed                     = 'default',
  String[1]                                     $redis_server_host               = '127.0.0.1',
  Integer[1,65536]                              $redis_server_port               = 6379,
  Integer[1]                                    $redis_timeout                   = 100,
  Stdlib::Absolutepath                          $unbound_conf_d                  = "${confdir}/unbound.conf.d",
  Unbound::Hints_file                           $hints_file                      = "${confdir}/root.hints",
  Optional[String[1]]                           $hints_file_content              = undef,
  Hash[String[1], Unbound::Rpz]                 $rpzs                            = {},
  Optional[String[1]]                           $unbound_version                 = $facts['unbound_version'],
) {
  $_base_dirs = [$confdir, $conf_d, $keys_d, $runtime_dir]
  $_piddir = if $pidfile { dirname($pidfile) } else { undef }
  if $_piddir and !($_piddir in ['/run', '/var/run']) {
    $dirs = unique($_base_dirs + [$_piddir])
    $_owned_dirs = unique([$runtime_dir, $_piddir])
  } else {
    $dirs = unique($_base_dirs)
    $_owned_dirs = [$runtime_dir]
  }

  if $manage_service {
    service { $service_name:
      ensure    => $service_ensure,
      name      => $service_name,
      enable    => $service_enable,
      hasstatus => $service_hasstatus,
    }
    $service_reuse = Service[$service_name]
  } else {
    $service_reuse = undef
  }

  # OpenBSD passes an empty string
  unless $package_name.empty {
    if $manage_service {
      $before_package = [File[$dirs], Concat[$config_file], Service[$service_name]]
    } else {
      $before_package = [File[$dirs], Concat[$config_file]]
    }
    package { $package_name:
      ensure => $package_ensure,
      before => $before_package,
    }
  }
  $dirs.each |$dir| {
    $_owner = $dir in $_owned_dirs ? {
      true    => $owner,
      default => undef,
    }
    file { $dir:
      ensure => directory,
      owner  => $_owner,
    }
  }

  if $control_enable {
    file { "${confdir}/interfaces.txt":
      ensure  => file,
      notify  => Exec['restart unbound'],
      content => template('unbound/interfaces.txt.erb'),
    }
    exec { 'restart unbound':
      command     => $restart_cmd,
      refreshonly => true,
      require     => $service_reuse,
    }
    if $manage_service {
      Service[$service_name] {
        restart   => "${control_path} reload",
        require   => Class['unbound::remote'],
      }
    }
    include unbound::remote

    unless $package_name.empty {
      Package[$package_name] -> Class['unbound::remote']
    }
  }

  exec { 'download-anchor-file':
    command => $anchor_fetch_command,
    creates => $auto_trust_anchor_file,
    user    => $owner,
    path    => ['/usr/sbin','/usr/local/sbin'],
    returns => 1,
    before  => Concat::Fragment['unbound-header'],
    require => File[$runtime_dir],
  }

  # If hint_file is 'builtin', Unbound should use built-in hints instead of file
  if $hints_file != 'builtin' {
    # Remotely fetch root hints unless hint-files content is set or is explicitlly skipped
    unless $hints_file_content or $skip_roothints_download {
      exec { 'download-roothints':
        command => "${fetch_client} ${hints_file} ${root_hints_url}",
        creates => $hints_file,
        path    => ['/usr/bin','/usr/local/bin'],
        before  => [Concat::Fragment['unbound-header'], File[$hints_file]],
        require => File[$dirs],
      }
      unless $package_name.empty {
        Package[$package_name] -> Exec['download-roothints']
      }
    }

    file { $hints_file:
      ensure  => file,
      mode    => '0444',
      content => $hints_file_content,
    }
  }

  # purge unmanaged files in configuration directory
  file { $unbound_conf_d:
    ensure  => 'directory',
    owner   => 'root',
    group   => '0',
    purge   => $purge_unbound_conf_d,
    recurse => $purge_unbound_conf_d,
  }

  concat { $config_file:
    validate_cmd => $validate_cmd,
    require      => Exec['download-anchor-file'],
    notify       => $service_reuse,
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

  $forward.each |$title, $config| {
    unbound::forward { $title:
      * => $config,
    }
  }

  $stub.each |$title, $config| {
    unbound::stub { $title:
      * => $config,
    }
  }

  $record.each |$title, $config| {
    unbound::record { $title:
      * => $config,
    }
  }
}
