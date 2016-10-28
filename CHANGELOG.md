## Unreleased

## 2016-10-28 2.0.0
### Summary
This release contains bugfixes, platform support change, and puppet version support changes.

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



