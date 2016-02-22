# Class: unbound::local_zone
#
# Configures a local zone.
# The  default  zones  are  localhost, reverse 127.0.0.1 and ::1, and the
# AS112 zones. The AS112 zones are reverse DNS zones for private use  and
# reserved IP addresses for which the servers on the internet cannot pro-
# vide correct answers.
#
# === Parameters
#
# [*zone*]
#    (required) String. Zone name
#
# [*type*]
#   (required) String. (deny,refuse,static,transparent,typetransparent,redirect,nodefault)
#
# [*config_file*]
#   (optional) name of configuration file
#
define unbound::local_zone (
  $type,
  $zone = $name,
  $config_file = $unbound::params::config_file,
) {

  include ::unbound::params

  concat::fragment { "unbound-localzone-${name}":
    order   => '06',
    target  => $config_file,
    content => template('unbound/local_zone.erb'),
  }
}
