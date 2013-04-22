# Create an unbound static dns record to override upstreams
define unbound::record (
  $ttl = 14400,
  $type = A,
  $content
) {
  include unbound::params

  $unbound_confdir = $unbound::params::unbound_confdir

  concat::fragment { "unbound-stub-${name}-local-record":
    order   => '02',
    target  => "${unbound_confdir}/unbound.conf",
    content => "  local-data: \"${name} ${ttl} IN ${type} ${content}\"\n",
  }

}
