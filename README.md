# Puppet powered DNS with Unbound

[![Puppet Forge](https://img.shields.io/puppetforge/v/zleslie/unbound.svg)](https://forge.puppet.com/zleslie/unbound) [![Build Status](https://travis-ci.org/xaque208/puppet-unbound.svg?branch=master)](https://travis-ci.org/xaque208/puppet-unbound)

A puppet module for the Unbound caching resolver.

## Supported Platforms

* Debian
* FreeBSD
* OpenBSD
* OS X (macports)
* RHEL clones (with EPEL)
* openSUSE (local repo or obs://server:dns)

## Requirements

To use this moudule, you must be running at least Puppet 4.4.  If you are on an
older version of Puppet, please use a 1.x version of this module.

To use this module, you must install the `puppetlabs/concat` and
`puppetlabs/stdlib` modules, either from the forge using `puppet module
install`, or ensuring the following lines are present in your Puppetfile for an
[R10k](https://github.com/puppetlabs/r10k) deployment.

```Ruby
mod 'concat', :git => 'git://github.com/puppetlabs/puppetlabs-concat.git'
mod 'stdlib', :git => 'git://github.com/puppetlabs/puppetlabs-stdlib.git'
```

## Usage

### Server Setup

At minimum you should setup the interfaces to listen on and allow access to a
few subnets.  This will tell unbound which interfaces to listen on, and which
networks to allow queries from.

```puppet
class { "unbound":
  interface => ["::0","0.0.0.0"],
  access    => ["10.0.0.0/20","::1"],
}
```

Or, using hiera
```yaml
unbound::interface:
  - '::0'
  - '0.0.0.0'
unbound::access:
  - '10.0.0.0/20'
  - '::1'
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

# port can be specified
unbound::stub { "0.0.10.in-addr.arpa.":
  address  => '10.0.0.10@10053',
  insecure => true,
}

# address can be an array.
# in the following case, generated conf would be as follows:
#
#   stub-host: ns1.example.com
#   stub-addr: 10.0.0.10@10053
#   stub-host: ns2.example.com
#
# note that conf will be generated in the same order provided.
unbound::stub { "10.0.10.in-addr.arpa.":
  address => [ 'ns1.example.com', '10.0.0.10@10053', 'ns2.example.com' ],
}
```

Or, using hiera
```yaml
unbound::stub:
  '10.0.10.in-addr.arpa.':
    address:
      - 'ns1.example.com'
      - '10.0.0.10@10053'
      - 'ns2.example.com'
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

Or, using hiera
```yaml
unbound::record:
  'test.example.tld':
    type: 'A'
    content: '10.0.0.1'
    ttl: '14400'
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

Or, using hiera
```yaml
unbound::forward:
  '.':
    address:
      - '8.8.8.8'
      - '8.8.4.4'
```

This means that your server will use the Google DNS servers for any
zones that it doesn't know how to reach and cache the result.


### Fine grain access-control

```puppet
class { "unbound":
  interface => ["::0","0.0.0.0"],
  access    => ["10.0.0.0/20", "10.0.0.5/32 reject", "::1 allow_snoop"],
}
```

The access option allows to pass the action for each subnets, if the action is not provided we assume it’s 'allow'.

### Adding arbitrary unbound configuration parameters

```puppet
class { "unbound":
  interface => ["::0","0.0.0.0"],
  access    => ["10.0.0.0/20","::1"],
  custom_server_conf => [ 'include: "/etc/unbound/conf.d/*.conf"' ],
}
```

The _custom_server_conf_ option allows the addition of arbitrary configuration
parameters to your server configuration. It expects an array, and each element
gets added to the configuration file on a separate line. In the example above,
we instruct Unbound to load other configuration files from a subdirectory.

### Remote Control

The Unbound remote controls the use of the unbound-control utility to issue
commands to the Unbound daemon process.

```puppet
class { "unbound::remote":
  enable => true,
}
```

On some platforms this is needed to function correctly for things like service
reloads.

### Skipping hints download

In the case you're only building a caching forwarder and don't do iterative
lookups you might not want to download the hints file containing the root
nameservers because you don't need it, or you also might not be able to
download it anyway because your server is firewalled which would cause the
module would hang on trying to download the hints file. To skip the download
set the skip_roothints_download parameter to true.

```puppet
class { "unbound":
  skip_roothints_download => true,
}
```

## More information

You can find more information about Unbound and its configuration items at
[unbound.net](http://unbound.net).

## Contribute

Please help me make this module awesome!  Send pull requests and file issues.
