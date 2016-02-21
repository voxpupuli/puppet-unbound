# Class: unbound::record
#
# Create an unbound static DNS record override
#
define unbound::record (
  $content,
  $ttl         = '14400',
  $type        = 'A',
  $reverse     = false,
  $entry       = $name,
  $config_file = $unbound::params::config_file,
) {

  include ::unbound::params

  $local_data     = "  local-data: \"${entry} ${ttl} IN ${type} ${content}\"\n"
  $local_data_ptr = "  local-data-ptr: \"${content} ${entry}\"\n"

  $config = $reverse? {
    true    => "${local_data}${local_data_ptr}",
    default => $local_data,
  }

  concat::fragment { "unbound-stub-${title}-local-record":
    order   => '07',
    target  => $config_file,
    content => $config,
  }
}
