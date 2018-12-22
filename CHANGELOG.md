## Unreleased

## 2018-12-21 2.4.0
### Summary
Improvements and additional support for unbound features.

Notable changes:
  * Change default value for interface.
  * Change default values for harden_short_bufsize and harden_large_queries.
  * Include new options for python_script, dns64, client_subnet_*, ipsecmod_* and redis_* and a few more unbound modules.
  * Add support for SmartOS.
  * Pidfile fix.
  * Slight changes to data types on unbound class.
  * Revive localzone define.

## 2018-06-02 2.3.2
Updates to modulesync_config, and ensure that unbound is restarted when the
interface is changed, as a reload is insufficient.

## 2018-05-31 2.3.1
### Summary
Add missing module-config parameter to the template.  This was lost as part of 8ab7ee7cdb7ec940c6f2fabd5c3aadca5a1448e4, and here we are bringing it back.

## 2018-05-31 2.3.0
### Summary
Backwards incompatible change for setting unbound service 'hasstatus' to true.  This was previously disabled for older Debian, but this has likely been a bad default to have.


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



