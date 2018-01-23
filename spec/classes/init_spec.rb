require 'spec_helper'

describe 'unbound' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts.merge(concat_basedir: '/dne') }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('unbound') }

      # Check the default options are left undef and out of the resulting fragment
      it { is_expected.to contain_concat__fragment('unbound-header') }
      it { is_expected.not_to contain_concat__fragment('unbound-header').with_content(%r{infra-cache-slabs}) }
      it { is_expected.not_to contain_concat__fragment('unbound-header').with_content(%r{key-cache-slabs}) }
      it { is_expected.not_to contain_concat__fragment('unbound-header').with_content(%r{msg-cache-slabs}) }
      it { is_expected.not_to contain_concat__fragment('unbound-header').with_content(%r{rrset-cache-slabs}) }
      it { is_expected.not_to contain_concat__fragment('unbound-header').with_content(%r{num-queries-per-thread}) }

      case facts[:osfamily]
      when 'Debian'
        it { is_expected.to contain_package('unbound') }
        it { is_expected.to contain_service('unbound') }
        it { is_expected.to contain_concat('/etc/unbound/unbound.conf') }
        it { is_expected.to contain_file('/etc/unbound') }
        it { is_expected.to contain_file('/etc/unbound/conf.d') }
        it { is_expected.to contain_file('/etc/unbound/keys.d') }
        it { is_expected.to contain_file('/etc/unbound/root.hints') }

      when 'RedHat'
        it { is_expected.to contain_package('unbound') }
        it { is_expected.to contain_service('unbound') }
        it { is_expected.to contain_concat('/etc/unbound/unbound.conf') }
        it { is_expected.to contain_file('/etc/unbound') }
        it { is_expected.to contain_file('/etc/unbound/conf.d') }
        it { is_expected.to contain_file('/etc/unbound/keys.d') }
        it { is_expected.to contain_file('/etc/unbound/root.hints') }

      when 'OpenBSD'
        it { is_expected.not_to contain_package('unbound') }
        it { is_expected.to contain_service('unbound') }
        it { is_expected.to contain_concat('/var/unbound/etc/unbound.conf') }
        it { is_expected.to contain_file('/var/unbound/etc') }
        it { is_expected.to contain_file('/var/unbound/etc/conf.d') }
        it { is_expected.to contain_file('/var/unbound/etc/keys.d') }
        it { is_expected.to contain_file('/var/unbound/etc/root.hints') }

      when 'FreeBSD'
        it { is_expected.to contain_package('unbound') }
        it { is_expected.to contain_service('unbound') }
        it { is_expected.to contain_concat('/usr/local/etc/unbound/unbound.conf') }
        it { is_expected.to contain_file('/usr/local/etc/unbound') }
        it { is_expected.to contain_file('/usr/local/etc/unbound/conf.d') }
        it { is_expected.to contain_file('/usr/local/etc/unbound/keys.d') }
        it { is_expected.to contain_file('/usr/local/etc/unbound/root.hints') }

      end

      context 'with modified access' do
        let(:params) do
          {
            access: ['10.21.30.0/24 allow', '10.21.30.5/32 reject', '127.0.0.1/32 allow_snoop', '123.123.123.0/20']
          }
        end

        it { is_expected.to contain_class('concat::setup') }
        it do
          is_expected.to contain_concat__fragment('unbound-header').with_content(
            %r{^  access-control: 10.21.30.0\/24 allow\n  access-control: 10.21.30.5\/32 reject\n  access-control: 127.0.0.1\/32 allow_snoop\n  access-control: 123.123.123.0\/20 allow}
          )
        end
      end

      context 'with a different config file' do
        let(:params) { { config_file: '/etc/unbound/unbound.conf.d/foobar.conf' } }
        it { is_expected.to contain_concat('/etc/unbound/unbound.conf.d/foobar.conf') }
      end

      context 'stub passed to class' do
        let(:params) do
          {
            stub: { 'example-stub.com' => { 'address' => ['10.0.0.1', '10.0.0.2'], 'insecure' => 'true' } }
          }
        end
        it { is_expected.to contain_class('concat::setup') }
        it do
          is_expected.to contain_concat__fragment('unbound-stub-example-stub.com').with_content(
            %r{^stub-zone:\n  name: "example-stub.com"\n  stub-addr: 10.0.0.1\n  stub-addr: 10.0.0.2}
          )
        end
      end

      context 'forward passed to class' do
        let(:params) do
          {
            forward: { 'example-forward.com' => { 'address' => ['10.0.0.1', '10.0.0.2'], 'forward_first' => 'yes' } }
          }
        end
        it { is_expected.to contain_class('concat::setup') }
        it do
          is_expected.to contain_concat__fragment('unbound-forward-example-forward.com').with_content(
            %r{^forward-zone:\n  name: "example-forward.com"\n  forward-addr: 10.0.0.1\n  forward-addr: 10.0.0.2\n  forward-first: yes}
          )
        end
      end

      context 'local_zone passed to class' do
        let(:params) do
          {
            domain_insecure: ['0.0.10.in-addr.arpa.', 'example.com.']
          }
        end
        it { is_expected.to contain_class('concat::setup') }
        it do
          is_expected.to contain_concat__fragment('unbound-header').with_content(
            %r{^\s+domain-insecure: "0.0.10.in-addr.arpa."$}
          ).with_content(
            %r{^\s+domain-insecure: "example.com."$}
          )
        end
      end

      context 'local_zone passed to class' do
        let(:params) do
          {
            local_zone: { '0.0.10.in-addr.arpa.' => 'nodefault' }
          }
        end
        it { is_expected.to contain_class('concat::setup') }
        it do
          is_expected.to contain_concat__fragment('unbound-header').with_content(
            %r{^\s+local-zone: "0.0.10.in-addr.arpa." nodefault$}
          )
        end
      end

      context 'custom extended_statistics passed to class' do
        let(:params) do
          {
            extended_statistics: true
          }
        end
        it { is_expected.to contain_class('concat::setup') }
        it do
          is_expected.to contain_concat__fragment('unbound-header').with_content(
            %r{^  extended-statistics: yes\n}
          )
        end
      end

      context 'platform control enablement' do
        let(:params) do
          {
            control_enable: true
          }
        end
        it { is_expected.to contain_class('unbound::remote') }
        it { is_expected.to contain_class('concat::setup') }
        it do
          is_expected.to contain_concat__fragment('unbound-remote').with_content(
            %r{^  control-enable: yes\n}
          )
        end

        case facts[:osfamily]
        when 'FreeBSD'
          it { is_expected.to contain_exec('unbound-control-setup').with_command('/usr/local/sbin/unbound-control-setup -d /usr/local/etc/unbound') }
        when 'OpenBSD'
          it { is_expected.to contain_exec('unbound-control-setup').with_command('/usr/sbin/unbound-control-setup -d /var/unbound/etc') }
        else
          it { is_expected.to contain_exec('unbound-control-setup').with_command('/usr/sbin/unbound-control-setup -d /etc/unbound') }
        end
      end

      context 'arbitrary control enablement' do
        let(:params) do
          {
            control_enable: true,
            control_setup_path: '/no/bin/unbound-control-setup',
            confdir: '/var/nowhere/unbound'
          }
        end
        it { is_expected.to contain_class('unbound::remote') }
        it { is_expected.to contain_class('concat::setup') }
        it do
          is_expected.to contain_concat__fragment('unbound-remote').with_content(
            %r{^  control-enable: yes\n}
          )
        end

        it { is_expected.to contain_exec('unbound-control-setup').with_command('/no/bin/unbound-control-setup -d /var/nowhere/unbound') }
      end

      context 'custom interface selection' do
        let(:params) do
          {
            interface: ['::1', '127.0.0.1']
          }
        end

        it { is_expected.to contain_class('concat::setup') }
        it do
          is_expected.to contain_concat__fragment('unbound-header').with_content(
            %r{^  interface: ::1\n  interface: 127.0.0.1\n}
          )
        end
      end
    end
  end
end
