class {
  "unbound":
    interface => ["::0","0.0.0.0"],
    access    => ["fe80::/10","10.0.0.0/24"],
}

unbound::stub { "example.com":
  address  => '10.0.0.10',
  insecure => true,
}

unbound::stub { "0.0.0.10.in-addr.arpa.":
  address  => '10.0.0.10',
  insecure => true,
}

unbound::local_zone { "10.in-addr.arpa.":
  type => "nodefault"
}

unbound::forward { "10.in-addr.arpa.":
  address  => '10.0.0.10',
}
