# frozen_string_literal: true

require 'spec_helper_acceptance'
if fact('osfamily') == 'FreeBSD'
  apply_manifest("package{'dns/bind-tools': ensure => 'present'}")
else
  if fact('osfamily') == 'RedHat'
    apply_manifest("package{'bind-utils': ensure => 'present'}")
  else
    apply_manifest("package{'dnsutils': ensure => 'present'}")
  end

  shell('sysctl net.ipv6.conf.all.disable_ipv6=0')
end
describe 'unbound class' do
  describe 'running puppet code' do
    it 'work with no errors' do
      pp = "class {'unbound': verbosity => 5, logfile => '/tmp/unbound.log'}"
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_failures: true)
      expect(apply_manifest(pp, catch_failures: true).exit_code).to eq 0
    end
    describe command('service unbound restart') do
      its(:exit_status) { is_expected.to eq 0 }
    end
    describe service('unbound') do
      it { is_expected.to be_running }
    end
    describe port(53) do
      it { is_expected.to be_listening }
    end
    describe command('dig +tcp +dnssec -t SOA dnssec-failed.org @127.0.0.1') do
      its(:stdout) { is_expected.to match %r{status: SERVFAIL} }
    end
    describe command('dig +dnssec +cd -t SOA dnssec-failed.org @127.0.0.1') do
      its(:stdout) { is_expected.to match %r{status: NOERROR} }
    end
  end
end
