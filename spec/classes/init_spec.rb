require 'spec_helper'

describe 'unbound' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts.merge(concat_basedir: '/dne') }

      case facts[:os]['family']
      when 'Debian'
        case facts[:os]['release']['major']
        when '7'
          let(:pidfile) { '/var/run/unbound.pid' }
        else
          let(:pidfile) { '/run/unbound.pid' }
        end
        let(:service) { 'unbound' }
        let(:conf_dir) { '/etc/unbound' }
      when 'RedHat'
        let(:pidfile) { '/var/run/unbound/unbound.pid' }
        let(:service) { 'unbound' }
        let(:conf_dir) { '/etc/unbound' }
      when 'OpenBSD'
        let(:pidfile) { '/var/run/unbound/unbound.pid' }
        let(:service) { 'unbound' }
        let(:conf_dir) { '/var/unbound/etc' }
      when 'FreeBSD'
        let(:pidfile) { '/usr/local/etc/unbound/unbound.pid' }
        let(:service) { 'unbound' }
        let(:conf_dir) { '/usr/local/etc/unbound' }
      when 'Darwin'
        let(:pidfile) { '/var/run/unbound.pid' }
        let(:service) { 'org.macports.unbound' }
        let(:conf_dir) { '/opt/local//etc/unbound' }
      else
        let(:pidfile) { '/var/run/unbound/unbound.pid' }
        let(:service) { 'unbound' }
        let(:conf_dir) { '/etc/unbound' }
      end
      let(:package) { 'unbound' }
      let(:conf_file) { "#{conf_dir}/unbound.conf" }
      let(:conf_d_dir) { "#{conf_dir}/conf.d" }
      let(:keys_d_dir) { "#{conf_dir}/keys.d" }
      let(:hints_file) { "#{conf_dir}/root.hints" }

      context 'with default params' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('unbound') }
        it { is_expected.to contain_package(package) }
        it { is_expected.to contain_service(service) }
        it { is_expected.to contain_concat(conf_file) }
        it { is_expected.to contain_file(conf_dir) }
        it { is_expected.to contain_file(conf_d_dir) }
        it { is_expected.to contain_file(keys_d_dir) }
        it { is_expected.to contain_file(hints_file) }
        it do
          is_expected.to contain_concat__fragment(
            'unbound-header'
          ).with_content(
            %r{\s+root-hints:\s"#{hints_file}"}
          ).with_content(
            %r{\s+pidfile:\s"#{pidfile}"}
          ).without_content(
            %r{infra-cache-slabs}
          ).without_content(
            %r{key-cache-slabs}
          ).without_content(
            %r{msg-cache-slabs}
          ).without_content(
            %r{rrset-cache-slabs}
          ).without_content(
            %r{num-queries-per-thread}
          )
        end
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
            forward: { 'example-forward.com' => { 'address' => ['10.0.0.1', '10.0.0.2'], 'forward_first' => 'yes', 'forward_ssl_upstream' => 'yes' } }
          }
        end

        it { is_expected.to contain_class('concat::setup') }
        it do
          is_expected.to contain_concat__fragment('unbound-forward-example-forward.com').with_content(
            %r{^forward-zone:\n  name: "example-forward.com"\n  forward-addr: 10.0.0.1\n  forward-addr: 10.0.0.2\n  forward-first: yes\n  forward-ssl-upstream: yes}
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
            %r{^\s+domain-insecure: 0.0.10.in-addr.arpa.$}
          ).with_content(
            %r{^\s+domain-insecure: example.com.$}
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

      context 'custom log_identity passed to class' do
        let(:facts) { facts.merge(unbound_version: '1.6.1') }
        let(:params) { { log_identity: 'bind' } }

        it do
          is_expected.to contain_concat__fragment('unbound-header').with_content(
            %r{^  log-identity: "bind"\n}
          )
        end
      end

      context 'custom log_time_ascii passed to class' do
        let(:params) { { log_time_ascii: true } }

        it do
          is_expected.to contain_concat__fragment('unbound-header').with_content(
            %r{^  log-time-ascii: yes\n}
          )
        end
      end

      context 'custom log_time_ascii passed to class' do
        let(:params) { { log_queries: true } }

        it do
          is_expected.to contain_concat__fragment('unbound-header').with_content(
            %r{^  log-queries: yes\n}
          )
        end
      end

      context 'custom log_replies passed to class' do
        let(:facts) { facts.merge(unbound_version: '1.6.1') }
        let(:params) { { log_replies: true } }

        it do
          is_expected.to contain_concat__fragment('unbound-header').with_content(
            %r{^  log-replies: yes\n}
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
      context 'empty pidfile' do
        let(:params) { {pidfile: :undef} }

        it do
          is_expected.to contain_concat__fragment(
            'unbound-header'
          ).without_content('pidfile:')
        end
      end
    end
  end
end
