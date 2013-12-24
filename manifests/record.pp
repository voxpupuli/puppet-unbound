# Class: unbound::record
#
# Create an unbound static DNS record override
#
define unbound::record (
  $content,
  $ttl  = '14400',
  $type = 'A'
) {

  include unbound::params

  $config_file = $unbound::params::config_file

  concat::fragment { "unbound-stub-${name}-local-record":
    order   => '02',
    target  => $config_file,
    content => "  local-data: \"${name} ${ttl} IN ${type} ${content}\"\n",
  }
}
