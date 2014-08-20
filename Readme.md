# Unbound

[![Build Status](https://travis-ci.org/xaque208/puppet-unbound.png)](https://travis-ci.org/xaque208/puppet-unbound)

A puppet module for the Unbound caching resolver.

## Supported Platforms

* Debian
* FreeBSD
* OpenBSD
* OS X (macports)
* RHEL clones (with EPEL)
* openSUSE (local repo or obs://server:dns)

## Requirements
The `concat` module must be installed. It can be obtained from Puppet Forge:

    puppet module install ripienaar/concat

Or add this line to your `Puppetfile` and deploy with [R10k](https://github.com/adrienthebo/r10k):

    mod 'concat', :git => 'git://github.com/ripienaar/puppet-concat.git'

## Usage

### Server Setup

At minimum you should setup the interfaces to listen on and allow access to a few subnets.

```puppet
    class { "unbound":
      interface => ["::0","0.0.0.0"],
      access    => ["10.0.0.0/20","::1"],
    }
```

### Stub Zones

These are zones for which you have an authoritative name server and want to
direct queries.

```puppet
    unbound::stub { "lan.example.com":
      address  => '10.0.0.10',
      insecure => true,
    }

    unbound::stub { "0.0.10.in-addr.arpa.":
      address  => '10.0.0.10',
      insecure => true,
    }
```

Unless you have DNSSEC for your private zones, they are considered insecure,
noted by `insecure => true`.

### Static DNS records

For overriding DNS record in zone.

```puppet
    unbound::record { 'test.example.tld':
        type => 'A',
        content => '10.0.0.1',
        ttl => '14400',
    }
```

### Forward Zones

Setup a forward zone with a list of address from which you should resolve queries.  You can configure a forward zone with something like the following:

```puppet
    unbound::forward { '.':
      address => [
        '8.8.8.8',
        '8.8.4.4'
        ]
    }
```

This means that your server will use the Google DNS servers for any
zones that it doesn't know how to reach and cache the result.

### Remote Control

The Unbound remote control the use of the unbound-control utility to
issue commands to the Unbound daemon process.

```puppet
    include unbound::remote
```

On some platforms this is needed to function correctly.

## More information

You can find more information about Unbound and its configuration items at
[unbound.net](http://unbound.net).

## Contribute

Please help me make this module awesome!  Send pull requests and file issues.

