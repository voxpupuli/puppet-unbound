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
#   (required) String. Zone name
#
# [*type*]
#   (required) Custom type Unbound::Local_zone_type
#
# [*config_file*]
#   (optional) name of configuration file
#
define unbound::localzone (
  Unbound::Local_zone_type $type,
  String $zone = $name,
  $config_file = $unbound::config_file,
) {

  concat::fragment { "unbound-localzone-${name}":
    order   => '06',
    target  => $config_file,
    content => template('unbound/local_zone.erb'),
  }
}
