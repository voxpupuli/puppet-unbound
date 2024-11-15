# @summary Create an unbound static DNS record override
# @param content The name of the record (ip address)
# @param ttl The time to live for this record, defaults to '14400'
# @param type Type or the record
# @param reverse Reverse record or not, defaults to false
# @param entry Name entry for the record (name)
# @param config_file name of configuration file
#
define unbound::record (
  Variant[Array[String[1]], String[1]] $content,
  $ttl         = '14400',
  $type        = 'A',
  $reverse     = false,
  $entry       = $name,
  $config_file = $unbound::config_file,
) {
  $local_data = [$content].flatten.map |$_content| {
    if $type != 'TXT' {
      "  local-data: \"${entry} ${ttl} IN ${type} ${_content}\""
    } else {
      # Long TXT records must be broken into strings of 255 characters as per RFC 4408
      $real_content = $_content.slice(255)
      .reduce('') |String $record, Array $s| {
        "${record}\"${s.join()}\""
      }
      "  local-data: '${entry} ${ttl} IN ${type} ${real_content}'"
    }
  }.join("\n")
  $local_data_ptr = "  local-data-ptr: \"${content} ${entry}\""

  $config = $reverse ? {
    true    => "${local_data}\n${local_data_ptr}\n",
    default => "${local_data}\n",
  }

  concat::fragment { "unbound-stub-${title}-local-record":
    order   => '07',
    target  => $config_file,
    content => $config,
  }
}
