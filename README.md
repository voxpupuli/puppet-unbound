# Puppet powered DNS with Unbound

[![Build Status](https://github.com/voxpupuli/puppet-unbound/workflows/CI/badge.svg)](https://github.com/voxpupuli/puppet-unbound/actions?query=workflow%3ACI)
[![Release](https://github.com/voxpupuli/puppet-unbound/actions/workflows/release.yml/badge.svg)](https://github.com/voxpupuli/puppet-unbound/actions/workflows/release.yml)
[![Puppet Forge](https://img.shields.io/puppetforge/v/puppet/unbound.svg)](https://forge.puppetlabs.com/puppet/unbound)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/puppet/unbound.svg)](https://forge.puppetlabs.com/puppet/unbound)
[![Puppet Forge - endorsement](https://img.shields.io/puppetforge/e/puppet/unbound.svg)](https://forge.puppetlabs.com/puppet/unbound)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/puppet/unbound.svg)](https://forge.puppetlabs.com/puppet/unbound)
[![puppetmodule.info docs](http://www.puppetmodule.info/images/badge.png)](http://www.puppetmodule.info/m/puppet-unbound)
[![Apache-2.0 License](https://img.shields.io/github/license/voxpupuli/puppet-unbound.svg)](LICENSE)

A puppet module for the Unbound caching resolver.

## Supported Platforms

* Debian
* FreeBSD
* OpenBSD
* OS X (macports)
* RHEL clones (with EPEL)
* openSUSE (local repo or obs://server:dns)
* Archlinux

## Requirements

To use this module requires at least unbound 1.6.6.  Please also consult
metadata.json to understand the minimum puppet version and any other module
dependencies.

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

# address can be an array along with nameservers.
# in the following case, generated conf would be as follows:
#
#   stub-addr: 10.0.0.53
#   stub-addr: 10.0.0.10@10053
#   stub-host: ns1.example.com
#   stub-host: ns2.example.com
#
# note that conf will be generated in the same order provided.
unbound::stub { "10.0.10.in-addr.arpa.":
  address    => [ 10.0.0.53', '10.0.0.10@10053'],
  namservers => [ 'ns1.example.com', 'ns2.example.com' ],
}
```

Or, using hiera

```yaml
unbound::stub:
  '10.0.10.in-addr.arpa.':
    address:
      - '10.0.0.53
      - '10.0.0.10@10053'
    nameserveres:
      - 'ns1.example.com'
      - 'ns2.example.com'
```

Unless you have DNSSEC for your private zones, they are considered insecure,
noted by `insecure => true`.

### Static DNS records

For overriding DNS record in zone.

```puppet
unbound::record { 'test.example.tld':
    type    => 'A',
    content => '10.0.0.1',
    ttl     => '14400',
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

Setup a forward zone with a list of address from which you should resolve
queries.  You can configure a forward zone with something like the following:

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

### Domain Insecure

Sets  domain  name  to  be  insecure,  DNSSEC  chain of trust is
ignored towards the domain name.  So a trust  anchor  above  the
domain  name  can  not  make the domain secure with a DS record,
such a DS record is  then  ignored.   Also  keys  from  DLV  are
ignored  for the domain.  Can be given multiple times to specify
multiple domains that are treated as if unsigned.   If  you  set
trust anchors for the domain they override this setting (and the
domain is secured).

```puppet
class {'unbound:'
  domain_insecure => ['example.com', example.org']
}
```

Or, using hiera

```yaml
unbound::domain_insecure:
- example.com
- example.org
```

### Local Zones

Configure a local zone. The type determines the answer  to  give
if  there  is  no  match  from  local-data.  The types are deny,
refuse, static, transparent, redirect, nodefault,  typetranspar-
ent,  inform,  inform\_deny,  always\_transparent,  always\_refuse,
always\_nxdomain.  See local-zone in the [unbound documentation](https://unbound.net/documentation/unbound.conf.html)
for more information.  You can configure a local-zone with something like the
following.

```puppet
class {'unbound:'
  local_zone => { '10.0.10.in-addr.arpa.' => 'nodefault'}
}
```

Or, using unbound::localzone

```puppet
unbound::localzone { '10.0.10.in-addr.arpa.':
  type => 'nodefault'
}
```

Or, using hiera

```yaml
unbound::local_zone:
  10.0.10.in-addr.arpa.: nodefault
  11.0.10.in-addr.arpa.: nodefault
```

### Fine grain access-control

```puppet
class { "unbound":
  interface => ["::0","0.0.0.0"],
  access    => ["10.0.0.0/20", "10.0.0.5/32 reject", "::1 allow_snoop"],
}
```

The access option allows to pass the action for each subnets, if the action is
not provided we assume it’s 'allow'.

### Adding arbitrary unbound configuration parameters

```puppet
class { "unbound":
  interface          => ["::0","0.0.0.0"],
  access             => ["10.0.0.0/20","::1"],
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
