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
        $anchor_file  = "${confdir}/root.key"
        $owner        = 'unbound'
        $group        = 'unbound'
    }
    'redhat', 'centos', 'scientific': {
        $confdir      = '/etc/unbound'
        $logdir       = '/var/log'
        $service_name = 'unbound'
        $package_name = 'unbound'
        $anchor_file  = "${confdir}/root.anchor"
        $owner        = 'unbound'
        $group        = 'unbound'
      }
    'darwin': {
        $confdir          = '/opt/local/etc/unbound'
        $logdir           = '/opt/local/var/log/unbound'
        $service_name     = 'org.macports.unbound'
        $package_name     = 'unbound'
        $package_provider = 'macports'
        $anchor_file      = "{confdir}/root.key"
        $owner            = 'unbound'
        $group            = 'unbound'
    }
    'freebsd': {
        $confdir      = '/usr/local/etc/unbound'
        $logdir       = '/var/log/unbound'
        $service_name = 'unbound'
        $package_name = 'dns/unbound'
        $anchor_file  = "${confdir}/root.key"
        $owner        = 'unbound'
        $group        = 'root'
    }
    'openbsd': {
        $confdir      = '/var/unbound/etc'
        $logdir       = '/var/log/unbound'
        $service_name = 'unbound'
        $package_name = 'unbound'
        $anchor_file  = "${confdir}/root.key"
        $owner        = '_unbound'
        $group        = 'root'
    }
    'sles', 'opensuse', 'suse': {
        $confdir        = '/etc/unbound'
        $logdir         = '/var/log'
        $service_name   = 'unbound'
        $package_name   = 'unbound'
        $anchor_file    = "/var/lib/unbound/root.key"
        $owner          = 'unbound'
        $group          = 'unbound'
        $pidfile        = '/var/run/unbound/unbound.pid'
    }
  }

    $access                     = ['::1','127.0.0.1/8']
    $chroot                     = undef
    $conf_d                     = "${confdir}/conf.d"
    $config_file                = "${confdir}/unbound.conf"
    $control_enable             = false
    $directory                  = "${confdir}"
    $dlv_anchor_file            = undef
    $do_ip4                     = true
    $do_ip6                     = true
    $extended_statistics        = no
    $harden_below_nxdomain      = true
    $harden_dnssec_stripped     = true
    $harden_glue                = true
    $harden_referral_path       = true
    $hints_file                 = "${confdir}/root.hints"
    $infra_cache_slabs          = undef
    $infra_host_ttl             = undef
    $interface                  = ['::0','0.0.0.0']
    $interface_automatic        = false
    $key_cache_size             = undef
    $key_cache_slabs            = undef
    $keys_d                     = "${confdir}/keys.d"
    $local_d                    = "${confdir}/local.d"
    $log_time_ascii             = true
    $manage_firewall            = false
    $manage_remote_firewall     = false
    $max_udp_size               = 3072
    $minimal_responses          = true
    $module_config              = undef
    $msg_cache_size             = undef
    $msg_cache_slabs            = undef
    $num_queries_per_thread     = undef
    $num_threads                = 1
    $outgoing_interface         = undef
    $outgoing_port_avoid        = "0-32767"
    $outgoing_port_permit       = "32768-65535"
    $outgoing_range             = undef
    $port                       = 53
    $prefetch                   = false
    $prefetch_key               = false
    $private_domain             = undef
    $root_hints_url             = 'http://www.internic.net/domain/named.root'
    $rrset_cache_size           = undef
    $rrset_cache_slabs          = undef
    $rrset_roundrobin           = true
    $so_rcvbuf                  = undef
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
}
