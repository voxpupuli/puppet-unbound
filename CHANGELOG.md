## Unreleased

## 2018-05-21 2.2.0
### Summary
This release contains a significant modulesync update, and several small default param changes.

Pram changes:
  * username is now owner by default
  * pidfile is now /var/run/unbound/unbound.pid by default
  * do_daemonize param is now true by default
  * add msg-cache-size
  * constrain unblock-lan-zones to 1.5.0
  * constrain udp-upstream-without-downstream to 1.6.7
  * add forward-ssl-upstream to forward class
  * add forward-host to forward class


## 2018-02-25 2.1.0
### Summary
This release contains updates to testing, configuration template improvements,
and additional options from the unbound.conf manpage.

## 2016-10-28 2.0.0
### Summary
This release contains bugfixes, platform support change, and puppet version
support changes.

#### Features
 - Use native Puppet4 class input validation
 - Use native Puppet4 hiera module data for platform differences
 - Ease testing by using rspec-puppet-facts
 - Add support for FreeBSD port

#### Bugfixes
 - FreeBSD testing was incomplete due to a bug in the tests

#### Backwards incompatible changes
 - Drop support for puppet 3.x to leverage new puppet 4.x features
 - Drop support for local_unbound on FreeBSD



