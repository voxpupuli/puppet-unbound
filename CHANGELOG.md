# Changelog

All notable changes to this project will be documented in this file.
Each new release typically also includes the latest modulesync defaults.
These should not affect the functionality of the module.

## [v6.0.0](https://github.com/voxpupuli/puppet-unbound/tree/v6.0.0) (2022-09-23)

[Full Changelog](https://github.com/voxpupuli/puppet-unbound/compare/v5.1.1...v6.0.0)

**Breaking changes:**

- Require Unbound 1.6.6 or newer [\#287](https://github.com/voxpupuli/puppet-unbound/pull/287) ([b4ldr](https://github.com/b4ldr))

**Implemented enhancements:**

- Introduce unbound\_version parameter [\#307](https://github.com/voxpupuli/puppet-unbound/pull/307) ([bastelfreak](https://github.com/bastelfreak))

**Fixed bugs:**

- unbound.conf: purge trailing whitespace [\#306](https://github.com/voxpupuli/puppet-unbound/pull/306) ([bastelfreak](https://github.com/bastelfreak))

**Closed issues:**

- unbound\_version not set on first run causing unexpected config file setting [\#286](https://github.com/voxpupuli/puppet-unbound/issues/286)

## [v5.1.1](https://github.com/voxpupuli/puppet-unbound/tree/v5.1.1) (2022-07-14)

[Full Changelog](https://github.com/voxpupuli/puppet-unbound/compare/v5.1.0...v5.1.1)

**Fixed bugs:**

- metadata.json: Fix source URL [\#304](https://github.com/voxpupuli/puppet-unbound/pull/304) ([bastelfreak](https://github.com/bastelfreak))

## [v5.1.0](https://github.com/voxpupuli/puppet-unbound/tree/v5.1.0) (2022-06-28)

[Full Changelog](https://github.com/voxpupuli/puppet-unbound/compare/v5.0.0...v5.1.0)

**Implemented enhancements:**

- 296: Add support for multiple contents/records in unbound::record [\#300](https://github.com/voxpupuli/puppet-unbound/pull/300) ([b4ldr](https://github.com/b4ldr))
- \(297\) Add support for stub nameservers and fix docs [\#298](https://github.com/voxpupuli/puppet-unbound/pull/298) ([b4ldr](https://github.com/b4ldr))
- \(\#250\) Add RPZ support [\#259](https://github.com/voxpupuli/puppet-unbound/pull/259) ([b4ldr](https://github.com/b4ldr))

**Fixed bugs:**

- Arch Linux: Set correct owner amd fetch\_client [\#301](https://github.com/voxpupuli/puppet-unbound/pull/301) ([b4ldr](https://github.com/b4ldr))

**Closed issues:**

- Documentation is misleading when using unbound::stub [\#297](https://github.com/voxpupuli/puppet-unbound/issues/297)
- No support Static record mapping to multiple IP [\#296](https://github.com/voxpupuli/puppet-unbound/issues/296)
- Please support 'respip' in module\_config [\#250](https://github.com/voxpupuli/puppet-unbound/issues/250)

**Merged pull requests:**

- 'target-fetch-policy' is supposed to be a single string [\#289](https://github.com/voxpupuli/puppet-unbound/pull/289) ([rumpelst1lzk1n](https://github.com/rumpelst1lzk1n))

## [v5.0.0](https://github.com/voxpupuli/puppet-unbound/tree/v5.0.0) (2022-02-01)

[Full Changelog](https://github.com/voxpupuli/puppet-unbound/compare/v4.0.1...v5.0.0)

**Breaking changes:**

- Drop support for FreeBSD 11 \(EOL\) [\#283](https://github.com/voxpupuli/puppet-unbound/pull/283) ([smortex](https://github.com/smortex))
- Drop support for Debian 9 \(EOL\) [\#280](https://github.com/voxpupuli/puppet-unbound/pull/280) ([smortex](https://github.com/smortex))

**Implemented enhancements:**

- Make service manageable [\#285](https://github.com/voxpupuli/puppet-unbound/pull/285) ([and0x000](https://github.com/and0x000))
- Add support for FreeBSD 13 [\#284](https://github.com/voxpupuli/puppet-unbound/pull/284) ([smortex](https://github.com/smortex))
- Add support for Debian 11 [\#281](https://github.com/voxpupuli/puppet-unbound/pull/281) ([smortex](https://github.com/smortex))

**Fixed bugs:**

- fix typo in template: includes? -\> include? / make access\_control parameter useable [\#293](https://github.com/voxpupuli/puppet-unbound/pull/293) ([bastelfreak](https://github.com/bastelfreak))

**Merged pull requests:**

- Add unit tests for access\_control datatype [\#292](https://github.com/voxpupuli/puppet-unbound/pull/292) ([bastelfreak](https://github.com/bastelfreak))

## [v4.0.1](https://github.com/voxpupuli/puppet-unbound/tree/v4.0.1) (2021-08-26)

[Full Changelog](https://github.com/voxpupuli/puppet-unbound/compare/v4.0.0...v4.0.1)

**Fixed bugs:**

- $tls\_upstreami -\> $tls\_upstream typo [\#276](https://github.com/voxpupuli/puppet-unbound/pull/276) ([steadramon](https://github.com/steadramon))
- Adjustment for DNS Flag Day 2020 [\#275](https://github.com/voxpupuli/puppet-unbound/pull/275) ([steadramon](https://github.com/steadramon))

**Merged pull requests:**

- Allow stdlib 8.0.0 [\#277](https://github.com/voxpupuli/puppet-unbound/pull/277) ([smortex](https://github.com/smortex))

## [v4.0.0](https://github.com/voxpupuli/puppet-unbound/tree/v4.0.0) (2021-04-27)

[Full Changelog](https://github.com/voxpupuli/puppet-unbound/compare/v3.0.0...v4.0.0)

**Breaking changes:**

- Drop EoL Ubuntu 16.04 support [\#273](https://github.com/voxpupuli/puppet-unbound/pull/273) ([bastelfreak](https://github.com/bastelfreak))
- puppet5: drop puppet 5 support [\#266](https://github.com/voxpupuli/puppet-unbound/pull/266) ([b4ldr](https://github.com/b4ldr))
- Drop RedHat 6 \(and derivatives\) support [\#256](https://github.com/voxpupuli/puppet-unbound/pull/256) ([b4ldr](https://github.com/b4ldr))

**Fixed bugs:**

- Resource default statements in module [\#242](https://github.com/voxpupuli/puppet-unbound/issues/242)

**Merged pull requests:**

- puppetlabs/concat: Allow 7.x [\#268](https://github.com/voxpupuli/puppet-unbound/pull/268) ([bastelfreak](https://github.com/bastelfreak))
- puppetlabs/stdlib: Allow 7.x [\#267](https://github.com/voxpupuli/puppet-unbound/pull/267) ([bastelfreak](https://github.com/bastelfreak))
- move defaults to class so that puppet-strings can build better docs [\#265](https://github.com/voxpupuli/puppet-unbound/pull/265) ([b4ldr](https://github.com/b4ldr))
- Refactor [\#264](https://github.com/voxpupuli/puppet-unbound/pull/264) ([b4ldr](https://github.com/b4ldr))
- Provide root-hints variables & overrides for different scenarios [\#263](https://github.com/voxpupuli/puppet-unbound/pull/263) ([jared-gs](https://github.com/jared-gs))
- Unbound 1.9.0 [\#262](https://github.com/voxpupuli/puppet-unbound/pull/262) ([steadramon](https://github.com/steadramon))
- 242: use collections to add additional parameters [\#260](https://github.com/voxpupuli/puppet-unbound/pull/260) ([b4ldr](https://github.com/b4ldr))
- Fix spec test [\#254](https://github.com/voxpupuli/puppet-unbound/pull/254) ([b4ldr](https://github.com/b4ldr))

## [v3.0.0](https://github.com/voxpupuli/puppet-unbound/tree/v3.0.0) (2020-09-30)

[Full Changelog](https://github.com/voxpupuli/puppet-unbound/compare/v2.8.0...v3.0.0)

**Breaking changes:**

- Drop Debian 6/7/8 support and compatibility [\#246](https://github.com/voxpupuli/puppet-unbound/pull/246) ([bastelfreak](https://github.com/bastelfreak))

**Implemented enhancements:**

- Add support for stub-no-cache option [\#241](https://github.com/voxpupuli/puppet-unbound/pull/241) ([xaque208](https://github.com/xaque208))

**Fixed bugs:**

- Fix erb template to allow string for address attribute [\#247](https://github.com/voxpupuli/puppet-unbound/pull/247) ([bastelfreak](https://github.com/bastelfreak))

**Merged pull requests:**

- Disable Debian 8 acceptance tests [\#248](https://github.com/voxpupuli/puppet-unbound/pull/248) ([bastelfreak](https://github.com/bastelfreak))

## [v2.8.0](https://github.com/voxpupuli/puppet-unbound/tree/v2.8.0) (2020-09-25)

[Full Changelog](https://github.com/voxpupuli/puppet-unbound/compare/v2.7.0...v2.8.0)

Debian 8 is EOL since some time now. This 2.8.0 release will be the last one with Debian 8 support. The next release will be 3.0.0 without Debian 8!

**Implemented enhancements:**

- Implement Archlinux support [\#243](https://github.com/voxpupuli/puppet-unbound/pull/243) ([bastelfreak](https://github.com/bastelfreak))

**Fixed bugs:**

- Single quote TXT records and break them into strings of 255 characters [\#238](https://github.com/voxpupuli/puppet-unbound/pull/238) ([FredericLespez](https://github.com/FredericLespez))

**Closed issues:**

- Handle TXT records containing double quotes and white space [\#237](https://github.com/voxpupuli/puppet-unbound/issues/237)

**Merged pull requests:**

- Resolve puppet-lint notices [\#240](https://github.com/voxpupuli/puppet-unbound/pull/240) ([jcpunk](https://github.com/jcpunk))
- modulesync 3.0.0 & puppet-lint updates [\#239](https://github.com/voxpupuli/puppet-unbound/pull/239) ([bastelfreak](https://github.com/bastelfreak))
- Restart for interface change after service is configured [\#236](https://github.com/voxpupuli/puppet-unbound/pull/236) ([nward](https://github.com/nward))
- Fix several markdown lint issues [\#235](https://github.com/voxpupuli/puppet-unbound/pull/235) ([dhoppe](https://github.com/dhoppe))

## [v2.7.0](https://github.com/voxpupuli/puppet-unbound/tree/v2.7.0) (2020-04-21)

[Full Changelog](https://github.com/voxpupuli/puppet-unbound/compare/v2.6.0...v2.7.0)

**Implemented enhancements:**

- Add support for CentOS / RedHat 8 [\#233](https://github.com/voxpupuli/puppet-unbound/pull/233) ([dhoppe](https://github.com/dhoppe))

**Merged pull requests:**

- Fix on OS where root group != 'root' [\#231](https://github.com/voxpupuli/puppet-unbound/pull/231) ([buzzdeee](https://github.com/buzzdeee))
- Fix order of parameters [\#229](https://github.com/voxpupuli/puppet-unbound/pull/229) ([dhoppe](https://github.com/dhoppe))

## [v2.6.0](https://github.com/voxpupuli/puppet-unbound/tree/v2.6.0) (2020-02-12)

[Full Changelog](https://github.com/voxpupuli/puppet-unbound/compare/2.5.0...v2.6.0)

**Implemented enhancements:**

- Purge unmanaged configuration files [\#225](https://github.com/voxpupuli/puppet-unbound/pull/225) ([findmyname666](https://github.com/findmyname666))

**Closed issues:**

- Fix installation on Debian distribution - e.g. unbound option auto-trust-anchor-file is provided two times [\#223](https://github.com/voxpupuli/puppet-unbound/issues/223)
- commit 5868593634371290ad013e4a3005f25cb8d7e1fe broke the module for me [\#221](https://github.com/voxpupuli/puppet-unbound/issues/221)
- add ability to define/generate local-data + override local-zone template [\#215](https://github.com/voxpupuli/puppet-unbound/issues/215)
- `unbound_version` fact needs a test [\#207](https://github.com/voxpupuli/puppet-unbound/issues/207)
- unbound-checkconf fails on first-time configuration \(pid dir is missing\) [\#188](https://github.com/voxpupuli/puppet-unbound/issues/188)
- fatal error: auto-trust-anchor-file: "/var/lib/unbound/root.key" does not exist in chrootdir /etc/unbound [\#134](https://github.com/voxpupuli/puppet-unbound/issues/134)
- Modifying forward config file location [\#129](https://github.com/voxpupuli/puppet-unbound/issues/129)
- set permissions/ownership on configuration directories? [\#65](https://github.com/voxpupuli/puppet-unbound/issues/65)

**Merged pull requests:**

- Update CHANGELOG.md, based on command bundle exec rake changelog [\#227](https://github.com/voxpupuli/puppet-unbound/pull/227) ([dhoppe](https://github.com/dhoppe))
- ignore lint: quote boolean values have been \[i belive\] supported for … [\#226](https://github.com/voxpupuli/puppet-unbound/pull/226) ([b4ldr](https://github.com/b4ldr))
- Add test for unbound::stub [\#222](https://github.com/voxpupuli/puppet-unbound/pull/222) ([xaque208](https://github.com/xaque208))
- validate\_unbond\_addr: replace functionality with a custom type [\#220](https://github.com/voxpupuli/puppet-unbound/pull/220) ([b4ldr](https://github.com/b4ldr))

## [2.5.0](https://github.com/voxpupuli/puppet-unbound/tree/2.5.0) (2019-12-28)

[Full Changelog](https://github.com/voxpupuli/puppet-unbound/compare/2.4.3...2.5.0)

**Closed issues:**

- Debian: module change ownership of directory /run to unbound [\#208](https://github.com/voxpupuli/puppet-unbound/issues/208)
- version 2.4.3 breaks the configfile for tls-upstream on CentOS 7 [\#199](https://github.com/voxpupuli/puppet-unbound/issues/199)
- Wrong quoting for local-data TXT records [\#196](https://github.com/voxpupuli/puppet-unbound/issues/196)
- neg-cache-size is not specifiable [\#115](https://github.com/voxpupuli/puppet-unbound/issues/115)

**Merged pull requests:**

- Add functionality to render local data and override local-zone template: [\#216](https://github.com/voxpupuli/puppet-unbound/pull/216) ([findmyname666](https://github.com/findmyname666))
- update type typo [\#214](https://github.com/voxpupuli/puppet-unbound/pull/214) ([dsoltero](https://github.com/dsoltero))
- update variable typos [\#213](https://github.com/voxpupuli/puppet-unbound/pull/213) ([dsoltero](https://github.com/dsoltero))
- unbound\_version: add spec tests to the unbound\_version fact [\#212](https://github.com/voxpupuli/puppet-unbound/pull/212) ([b4ldr](https://github.com/b4ldr))
- Fix facter regex [\#211](https://github.com/voxpupuli/puppet-unbound/pull/211) ([xaque208](https://github.com/xaque208))
- stop managing system directories like /run [\#210](https://github.com/voxpupuli/puppet-unbound/pull/210) ([tequeter](https://github.com/tequeter))
- Service [\#206](https://github.com/voxpupuli/puppet-unbound/pull/206) ([xaque208](https://github.com/xaque208))
- Fix neg-cache-size in unbound.conf [\#205](https://github.com/voxpupuli/puppet-unbound/pull/205) ([cohoe](https://github.com/cohoe))
- Add service control and package ensure parameters [\#204](https://github.com/voxpupuli/puppet-unbound/pull/204) ([cohoe](https://github.com/cohoe))
- Fix typo [\#203](https://github.com/voxpupuli/puppet-unbound/pull/203) ([cure](https://github.com/cure))
- beaker: fix beaker [\#201](https://github.com/voxpupuli/puppet-unbound/pull/201) ([b4ldr](https://github.com/b4ldr))
- Issue 199: add version checking for ssl/tls parameters [\#200](https://github.com/voxpupuli/puppet-unbound/pull/200) ([b4ldr](https://github.com/b4ldr))
- Set harden-referral-path to false by default. [\#198](https://github.com/voxpupuli/puppet-unbound/pull/198) ([jensalmer](https://github.com/jensalmer))

## [2.4.3](https://github.com/voxpupuli/puppet-unbound/tree/2.4.3) (2019-04-22)

[Full Changelog](https://github.com/voxpupuli/puppet-unbound/compare/2.4.2...2.4.3)

**Merged pull requests:**

- Update from xaque208 modulesync\_config [\#195](https://github.com/voxpupuli/puppet-unbound/pull/195) ([xaque208](https://github.com/xaque208))
- Support TLS [\#193](https://github.com/voxpupuli/puppet-unbound/pull/193) ([xaque208](https://github.com/xaque208))
- Update from xaque208 modulesync\_config [\#191](https://github.com/voxpupuli/puppet-unbound/pull/191) ([xaque208](https://github.com/xaque208))

## [2.4.2](https://github.com/voxpupuli/puppet-unbound/tree/2.4.2) (2019-03-04)

[Full Changelog](https://github.com/voxpupuli/puppet-unbound/compare/2.4.1...2.4.2)

## [2.4.1](https://github.com/voxpupuli/puppet-unbound/tree/2.4.1) (2019-03-04)

[Full Changelog](https://github.com/voxpupuli/puppet-unbound/compare/2.4.0...2.4.1)

**Merged pull requests:**

- Update from xaque208 modulesync\_config [\#189](https://github.com/voxpupuli/puppet-unbound/pull/189) ([xaque208](https://github.com/xaque208))

## [2.4.0](https://github.com/voxpupuli/puppet-unbound/tree/2.4.0) (2018-12-22)

[Full Changelog](https://github.com/voxpupuli/puppet-unbound/compare/2.3.2...2.4.0)

**Closed issues:**

- Add SmartOS support [\#184](https://github.com/voxpupuli/puppet-unbound/issues/184)
- Binding to 0.0.0.0 is a bad practice  [\#183](https://github.com/voxpupuli/puppet-unbound/issues/183)
- pid dir permissions could cause problems [\#180](https://github.com/voxpupuli/puppet-unbound/issues/180)
- Unable to call unbound::local\_zone class anymore [\#177](https://github.com/voxpupuli/puppet-unbound/issues/177)
- interface changes don't take affect [\#166](https://github.com/voxpupuli/puppet-unbound/issues/166)
- Add support for python-scipt [\#140](https://github.com/voxpupuli/puppet-unbound/issues/140)
- Should add support for ssl-upstream config option [\#138](https://github.com/voxpupuli/puppet-unbound/issues/138)

**Merged pull requests:**

- Add SmartOS support \#184 [\#187](https://github.com/voxpupuli/puppet-unbound/pull/187) ([joelgarboden](https://github.com/joelgarboden))
- Fix module-config [\#186](https://github.com/voxpupuli/puppet-unbound/pull/186) ([silkeh](https://github.com/silkeh))
- Change default interface value [\#185](https://github.com/voxpupuli/puppet-unbound/pull/185) ([xaque208](https://github.com/xaque208))
- Restore unbound::local\_zone function [\#182](https://github.com/voxpupuli/puppet-unbound/pull/182) ([jlutran](https://github.com/jlutran))
- Change default values for harden\_short\_bufsize & harden\_large\_queries [\#181](https://github.com/voxpupuli/puppet-unbound/pull/181) ([jlutran](https://github.com/jlutran))
- add module\_config [\#176](https://github.com/voxpupuli/puppet-unbound/pull/176) ([b4ldr](https://github.com/b4ldr))

## [2.3.2](https://github.com/voxpupuli/puppet-unbound/tree/2.3.2) (2018-06-03)

[Full Changelog](https://github.com/voxpupuli/puppet-unbound/compare/2.3.1...2.3.2)

**Merged pull requests:**

- Update from xaque208 modulesync\_config [\#178](https://github.com/voxpupuli/puppet-unbound/pull/178) ([xaque208](https://github.com/xaque208))
- add method to restart unbound on interface change [\#170](https://github.com/voxpupuli/puppet-unbound/pull/170) ([b4ldr](https://github.com/b4ldr))

## [2.3.1](https://github.com/voxpupuli/puppet-unbound/tree/2.3.1) (2018-05-31)

[Full Changelog](https://github.com/voxpupuli/puppet-unbound/compare/2.3.0...2.3.1)

**Merged pull requests:**

- Add missing module-config parameter to the template [\#174](https://github.com/voxpupuli/puppet-unbound/pull/174) ([fklajn](https://github.com/fklajn))

## [2.3.0](https://github.com/voxpupuli/puppet-unbound/tree/2.3.0) (2018-05-31)

[Full Changelog](https://github.com/voxpupuli/puppet-unbound/compare/2.2.0-ICANN1...2.3.0)

**Merged pull requests:**

- add hasstatus switch [\#175](https://github.com/voxpupuli/puppet-unbound/pull/175) ([b4ldr](https://github.com/b4ldr))

## [2.2.0-ICANN1](https://github.com/voxpupuli/puppet-unbound/tree/2.2.0-ICANN1) (2018-05-30)

[Full Changelog](https://github.com/voxpupuli/puppet-unbound/compare/2.2.0...2.2.0-ICANN1)

**Closed issues:**

- 2.1.0 does not work with unbound version \< 1.6.7 [\#172](https://github.com/voxpupuli/puppet-unbound/issues/172)
- service hasstatus =\> false [\#171](https://github.com/voxpupuli/puppet-unbound/issues/171)

## [2.2.0](https://github.com/voxpupuli/puppet-unbound/tree/2.2.0) (2018-05-21)

[Full Changelog](https://github.com/voxpupuli/puppet-unbound/compare/2.1.0...2.2.0)

**Merged pull requests:**

- Fix regressions [\#169](https://github.com/voxpupuli/puppet-unbound/pull/169) ([fklajn](https://github.com/fklajn))
- Set unbound pidfile for 6.3 [\#167](https://github.com/voxpupuli/puppet-unbound/pull/167) ([xaque208](https://github.com/xaque208))
- Update from xaque208 modulesync\_config [\#165](https://github.com/voxpupuli/puppet-unbound/pull/165) ([xaque208](https://github.com/xaque208))
- Include .sync.yml for lost beaker tests [\#164](https://github.com/voxpupuli/puppet-unbound/pull/164) ([xaque208](https://github.com/xaque208))
- Update from xaque208 modulesync\_config [\#163](https://github.com/voxpupuli/puppet-unbound/pull/163) ([xaque208](https://github.com/xaque208))
- Allow to set parameter forward-ssl-upstream for forward zones in [\#161](https://github.com/voxpupuli/puppet-unbound/pull/161) ([buzzdeee](https://github.com/buzzdeee))
- Update to hiera v5 [\#160](https://github.com/voxpupuli/puppet-unbound/pull/160) ([jlutran](https://github.com/jlutran))
- Allow forward-host option [\#159](https://github.com/voxpupuli/puppet-unbound/pull/159) ([xaque208](https://github.com/xaque208))
- acceptance testing [\#158](https://github.com/voxpupuli/puppet-unbound/pull/158) ([b4ldr](https://github.com/b4ldr))

## [2.1.0](https://github.com/voxpupuli/puppet-unbound/tree/2.1.0) (2018-02-26)

[Full Changelog](https://github.com/voxpupuli/puppet-unbound/compare/2.0.0...2.1.0)

**Closed issues:**

- Add option to allow unbound to log to file instead of syslog [\#146](https://github.com/voxpupuli/puppet-unbound/issues/146)
- Options not found [\#145](https://github.com/voxpupuli/puppet-unbound/issues/145)
- Should support the unbound port on FreeBSD [\#126](https://github.com/voxpupuli/puppet-unbound/issues/126)
- New features are not documented [\#37](https://github.com/voxpupuli/puppet-unbound/issues/37)

**Merged pull requests:**

- 138 tls options [\#156](https://github.com/voxpupuli/puppet-unbound/pull/156) ([b4ldr](https://github.com/b4ldr))
- add log options [\#155](https://github.com/voxpupuli/puppet-unbound/pull/155) ([b4ldr](https://github.com/b4ldr))
- add local\_zone and domain\_insecure parameters [\#153](https://github.com/voxpupuli/puppet-unbound/pull/153) ([b4ldr](https://github.com/b4ldr))
- Added option to allow unbound to log to file instead of syslog [\#147](https://github.com/voxpupuli/puppet-unbound/pull/147) ([enemarke](https://github.com/enemarke))
- modulesync 2017-05-03 [\#139](https://github.com/voxpupuli/puppet-unbound/pull/139) ([xaque208](https://github.com/xaque208))
- Add test for the interface selection [\#137](https://github.com/voxpupuli/puppet-unbound/pull/137) ([xaque208](https://github.com/xaque208))
- Validation requires the anchor file is present [\#136](https://github.com/voxpupuli/puppet-unbound/pull/136) ([xaque208](https://github.com/xaque208))

## [2.0.0](https://github.com/voxpupuli/puppet-unbound/tree/2.0.0) (2016-10-28)

[Full Changelog](https://github.com/voxpupuli/puppet-unbound/compare/1.3.6...2.0.0)

**Closed issues:**

- Should handle local unbound on FreeBSD with more grace [\#125](https://github.com/voxpupuli/puppet-unbound/issues/125)

**Merged pull requests:**

- Step into the future [\#133](https://github.com/voxpupuli/puppet-unbound/pull/133) ([xaque208](https://github.com/xaque208))
- Begin migration away from params [\#132](https://github.com/voxpupuli/puppet-unbound/pull/132) ([xaque208](https://github.com/xaque208))

## [1.3.6](https://github.com/voxpupuli/puppet-unbound/tree/1.3.6) (2016-07-12)

[Full Changelog](https://github.com/voxpupuli/puppet-unbound/compare/1.3.5...1.3.6)

**Closed issues:**

- invalid parameter target [\#128](https://github.com/voxpupuli/puppet-unbound/issues/128)

**Merged pull requests:**

- Remove dependency cycle when skip\_roothints\_download is true [\#131](https://github.com/voxpupuli/puppet-unbound/pull/131) ([drt24](https://github.com/drt24))
- Set hints permissions after download [\#130](https://github.com/voxpupuli/puppet-unbound/pull/130) ([claytono](https://github.com/claytono))
- White space fix for puppet-lint [\#127](https://github.com/voxpupuli/puppet-unbound/pull/127) ([mld](https://github.com/mld))
- Add ability to set cache settings as parameters [\#124](https://github.com/voxpupuli/puppet-unbound/pull/124) ([jaxxstorm](https://github.com/jaxxstorm))

## [1.3.5](https://github.com/voxpupuli/puppet-unbound/tree/1.3.5) (2016-06-06)

[Full Changelog](https://github.com/voxpupuli/puppet-unbound/compare/1.3.4...1.3.5)

**Closed issues:**

- harden-dnssec-stripped parameter is not controlled [\#108](https://github.com/voxpupuli/puppet-unbound/issues/108)

**Merged pull requests:**

- Fix template variable reference [\#123](https://github.com/voxpupuli/puppet-unbound/pull/123) ([xaque208](https://github.com/xaque208))
- booleans: allow to actually toggle the booleans [\#122](https://github.com/voxpupuli/puppet-unbound/pull/122) ([igalic](https://github.com/igalic))

## [1.3.4](https://github.com/voxpupuli/puppet-unbound/tree/1.3.4) (2016-04-14)

[Full Changelog](https://github.com/voxpupuli/puppet-unbound/compare/1.3.3...1.3.4)

**Merged pull requests:**

- fix extended\_statistics setting [\#121](https://github.com/voxpupuli/puppet-unbound/pull/121) ([mmckinst](https://github.com/mmckinst))

## [1.3.3](https://github.com/voxpupuli/puppet-unbound/tree/1.3.3) (2016-04-09)

[Full Changelog](https://github.com/voxpupuli/puppet-unbound/compare/1.3.2...1.3.3)

**Merged pull requests:**

- Default behavior for unbound::remote isn't well documented [\#120](https://github.com/voxpupuli/puppet-unbound/pull/120) ([cPanelScott](https://github.com/cPanelScott))

## [1.3.2](https://github.com/voxpupuli/puppet-unbound/tree/1.3.2) (2016-04-04)

[Full Changelog](https://github.com/voxpupuli/puppet-unbound/compare/1.3.1...1.3.2)

**Merged pull requests:**

- Update test matrix to exclude duplicate build [\#119](https://github.com/voxpupuli/puppet-unbound/pull/119) ([xaque208](https://github.com/xaque208))

## [1.3.1](https://github.com/voxpupuli/puppet-unbound/tree/1.3.1) (2016-04-01)

[Full Changelog](https://github.com/voxpupuli/puppet-unbound/compare/1.3.0...1.3.1)

**Merged pull requests:**

- Implemnet metadata lint during testing [\#118](https://github.com/voxpupuli/puppet-unbound/pull/118) ([xaque208](https://github.com/xaque208))

## [1.3.0](https://github.com/voxpupuli/puppet-unbound/tree/1.3.0) (2016-04-01)

[Full Changelog](https://github.com/voxpupuli/puppet-unbound/compare/1.2.2...1.3.0)

**Closed issues:**

- hiera example is not documented [\#110](https://github.com/voxpupuli/puppet-unbound/issues/110)

**Merged pull requests:**

- Puppet4 [\#117](https://github.com/voxpupuli/puppet-unbound/pull/117) ([xaque208](https://github.com/xaque208))

## [1.2.2](https://github.com/voxpupuli/puppet-unbound/tree/1.2.2) (2016-02-22)

[Full Changelog](https://github.com/voxpupuli/puppet-unbound/compare/1.2.1...1.2.2)

**Closed issues:**

- unable to load puppet\_x/unbound/validate\_addrs \(on puppetserver\) [\#105](https://github.com/voxpupuli/puppet-unbound/issues/105)

**Merged pull requests:**

-  Convert config\_file to a definition parameter [\#114](https://github.com/voxpupuli/puppet-unbound/pull/114) ([sbadia](https://github.com/sbadia))
- Added missing option in the configuration: so\_sndbuf [\#113](https://github.com/voxpupuli/puppet-unbound/pull/113) ([marknl](https://github.com/marknl))
- using https to download named.root [\#112](https://github.com/voxpupuli/puppet-unbound/pull/112) ([mmckinst](https://github.com/mmckinst))
- Add hiera support for define resources [\#111](https://github.com/voxpupuli/puppet-unbound/pull/111) ([Rocco83](https://github.com/Rocco83))
- Allow to pass action with $access [\#109](https://github.com/voxpupuli/puppet-unbound/pull/109) ([sileht](https://github.com/sileht))

## [1.2.1](https://github.com/voxpupuli/puppet-unbound/tree/1.2.1) (2015-12-19)

[Full Changelog](https://github.com/voxpupuli/puppet-unbound/compare/1.2.0...1.2.1)

**Closed issues:**

- Option not to use/download root.hints [\#103](https://github.com/voxpupuli/puppet-unbound/issues/103)
- Stub addresses are generated as hostnames in config [\#102](https://github.com/voxpupuli/puppet-unbound/issues/102)

**Merged pull requests:**

- Use the relative path for loading puppet\_x [\#107](https://github.com/voxpupuli/puppet-unbound/pull/107) ([xaque208](https://github.com/xaque208))
- Add feature skip\_roothints\_download [\#106](https://github.com/voxpupuli/puppet-unbound/pull/106) ([mrdima](https://github.com/mrdima))

## [1.2.0](https://github.com/voxpupuli/puppet-unbound/tree/1.2.0) (2015-07-29)

[Full Changelog](https://github.com/voxpupuli/puppet-unbound/compare/1.1.8...1.2.0)

**Merged pull requests:**

- Begin replacing unbound::stub address validation [\#104](https://github.com/voxpupuli/puppet-unbound/pull/104) ([xaque208](https://github.com/xaque208))
- Exec calls should have a full path. [\#72](https://github.com/voxpupuli/puppet-unbound/pull/72) ([robbat2](https://github.com/robbat2))

## [1.1.8](https://github.com/voxpupuli/puppet-unbound/tree/1.1.8) (2015-07-28)

[Full Changelog](https://github.com/voxpupuli/puppet-unbound/compare/1.1.7...1.1.8)

**Closed issues:**

- Wrong unbound-checkconf path for Centos and Scientific 6 [\#99](https://github.com/voxpupuli/puppet-unbound/issues/99)

**Merged pull requests:**

- Fix dependencies when using unbound::remote [\#101](https://github.com/voxpupuli/puppet-unbound/pull/101) ([claytono](https://github.com/claytono))

## [1.1.7](https://github.com/voxpupuli/puppet-unbound/tree/1.1.7) (2015-07-22)

[Full Changelog](https://github.com/voxpupuli/puppet-unbound/compare/1.1.6-ICANN-3...1.1.7)

**Merged pull requests:**

- Set correct checkconf on EL platforms [\#100](https://github.com/voxpupuli/puppet-unbound/pull/100) ([xaque208](https://github.com/xaque208))
- Multiple addressess/hosts for stub zones [\#98](https://github.com/voxpupuli/puppet-unbound/pull/98) ([rswarts](https://github.com/rswarts))
- Freebsd 10 [\#97](https://github.com/voxpupuli/puppet-unbound/pull/97) ([b4ldr](https://github.com/b4ldr))
- Change scope of params [\#96](https://github.com/voxpupuli/puppet-unbound/pull/96) ([b4ldr](https://github.com/b4ldr))

## [1.1.6-ICANN-3](https://github.com/voxpupuli/puppet-unbound/tree/1.1.6-ICANN-3) (2015-07-03)

[Full Changelog](https://github.com/voxpupuli/puppet-unbound/compare/1.1.6-ICANN-2...1.1.6-ICANN-3)

## [1.1.6-ICANN-2](https://github.com/voxpupuli/puppet-unbound/tree/1.1.6-ICANN-2) (2015-07-03)

[Full Changelog](https://github.com/voxpupuli/puppet-unbound/compare/1.1.6-ICANN...1.1.6-ICANN-2)

## [1.1.6-ICANN](https://github.com/voxpupuli/puppet-unbound/tree/1.1.6-ICANN) (2015-07-03)

[Full Changelog](https://github.com/voxpupuli/puppet-unbound/compare/1.1.6...1.1.6-ICANN)

**Closed issues:**

- We should manage the permissions of /var/unbound/etc so that the root.key can be written by the unbound user. [\#32](https://github.com/voxpupuli/puppet-unbound/issues/32)

## [1.1.6](https://github.com/voxpupuli/puppet-unbound/tree/1.1.6) (2015-06-29)

[Full Changelog](https://github.com/voxpupuli/puppet-unbound/compare/1.1.5...1.1.6)

**Closed issues:**

- Concat 2.x deletion [\#92](https://github.com/voxpupuli/puppet-unbound/issues/92)
- Missing support for hide\_identity/hide\_version [\#90](https://github.com/voxpupuli/puppet-unbound/issues/90)
- Default interfaces on multi-homed servers [\#12](https://github.com/voxpupuli/puppet-unbound/issues/12)

**Merged pull requests:**

- stub: local-zones have multiple types; allow type to be overwritten [\#94](https://github.com/voxpupuli/puppet-unbound/pull/94) ([kmullin](https://github.com/kmullin))
- Bring back hide\_version and hide\_identity [\#93](https://github.com/voxpupuli/puppet-unbound/pull/93) ([kmullin](https://github.com/kmullin))
- default port 8953 for remote-control [\#91](https://github.com/voxpupuli/puppet-unbound/pull/91) ([ghost](https://github.com/ghost))
- add forward-first option for forward zones. [\#87](https://github.com/voxpupuli/puppet-unbound/pull/87) ([ryanfolsom](https://github.com/ryanfolsom))

## [1.1.5](https://github.com/voxpupuli/puppet-unbound/tree/1.1.5) (2015-06-03)

[Full Changelog](https://github.com/voxpupuli/puppet-unbound/compare/1.1.4...1.1.5)

## [1.1.4](https://github.com/voxpupuli/puppet-unbound/tree/1.1.4) (2015-05-29)

[Full Changelog](https://github.com/voxpupuli/puppet-unbound/compare/1.0.0-ICANN...1.1.4)

**Closed issues:**

- Make it strict\_variables-safe [\#76](https://github.com/voxpupuli/puppet-unbound/issues/76)
- Get some Fu\*ing spec tests. [\#73](https://github.com/voxpupuli/puppet-unbound/issues/73)

**Merged pull requests:**

- Some light fixes after recent merge [\#89](https://github.com/voxpupuli/puppet-unbound/pull/89) ([xaque208](https://github.com/xaque208))
- stub-zone could be specified with either ip or hostname [\#88](https://github.com/voxpupuli/puppet-unbound/pull/88) ([ghost](https://github.com/ghost))
- Pin repo versions to aim for determinism [\#85](https://github.com/voxpupuli/puppet-unbound/pull/85) ([xaque208](https://github.com/xaque208))
- restart unbound without starting and stoping the daemon [\#84](https://github.com/voxpupuli/puppet-unbound/pull/84) ([f0](https://github.com/f0))
- Fix broken commit [\#82](https://github.com/voxpupuli/puppet-unbound/pull/82) ([xaque208](https://github.com/xaque208))
- Use the master branches status as build indicator [\#81](https://github.com/voxpupuli/puppet-unbound/pull/81) ([xaque208](https://github.com/xaque208))
- RedHat does not install wget by default, but curl is available [\#79](https://github.com/voxpupuli/puppet-unbound/pull/79) ([robinbowes](https://github.com/robinbowes))
- Set correct runtime dir [\#78](https://github.com/voxpupuli/puppet-unbound/pull/78) ([robinbowes](https://github.com/robinbowes))
- Make it work with strict variables [\#77](https://github.com/voxpupuli/puppet-unbound/pull/77) ([robinbowes](https://github.com/robinbowes))
- Use str2bool so always-string data from hiera can still be used as if it... [\#75](https://github.com/voxpupuli/puppet-unbound/pull/75) ([rswarts](https://github.com/rswarts))
- Begin spec testing [\#74](https://github.com/voxpupuli/puppet-unbound/pull/74) ([xaque208](https://github.com/xaque208))
- Ensure local-zone is always under server. [\#71](https://github.com/voxpupuli/puppet-unbound/pull/71) ([robbat2](https://github.com/robbat2))
- Updates to trust anchoring [\#67](https://github.com/voxpupuli/puppet-unbound/pull/67) ([b4ldr](https://github.com/b4ldr))

## [1.0.0-ICANN](https://github.com/voxpupuli/puppet-unbound/tree/1.0.0-ICANN) (2015-02-05)

[Full Changelog](https://github.com/voxpupuli/puppet-unbound/compare/1.1.3...1.0.0-ICANN)

**Merged pull requests:**

- create directory before exec [\#68](https://github.com/voxpupuli/puppet-unbound/pull/68) ([f3rr](https://github.com/f3rr))
- Run unbound-control-setup, in order to create the certificates [\#66](https://github.com/voxpupuli/puppet-unbound/pull/66) ([buzzdeee](https://github.com/buzzdeee))
- Add custom\_server\_conf configuration option [\#64](https://github.com/voxpupuli/puppet-unbound/pull/64) ([cure](https://github.com/cure))
- Some minor adjustments for OpenBSD 5.6 [\#63](https://github.com/voxpupuli/puppet-unbound/pull/63) ([xaque208](https://github.com/xaque208))

## [1.1.3](https://github.com/voxpupuli/puppet-unbound/tree/1.1.3) (2014-10-19)

[Full Changelog](https://github.com/voxpupuli/puppet-unbound/compare/1.1.2...1.1.3)

## [1.1.2](https://github.com/voxpupuli/puppet-unbound/tree/1.1.2) (2014-10-18)

[Full Changelog](https://github.com/voxpupuli/puppet-unbound/compare/1.1.1...1.1.2)

## [1.1.1](https://github.com/voxpupuli/puppet-unbound/tree/1.1.1) (2014-10-18)

[Full Changelog](https://github.com/voxpupuli/puppet-unbound/compare/1.1.0...1.1.1)

**Closed issues:**

- Make a new puppetforge release? [\#55](https://github.com/voxpupuli/puppet-unbound/issues/55)

**Merged pull requests:**

- Roll some blacksmith using the skeleton data [\#61](https://github.com/voxpupuli/puppet-unbound/pull/61) ([xaque208](https://github.com/xaque208))
- Clean up some newline issues [\#59](https://github.com/voxpupuli/puppet-unbound/pull/59) ([xaque208](https://github.com/xaque208))
- Fix syntax error in templates/forward.erb [\#57](https://github.com/voxpupuli/puppet-unbound/pull/57) ([cure](https://github.com/cure))
- add metadata.json \(before new release\) [\#56](https://github.com/voxpupuli/puppet-unbound/pull/56) ([igalic](https://github.com/igalic))
- rebase of pull 44 [\#54](https://github.com/voxpupuli/puppet-unbound/pull/54) ([b4ldr](https://github.com/b4ldr))
- make unbound module future parser compatible [\#53](https://github.com/voxpupuli/puppet-unbound/pull/53) ([buzzdeee](https://github.com/buzzdeee))
- Add support for OpenBSD 5.6 and future,  [\#52](https://github.com/voxpupuli/puppet-unbound/pull/52) ([buzzdeee](https://github.com/buzzdeee))
- Update dependency to puppetlabs/concat in Readme.md [\#51](https://github.com/voxpupuli/puppet-unbound/pull/51) ([buzzdeee](https://github.com/buzzdeee))
- add hide\_identity and hide\_version parameters, and update the [\#50](https://github.com/voxpupuli/puppet-unbound/pull/50) ([buzzdeee](https://github.com/buzzdeee))
- OpenBSD has ftp and not fetch to retrieve files. [\#49](https://github.com/voxpupuli/puppet-unbound/pull/49) ([buzzdeee](https://github.com/buzzdeee))

## [1.1.0](https://github.com/voxpupuli/puppet-unbound/tree/1.1.0) (2014-08-27)

[Full Changelog](https://github.com/voxpupuli/puppet-unbound/compare/1.0.0...1.1.0)

**Merged pull requests:**

- Update test files to pass lint [\#48](https://github.com/voxpupuli/puppet-unbound/pull/48) ([xaque208](https://github.com/xaque208))
- OS specific client to fetch root hints and edns buffer size option [\#45](https://github.com/voxpupuli/puppet-unbound/pull/45) ([b4ldr](https://github.com/b4ldr))
- Add support for the prefetch-key option. [\#43](https://github.com/voxpupuli/puppet-unbound/pull/43) ([daenney](https://github.com/daenney))
- Allow forwarding  reverse DNS queries for the default local zones.  [\#42](https://github.com/voxpupuli/puppet-unbound/pull/42) ([dsolsona](https://github.com/dsolsona))
- Change concat module dependency. [\#41](https://github.com/voxpupuli/puppet-unbound/pull/41) ([cure](https://github.com/cure))
- Add control over tcp-upstream [\#39](https://github.com/voxpupuli/puppet-unbound/pull/39) ([inkblot](https://github.com/inkblot))
- Adding extra options for optimizing unbound [\#38](https://github.com/voxpupuli/puppet-unbound/pull/38) ([dsolsona](https://github.com/dsolsona))

## [1.0.0](https://github.com/voxpupuli/puppet-unbound/tree/1.0.0) (2014-01-11)

[Full Changelog](https://github.com/voxpupuli/puppet-unbound/compare/0.0.5...1.0.0)

**Closed issues:**

- extraneous comma in forward.pp [\#17](https://github.com/voxpupuli/puppet-unbound/issues/17)

**Merged pull requests:**

- Add syntax highlighting for documentation [\#36](https://github.com/voxpupuli/puppet-unbound/pull/36) ([igalic](https://github.com/igalic))
- unbound header is out of order with concat setup [\#35](https://github.com/voxpupuli/puppet-unbound/pull/35) ([igalic](https://github.com/igalic))
- using "name" as parameter in types makes life difficult [\#34](https://github.com/voxpupuli/puppet-unbound/pull/34) ([igalic](https://github.com/igalic))
- enable simple creation of reverse entries [\#33](https://github.com/voxpupuli/puppet-unbound/pull/33) ([igalic](https://github.com/igalic))
- \(maint\) Add Travis CI testing [\#31](https://github.com/voxpupuli/puppet-unbound/pull/31) ([xaque208](https://github.com/xaque208))
- use correct owner variable [\#30](https://github.com/voxpupuli/puppet-unbound/pull/30) ([mmoll](https://github.com/mmoll))
- \(maint\) Change parameter names and cleanup [\#29](https://github.com/voxpupuli/puppet-unbound/pull/29) ([xaque208](https://github.com/xaque208))

## [0.0.5](https://github.com/voxpupuli/puppet-unbound/tree/0.0.5) (2013-12-13)

[Full Changelog](https://github.com/voxpupuli/puppet-unbound/compare/0.0.4...0.0.5)

## [0.0.4](https://github.com/voxpupuli/puppet-unbound/tree/0.0.4) (2013-12-12)

[Full Changelog](https://github.com/voxpupuli/puppet-unbound/compare/0.0.3...0.0.4)

**Closed issues:**

- Missing: LICENSE [\#11](https://github.com/voxpupuli/puppet-unbound/issues/11)
- Root hints [\#7](https://github.com/voxpupuli/puppet-unbound/issues/7)

**Merged pull requests:**

- \(maint\) Add OpenBSD support [\#27](https://github.com/voxpupuli/puppet-unbound/pull/27) ([xaque208](https://github.com/xaque208))
- \(maint\) Mostly pass lint [\#26](https://github.com/voxpupuli/puppet-unbound/pull/26) ([xaque208](https://github.com/xaque208))
- Make sure unbound can read the root.hints file [\#25](https://github.com/voxpupuli/puppet-unbound/pull/25) ([michakrause](https://github.com/michakrause))
- fix typo in template [\#24](https://github.com/voxpupuli/puppet-unbound/pull/24) ([mbakke](https://github.com/mbakke))
- Add option to enable extended statistics [\#23](https://github.com/voxpupuli/puppet-unbound/pull/23) ([bisscuitt](https://github.com/bisscuitt))
- Adding change so make usage of ipv4 and ipv6 explicit if need be.  Both ... [\#22](https://github.com/voxpupuli/puppet-unbound/pull/22) ([jrodriguezjr](https://github.com/jrodriguezjr))
- Adding change so make usage of ipv4 and ipv6 explicit.  Both are enabled... [\#20](https://github.com/voxpupuli/puppet-unbound/pull/20) ([jrodriguezjr](https://github.com/jrodriguezjr))
- Removed call to concat::setup as concat module has made this private [\#19](https://github.com/voxpupuli/puppet-unbound/pull/19) ([growse](https://github.com/growse))
- Fix template variables by prefixing @ [\#18](https://github.com/voxpupuli/puppet-unbound/pull/18) ([dkerwin](https://github.com/dkerwin))
- Add ability to specify port which unbound listens on [\#16](https://github.com/voxpupuli/puppet-unbound/pull/16) ([growse](https://github.com/growse))
- Fix typos in config file template for infra-host-ttl [\#13](https://github.com/voxpupuli/puppet-unbound/pull/13) ([nicwaller](https://github.com/nicwaller))
- Added infra-host-ttl option  [\#10](https://github.com/voxpupuli/puppet-unbound/pull/10) ([rlex](https://github.com/rlex))
- Automatically install and configure DNS root hints [\#9](https://github.com/voxpupuli/puppet-unbound/pull/9) ([nicwaller](https://github.com/nicwaller))
- Added notes about concat dependency [\#8](https://github.com/voxpupuli/puppet-unbound/pull/8) ([nicwaller](https://github.com/nicwaller))

## [0.0.3](https://github.com/voxpupuli/puppet-unbound/tree/0.0.3) (2013-04-22)

[Full Changelog](https://github.com/voxpupuli/puppet-unbound/compare/0.0.2...0.0.3)

**Merged pull requests:**

- Features/dnsrecord [\#5](https://github.com/voxpupuli/puppet-unbound/pull/5) ([rlex](https://github.com/rlex))
- Features/forward zones [\#3](https://github.com/voxpupuli/puppet-unbound/pull/3) ([rlex](https://github.com/rlex))
- Support for RHEL [\#2](https://github.com/voxpupuli/puppet-unbound/pull/2) ([nono-gdv](https://github.com/nono-gdv))

## [0.0.2](https://github.com/voxpupuli/puppet-unbound/tree/0.0.2) (2012-11-16)

[Full Changelog](https://github.com/voxpupuli/puppet-unbound/compare/0.0.1...0.0.2)

## [0.0.1](https://github.com/voxpupuli/puppet-unbound/tree/0.0.1) (2012-03-25)

[Full Changelog](https://github.com/voxpupuli/puppet-unbound/compare/683dcdf58fe594b98f1f6aa5d0549a9775795437...0.0.1)



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
