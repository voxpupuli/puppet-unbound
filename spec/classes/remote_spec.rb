# frozen_string_literal: true

require 'spec_helper'

describe 'unbound::remote' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts.merge(concat_basedir: '/dne', unbound_version: '1.21.0') }
      let(:params) do
        {
          enable: false,
          server_key_file: '/etc/unbound/unbound_server.key',
          server_cert_file: '/etc/unbound/unbound_server.pem',
          control_key_file: '/etc/unbound/unbound_control.key',
          control_cert_file: '/etc/unbound/unbound_control.pem',
          group: 'unbound',
          confdir: '/etc/unbound',
          config_file: '/etc/unbound/unbound.conf',
          control_setup_path: '/usr/sbin/unbound-control-setup',
        }
      end

      context 'with disabled params' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('unbound::remote') }

        it do
          is_expected.to contain_concat__fragment('unbound-remote').with_content(
            %r{
              ^remote-control:
              \s+control-enable:\sno
              \s+control-interface:\s::1
              \s+control-interface:\s127.0.0.1
              \s+control-port:\s8953
              \s+server-key-file:\s/etc/unbound/unbound_server.key
              \s+server-cert-file:\s/etc/unbound/unbound_server.pem
              \s+control-key-file:\s/etc/unbound/unbound_control.key
              \s+control-cert-file:\s/etc/unbound/unbound_control.pem
            }x
          )
        end

        it { is_expected.to contain_exec('unbound-control-setup') }

        %w[server.key server.pem control.key control.pem].each do |file|
          it { is_expected.to contain_file("/etc/unbound/unbound_#{file}") }
        end
      end

      context 'with enable true' do
        let(:params) { super().merge(enable: true) }

        it do
          is_expected.to contain_concat__fragment('unbound-remote').with_content(
            %r{control-enable:\syes}
          )
        end
      end

      context 'with control_interface' do
        let(:params) { super().merge(interface: ['192.0.2.42']) }

        it do
          is_expected.to contain_concat__fragment('unbound-remote').with_content(
            %r{control-interface:\s192.0.2.42}
          )
        end
      end

      context 'with control_use_cert false' do
        let(:params) { super().merge(control_use_cert: false) }

        it do
          is_expected.to contain_concat__fragment('unbound-remote').
            without_content(%r{(server|control)-(key|cert)-file})
        end
      end
    end
  end
end
