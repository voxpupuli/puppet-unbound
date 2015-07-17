# Class: unbound::stub::validate_addr
#
# Validate address arg of unbound::stub
#
define unbound::stub::validate_addr{

  $addr_name_arr = split($name, ',')

  $addr_arr = split($addr_name_arr[0], '@')

  # check if the address arg is a valid ip address
  if is_ip_address($addr_arr[0]) {

    # multiple '@' signs invalid
    if size($addr_arr) > 2 {
      fail('unbound::stub: invalid address. too many at signs in it.')
    }

    # port num must be integer if exists
    if size($addr_arr) == 2 and ! is_integer($addr_arr[1]) {
      fail('unbound::stub: port num is invalid')
    }

  # address arg must be either ip address or hostname
  } elsif ! is_domain_name($addr_name_arr[0]) {
    fail('unbound::stub: invalid address.')
  }
}
