# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'unbound class' do
  describe 'running puppet code' do
    it 'work with no errors' do
      pp = "class {'unbound': }"
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
    describe command('dig +dnssec . soa @localhost') do
      its(:stdout) { is_expected.to match %r{\.\s+\d+\s+IN\s+SOA\s+a\.root-servers\.net\.\snstld\.verisign-grs\.com\.\s\d+\s1800\s900\s604800\s86400} }
      its(:stdout) { is_expected.to match %r{flags: qr rd ra ad;} }
    end
    describe command('dig +dnssec . soa @localhost') do
      its(:stdout) { is_expected.to match %r{\.\s+\d+\s+IN\s+SOA\s+a\.root-servers\.net\.\snstld\.verisign-grs\.com\.\s\d+\s1800\s900\s604800\s86400} }
      its(:stdout) { is_expected.to match %r{\.\s+\d+\s+IN\s+RRSIG\s+SOA} }
      its(:stdout) { is_expected.to match %r{flags: qr rd ra ad;} }
    end
    describe command('dig +dnssec SOA dnssec-failed.org @localhost') do
      its(:stdout) { is_expected.to match %r{status: SERVFAIL} }
    end
    describe command('dig +dnssec +cd SOA dnssec-failed.org @localhost') do
      its(:stdout) { is_expected.to match %r{status: NOERROR} }
    end
  end
end
