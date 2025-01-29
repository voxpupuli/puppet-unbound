# frozen_string_literal: true

require 'spec_helper'

describe 'unbound::dnstap' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts.merge(concat_basedir: '/dne', unbound_version: '1.21.0') }

      case os_facts[:os]['family']
      when 'FreeBSD'
        let(:config_file) { '/usr/local/etc/unbound/unbound.conf' }
      when 'OpenBSD'
        let(:config_file) { '/var/unbound/etc/unbound.conf' }
      else
        let(:config_file) { '/etc/unbound/unbound.conf' }
      end

      context 'with disabled params' do
        let(:params) { { enable: false } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('unbound::dnstap') }
        it { is_expected.not_to contain_concat__fragment('unbound-dnstap') }
      end

      context 'with enable and socket' do
        let(:params) { { socket_path: '/var/run/dnstap.sock' } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('unbound::dnstap') }

        it do
          is_expected.to contain_concat__fragment('unbound-dnstap').with_content(
            %r{
              ^dnstap:
              \s+dnstap-enable:\syes
              \s+dnstap-bidirectional:\syes
              \s+dnstap-socket-path:\s"/var/run/dnstap.sock"
              \s+dnstap-send-identity:\sno
              \s+dnstap-send-version:\sno
              \s+dnstap-sample-rate:\s0
              \s+dnstap-log-resolver-query-messages:\sno
              \s+dnstap-log-resolver-response-messages:\sno
              \s+dnstap-log-client-query-messages:\sno
              \s+dnstap-log-client-response-messages:\sno
              \s+dnstap-log-forwarder-query-messages:\sno
              \s+dnstap-log-forwarder-response-messages:\sno
            }x
          )
        end
      end

      context 'with enable and ip' do
        let(:params) { { ip: '192.0.2.1' } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('unbound::dnstap') }

        it do
          is_expected.to contain_concat__fragment('unbound-dnstap').with_content(
            %r{
              ^dnstap:
              \s+dnstap-enable:\syes
              \s+dnstap-bidirectional:\syes
              \s+dnstap-ip:\s"192\.0\.2\.1"
              \s+dnstap-tls:\syes
              \s+dnstap-send-identity:\sno
              \s+dnstap-send-version:\sno
              \s+dnstap-sample-rate:\s0
              \s+dnstap-log-resolver-query-messages:\sno
              \s+dnstap-log-resolver-response-messages:\sno
              \s+dnstap-log-client-query-messages:\sno
              \s+dnstap-log-client-response-messages:\sno
              \s+dnstap-log-forwarder-query-messages:\sno
              \s+dnstap-log-forwarder-response-messages:\sno
            }x
          )
        end

        context 'with tls_host' do
          let(:params) { super().merge(tls_host: 'dnstap.example.com') }

          it do
            is_expected.to contain_concat__fragment('unbound-dnstap').with_content(
              %r{^  dnstap-tls-host:\s"dnstap.example.com"}
            )
          end
        end

        context 'with tls_cert_bundle' do
          let(:params) { super().merge(tls_cert_bundle: '/etc/ssl/cert.pem') }

          it do
            is_expected.to contain_concat__fragment('unbound-dnstap').with_content(
              %r{^  dnstap-tls-cert-bundle:\s"/etc/ssl/cert.pem"}
            )
          end
        end

        context 'with tls_cert_key_file' do
          let(:params) { super().merge(tls_cert_key_file: '/etc/ssl/key.pem') }

          it do
            is_expected.to contain_concat__fragment('unbound-dnstap').with_content(
              %r{^  dnstap-tls-cert-key-file:\s"/etc/ssl/key.pem"}
            )
          end
        end

        context 'with tls_cert_cert_file' do
          let(:params) { super().merge(tls_cert_cert_file: '/etc/ssl/cert.pem') }

          it do
            is_expected.to contain_concat__fragment('unbound-dnstap').with_content(
              %r{^  dnstap-tls-cert-cert-file:\s"/etc/ssl/cert.pem"}
            )
          end
        end
      end
    end
  end
end
