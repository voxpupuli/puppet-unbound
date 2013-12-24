# Class: unbound::record
#
# Create an unbound static DNS record override
#
define unbound::record (
  $content,
  $ttl     = '14400',
  $type    = 'A',
  $reverse = false
) {

  include unbound::params

  $config_file = $unbound::params::config_file

  $local_data     = "  local-data: \"${name} ${ttl} IN ${type} ${content}\"\n"
  $local_data_ptr = "  local-data-ptr: \"${content} ${name}\"\n"

  $entry = $reverse? {
    true    => "${local_data}${local_data_ptr}",
    default => $local_data,
  }

  concat::fragment { "unbound-stub-${name}-local-record":
    order   => '02',
    target  => $config_file,
    content => $entry,
  }
}
