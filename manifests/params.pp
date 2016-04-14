# Class: unbound::params
#
# Set some params for the unbound module
#
class unbound::params {

  case $::operatingsystem {
    'ubuntu', 'debian': {
      $confdir          = '/etc/unbound'
      $logdir           = '/var/log'
      $service_name     = 'unbound'
      $package_name     = 'unbound'
      $package_provider = undef
      $runtime_dir      = '/var/lib/unbound'
      $owner            = 'unbound'
      $group            = 'unbound'
      $pidfile          = undef
      $fetch_client     = 'wget -O'
      $validate_cmd      = undef
    }
    'redhat', 'centos', 'scientific': {
      $confdir          = '/etc/unbound'
      $logdir           = '/var/log'
      $service_name     = 'unbound'
      $package_name     = 'unbound'
      $package_provider = undef
      $runtime_dir      = '/var/lib/unbound'
      $owner            = 'unbound'
      $group            = 'unbound'
      $pidfile          = undef
      $fetch_client     = 'curl -o'
      $validate_cmd     = '/usr/sbin/unbound-checkconf %'
    }
    'darwin': {
      $confdir          = '/opt/local/etc/unbound'
      $logdir           = '/opt/local/var/log/unbound'
      $service_name     = 'org.macports.unbound'
      $package_name     = 'unbound'
      $package_provider = 'macports'
      $runtime_dir      = $confdir
      $owner            = 'unbound'
      $group            = 'unbound'
      $pidfile          = undef
      $fetch_client     = 'curl -o'
      $validate_cmd      = undef
    }
    'freebsd': {
      $confdir          = '/var/unbound'
      $service_name     = 'local_unbound'
      $package_name     = undef
      $pidfile          = '/var/run/local_unbound.pid'
      $logdir           = '/var/log/unbound'
      $package_provider = undef
      $runtime_dir      = $confdir
      $owner            = 'unbound'
      $group            = 'unbound'
      $fetch_client     = 'fetch -o'
      $validate_cmd     = undef
    }
    'openbsd': {
      $confdir          = '/var/unbound/etc'
      $logdir           = '/var/log/unbound'
      $service_name     = 'unbound'
      $package_name     = undef
      $package_provider = undef
      $runtime_dir      = $confdir
      $owner            = '_unbound'
      $group            = '_unbound'
      $pidfile          = undef
      $fetch_client     = 'ftp -o'
      $validate_cmd      = '/usr/sbin/unbound-checkconf %'
    }
    'sles', 'opensuse', 'suse': {
      $confdir          = '/etc/unbound'
      $logdir           = '/var/log'
      $service_name     = 'unbound'
      $package_name     = 'unbound'
      $package_provider = undef
      $runtime_dir      = '/var/lib/unbound'
      $owner            = 'unbound'
      $group            = 'unbound'
      $pidfile          = '/var/run/unbound/unbound.pid'
      $fetch_client     = 'wget -O'
      $validate_cmd      = undef
    }
    default: {
      $confdir          = '/etc/unbound'
      $logdir           = '/var/log'
      $service_name     = 'unbound'
      $package_name     = 'unbound'
      $package_provider = undef
      $runtime_dir      = $confdir
      $owner            = 'unbound'
      $group            = 'unbound'
      $pidfile          = undef
      $fetch_client     = 'wget -O'
      $validate_cmd      = undef
    }
  }

  $access                     = ['::1','127.0.0.1/8']
  $auto_trust_anchor_file     = "${runtime_dir}/root.key"
  $anchor_fetch_command       = "unbound-anchor -a ${auto_trust_anchor_file}"
  $chroot                     = undef
  $conf_d                     = "${confdir}/conf.d"
  $config_file                = "${confdir}/unbound.conf"
  $control_enable             = false
  $control_setup_path         = '/usr/sbin/unbound-control-setup'
  $directory                  = $confdir
  $dlv_anchor_file            = undef
  $do_ip4                     = true
  $do_ip6                     = true
  $edns_buffer_size           = 1280
  $extended_statistics        = false
  $harden_below_nxdomain      = true
  $harden_dnssec_stripped     = true
  $harden_glue                = true
  $harden_referral_path       = true
  $hide_identity              = true
  $hide_version               = true
  $hints_file                 = "${confdir}/root.hints"
  $infra_cache_slabs          = undef
  $infra_host_ttl             = undef
  $interface                  = ['::0','0.0.0.0']
  $interface_automatic        = false
  $key_cache_size             = undef
  $key_cache_slabs            = undef
  $keys_d                     = "${confdir}/keys.d"
  $log_time_ascii             = true
  $module_config              = undef
  $msg_cache_size             = undef
  $msg_cache_slabs            = undef
  $num_queries_per_thread     = undef
  $num_threads                = 1
  $outgoing_interface         = undef
  $outgoing_port_avoid        = '0-32767'
  $outgoing_port_permit       = '32768-65535'
  $outgoing_range             = undef
  $port                       = 53
  $prefetch                   = false
  $prefetch_key               = false
  $private_domain             = undef
  $root_hints_url             = 'https://www.internic.net/domain/named.root'
  $rrset_cache_size           = undef
  $rrset_cache_slabs          = undef
  $so_rcvbuf                  = undef
  $so_sndbuf                  = undef
  $statistics_cumulative      = false
  $statistics_interval        = 0
  $tcp_upstream               = false
  $trusted_keys_file          = "${keys_d}/*.key"
  $unwanted_reply_threshold   = 10000000
  $use_caps_for_id            = false
  $val_clean_additional       = true
  $val_log_level              = 1
  $val_permissive_mode        = false
  $verbosity                  = 1
  $custom_server_conf         = []
  $skip_roothints_download    = false
}
