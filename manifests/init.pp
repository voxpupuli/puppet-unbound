class unbound {
  include unbound::params

  $unbound_confdir = $unbound::unbound_confdir
  $unbound_logdir  = $unbound::unbound_logdir
  $unbound_service = $unbound::service

  package { "unbound":
    ensure   => installed,
    provider => $kernel ? {
      Darwin  => macports,
      default => undef,
    }
  }

  service { "unbound":
    name   => $unbound_service,
    ensure => running,
    enable => true,
  }

  concat::fragment { 'unbound-header':
    order   => '00',
    target  => "$unbound_confdir/unbound.conf",
    content => template("unbound/unbound.conf.erb"),
  }

  concat { "$unbound_confdir/unbound.conf":
    notify => Service["unbound"],
  }

}

