# Class: unbound::localzone
#
# Configures a local zone.
# The  default  zones  are  localhost, reverse 127.0.0.1 and ::1, and the
# AS112 zones. The AS112 zones are reverse DNS zones for private use  and
# reserved IP addresses for which the servers on the internet cannot pro-
# vide correct answers.
#
# === Parameters:
#
# [*zone*]
#   (required) String. Zone name.
#
# [*type*]
#   (required) Custom type Unbound::Local_zone_type.
#
# [*config_file*]
#   (optional) name of configuration file.
#
# [*local_data*]
#   (optional) Array.
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
#
# [*template_name*]
#   (optional) String.
#   Use a custom template.
#   Default value: 'unbound/local_zone.erb'.
#
define unbound::localzone (
  Unbound::Local_zone_type $type,
  String $zone = $name,
  $config_file = $unbound::config_file,
  Array[Unbound::Resource_record_type] $local_data = [],
  String $template_name = 'unbound/local_zone.erb'
) {
  concat::fragment { "unbound-localzone-${name}":
    order   => '06',
    target  => $config_file,
    content => template($template_name),
  }
}
