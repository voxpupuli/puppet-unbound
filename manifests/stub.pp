define unbound::stub ($address) {
  include unbound::params

  $unbound_confdir = $unbound::params::unbound_confdir

  concat::fragment { 'unbound-stube-$name':
    order   => '05',
    target  => "$unbound_confdir/unbound.conf",
    content => template("unbound/stub.erb"),
  }

}
