# @summary Configures a local zone.
# The  default  zones  are  localhost, reverse 127.0.0.1 and ::1, and the
# AS112 zones. The AS112 zones are reverse DNS zones for private use  and
# reserved IP addresses for which the servers on the internet cannot pro-
# vide correct answers.
#
# === Parameters:
#
# @param zone String. Zone name.
# @param type Custom type Unbound::Local_zone_type.
# @param config_file name of configuration file.
# @param local_data
#   Define local data which should be rendered into configuration file. Required
#   value is an Array of the custom type Unbond::Resource_record_type.
#   Default value: [].
#   Example:
#     unbound::localzone::local_data:
#       - name: 'api.test.com'
#         ttl: 15
#         class: IN
#         type: A
#         data: '1.1.1.1'
#       - name: 'backend.test.com'
#         type: A
#         data: '2.2.2.2'
# @param template_name Use a custom template.
#
define unbound::localzone (
  Unbound::Local_zone_type             $type,
  String                               $zone          = $name,
  Stdlib::Absolutepath                 $config_file   = $unbound::config_file,
  String                               $template_name = 'unbound/local_zone.erb',
  Array[Unbound::Resource_record_type] $local_data    = [],
) {
  # Loop through the local_data hash and create ablock of local-data strings with the correctly formated
  # local-data lines which are ued in the final content block below.
  # local-data: 'api.test.com 15 300 IN A 192.0.2.1
  $records = $local_data.map |$record| {
    $data = $record['data']
    $_data = $record['type'] ? {
      'TXT'   => $data.unbound::split_txt(),
      default => $data,
    }
    $record_txt = "${record['name']} ${record['ttl']} ${record['class']} ${record['type']} ${_data}".regsubst(
      /\s+/, ' ', 'G'
    )  # Remove multiple spaces
    "  local-data: '${record_txt}'"
  }.join("\n")
  $content = @("CONTENT")
    server:
      local-zone: "${zone}" ${type}
    ${records}
    | CONTENT
  concat::fragment { "unbound-localzone-${name}":
    order   => '06',
    target  => $config_file,
    content => $content,
  }
}
