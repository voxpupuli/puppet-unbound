# Class: unbound::stub
#
# Create an unbound stub zone for caching upstream name resolvers
#
define unbound::stub (
  $address,
  $insecure = false
) {

  $config_file = $unbound::config_file

  concat::fragment { "unbound-stub-${name}":
    order   => '15',
    target  => $config_file,
    content => template('unbound/stub.erb'),
  }

  if str2bool($insecure) == true {
    concat::fragment { "unbound-stub-${name}-insecure":
      order   => '01',
      target  => $config_file,
      content => "  domain-insecure: \"${name}\"\n",
    }
  }

  concat::fragment { "unbound-stub-${name}-local-zone":
    order   => '02',
    target  => $config_file,
    content => "  local-zone: \"${name}\" transparent \n",
  }
}
