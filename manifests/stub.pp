define unbound::stub (
  $address,
  $insecure = false
) {
  include unbound::params

  $unbound_confdir = $unbound::params::unbound_confdir

  concat::fragment { "unbound-stub-$name":
    order   => '05',
    target  => "$unbound_confdir/unbound.conf",
    content => template("unbound/stub.erb"),
  }

  if $insecure == true {
    concat::fragment { "unbound-stub-${name}-insecure":
      order   => '01',
      target  => "$unbound_confdir/unbound.conf",
      content => "  domain-insecure: \"${name}\"\n",
    }
  }

  concat::fragment { "unbound-stub-${name}-local-zone":
    order   => '02',
    target  => "$unbound_confdir/unbound.conf",
    content => "  local-zone: \"${name}\" transparent \n",
  }

}
