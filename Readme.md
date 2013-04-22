# Unbound

A puppet module for the Unbound caching resolver.

## Supported Platforms

* Debian
* FreeBSD
* OS X
* RHEL clones (with EPEL)

## Usage

### Server Setup

At minimum you should setup the interfaces to listen on and allow access to a few subnets.

    class {
      "unbound":
        interface => ["::0","0.0.0.0"],
        access    => ["10.0.0.0/20","::1"],
    }

### Stub Zones

These are zones for which you have an authoritative name server and want to
direct queries.

    unbound::stub { "lan.example.com":
      address  => '10.0.0.10',
      insecure => true,
    }

    unbound::stub { "0.0.10.in-addr.arpa.":
      address  => '10.0.0.10',
      insecure => true,
    } 

Unless you have DNSSEC for your private zones, they are considered insecure,
noted by `insecure => true`.

### Static DNS records

For overriding DNS record in zone.

    unbound::record { 'test.example.tld':
        type => 'A',
        content => '10.0.0.1',
        ttl => '14400',
    }
