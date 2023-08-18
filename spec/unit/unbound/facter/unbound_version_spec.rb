# frozen_string_literal: true

require 'spec_helper'

version_string = <<~VERSION
  unbound: invalid option -- 'V'
  usage:  unbound [options]
          start unbound daemon DNS resolver.
  -h      this help
  -c file config file to read instead of /etc/unbound/unbound.conf
          file format is described in unbound.conf(5).
  -d      do not fork into the background.
  -v      verbose (more times to increase verbosity)
  Version %s
  linked libs: libevent 2.0.21-stable (it uses epoll), OpenSSL 1.1.0l  10 Sep 2019
  linked modules: dns64 python validator iterator
  BSD licensed, see LICENSE in source package for details.
  Report bugs to unbound-bugs@nlnetlabs.nl
VERSION

tests = {
  'valid' => ['1.1.1', '1.90.24', '1.0.404', '2.5.6'],
  'invalid' => ['1', '1.1', '1.1.1.1', '1,1,1', '2:5.1', 'foobar']
}
describe Facter::Util::Fact.to_s do
  before { Facter.clear }

  context 'unbound not in path' do
    before do
      allow(Facter::Util::Resolution).to receive(:which).with('unbound').and_return(false)
    end

    it { expect(Facter.fact(:unbound_version).value).to be_nil }
  end

  tests.each_pair do |test, versions|
    describe "test #{test} versions" do
      before do
        allow(Facter::Util::Resolution).to receive(:which).with('unbound').and_return(true)
      end

      versions.each do |version|
        context "test version #{version}" do
          before do
            allow(Facter::Util::Resolution).to receive(:exec).with('unbound -V 2>&1') do
              version_string % version
            end
          end

          if test == 'valid'
            it { expect(Facter.fact(:unbound_version).value).to eq(version) }
          else
            it { expect(Facter.fact(:unbound_version).value).to be_nil }
          end
        end
      end
    end
  end
end
