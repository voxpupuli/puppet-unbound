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
# String. Zone name
#
# [*type*]
# String. (deny,refuse,static,transparent,typetransparent,redirect,nodefault)

define unbound::local_zone (
  $type,
  $zone = $name,
) {

  include unbound::params

  $config_file = $unbound::params::config_file

  concat::fragment { "unbound-localzone-${name}":
    order   => '00',
    target  => $config_file,
    content => template('unbound/local_zone.erb'),
  }
}
