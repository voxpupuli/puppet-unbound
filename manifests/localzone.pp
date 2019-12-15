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
#   Define local data which should be rendered.
#   Default value: [].
#   Example:
#     unbound::localzone::local_data:
#       - 'api.test.com 15 IN A 1.1.1.1'
#       - 'backend.test.com' 15 IN A 1.1.1.1'
#
# [*template_name*]
#   (optional) String.
#   Use a custom template.
#   Default value: 'unbound/local_zone.erb'
#
define unbound::localzone (
  Unbound::Local_zone_type $type,
  String $zone = $name,
  $config_file = $unbound::config_file,
  Array[String] $local_data = [],
  String $template_name = 'unbound/local_zone.erb'
) {

  concat::fragment { "unbound-localzone-${name}":
    order   => '06',
    target  => $config_file,
    content => template($template_name),
  }
}
