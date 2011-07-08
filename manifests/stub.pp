class unbound::stub ($address) {

  concat::fragment { 'unbound-stube-$name':
    order   => '05',
    target  => "$unbound_confdir/unbound.conf",
    content => template("unbound/stub.erb"),
  }

}
