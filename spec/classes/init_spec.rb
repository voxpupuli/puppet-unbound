# frozen_string_literal: true

require 'spec_helper'

describe 'unbound' do
  let(:params) { {} }

  # rubocop:disable RSpec/MultipleMemoizedHelpers
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts.merge(concat_basedir: '/dne') }
      let(:package) { 'unbound' }
      let(:conf_file) { "#{conf_dir}/unbound.conf" }
      let(:conf_d_dir) { "#{conf_dir}/conf.d" }
      let(:unbound_conf_d) { "#{conf_dir}/unbound.conf.d" }
      let(:keys_d_dir) { "#{conf_dir}/keys.d" }
      let(:hints_file) { "#{conf_dir}/root.hints" }

      pidfile = nil

      case os_facts[:os]['family']
      when 'Debian'
        pidfile = '/run/unbound.pid'
        let(:service) { 'unbound' }
        let(:conf_dir) { '/etc/unbound' }
        let(:purge_unbound_conf_d) { true }
        let(:control_path) { '/usr/sbin/unbound-control' }
      when 'OpenBSD'
        pidfile = '/var/run/unbound.pid'
        let(:service) { 'unbound' }
        let(:conf_dir) { '/var/unbound/etc' }
        let(:purge_unbound_conf_d) { false }
        let(:control_path) { '/usr/sbin/unbound-control' }
      when 'FreeBSD'
        pidfile = '/usr/local/etc/unbound/unbound.pid'
        let(:service) { 'unbound' }
        let(:conf_dir) { '/usr/local/etc/unbound' }
        let(:purge_unbound_conf_d) { false }
        let(:control_path) { '/usr/local/sbin/unbound-control' }
      when 'Darwin'
        pidfile = '/var/run/unbound.pid'
        let(:service) { 'org.macports.unbound' }
        let(:conf_dir) { '/opt/local//etc/unbound' }
        let(:purge_unbound_conf_d) { false }
      else
        pidfile = '/var/run/unbound/unbound.pid'
        let(:service) { 'unbound' }
        let(:conf_dir) { '/etc/unbound' }
        let(:purge_unbound_conf_d) { false }
        let(:control_path) { '/usr/sbin/unbound-control' }
      end

      context 'with default params' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('unbound') }

        it { is_expected.to contain_package(package) } if os_facts[:os]['family'] != 'OpenBSD'
        it { is_expected.to contain_service(service) }
        it { is_expected.to contain_concat(conf_file) }
        it { is_expected.to contain_file(conf_dir) }
        it { is_expected.to contain_file(conf_d_dir) }
        it { is_expected.to contain_file(keys_d_dir) }
        it { is_expected.to contain_file(hints_file) }

        context 'on Linux', if: os_facts[:kernel] == 'Linux' do
          it { is_expected.to contain_systemd__timer('roothints.timer') }
        end

        it do
          expect(subject).to contain_file(unbound_conf_d).with(
            'ensure' => 'directory',
            'owner' => 'root',
            'group' => '0',
            'purge' => purge_unbound_conf_d,
            'recurse' => purge_unbound_conf_d
          )
        end

        it { is_expected.not_to contain_file('/run') }
        it { is_expected.not_to contain_file('/var/run') }

        it { is_expected.to contain_file(File.dirname(pidfile)) } if pidfile =~ %r{unbound/unbound\.pid\Z}
        it do
          expect(subject).to contain_concat__fragment(
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

        it do
          expect(subject).to contain_concat__fragment(
            'unbound-modules'
          ).without_content(
            %r{python:}
          ).without_content(
            %r{cachedb:}
          ).without_content(
            %r{ipsecmod:}
          ).without_content(
            %r{dns64:}
          ).without_content(
            %r{subnetcache:}
          )
        end
      end

      context 'with access control configured' do
        let(:facts) { os_facts.merge(unbound_version: '1.6.1') }
        let :params do
          {
            access_control: {
              'foobar' => {
                'view' => 'allow'
              },
              'foobaz' => {
                'action' => 'allow',
                'rr_string' => '::/0',
                'tags' => %w[123 456]
              }
            }
          }
        end

        it { is_expected.to compile.with_all_deps }

        it {
          expect(subject).to contain_concat__fragment(
            'unbound-header'
          ).with_content(
            %r{\s+access-control-view: foobar}
          ).with_content(
            %r{\s+access-control-tag-action: foobaz 123 allow}
          ).with_content(
            %r{\s+access-control-tag-action: foobaz 123 ::/0}
          ).with_content(
            %r{\s+access-control-tag-action: foobaz 456 allow}
          ).with_content(
            %r{\s+access-control-tag-action: foobaz 456 ::/0}
          )
        }
      end

      context 'module config' do
        context 'dns64' do
          before { params.merge!(module_config: %w[dns64]) }

          it do
            expect(subject).to contain_concat__fragment(
              'unbound-modules'
            ).with_content(
              %r{dns64-prefix: "64:ff9b::/96"}
            ).with_content(
              %r{dns64-synthall: no}
            )
          end
        end

        context 'dns64 dns64-prefix' do
          before do
            params.merge!(
              module_config: %w[dns64],
              dns64_prefix: '42:ff9b::/96'
            )
          end

          it do
            expect(subject).to contain_concat__fragment(
              'unbound-modules'
            ).with_content(
              %r{dns64-prefix: "42:ff9b::/96"}
            ).with_content(
              %r{dns64-synthall: no}
            )
          end
        end

        context 'dns64 dns64-synthall' do
          before do
            params.merge!(
              module_config: %w[dns64],
              dns64_synthall: true
            )
          end

          it do
            expect(subject).to contain_concat__fragment(
              'unbound-modules'
            ).with_content(
              %r{dns64-prefix: "64:ff9b::/96"}
            ).with_content(
              %r{dns64-synthall: yes}
            )
          end
        end

        context 'subnetcache not supported' do
          before { params.merge!(module_config: %w[subnetcache]) }

          it do
            expect(subject).to contain_concat__fragment(
              'unbound-modules'
            ).without_content(
              %r{send-client-subnet:}
            ).without_content(
              %r{client-subnet-zone:}
            ).without_content(
              %r{client-subnet-always-forward:}
            ).without_content(
              %r{max-client-subnet-ipv6:}
            ).without_content(
              %r{max-client-subnet-ipv4:}
            )
          end
        end

        context 'subnetcache' do
          let(:facts) { os_facts.merge(unbound_version: '1.6.1') }

          before { params.merge!(module_config: %w[subnetcache]) }

          it do
            expect(subject).to contain_concat__fragment(
              'unbound-modules'
            ).without_content(
              %r{send-client-subnet:}
            ).without_content(
              %r{client-subnet-zone:}
            ).with_content(
              %r{client-subnet-always-forward: no}
            ).with_content(
              %r{max-client-subnet-ipv6: 56}
            ).with_content(
              %r{max-client-subnet-ipv4: 24}
            )
          end
        end

        context 'subnetcache send-client-subnet' do
          let(:facts) { os_facts.merge(unbound_version: '1.6.1') }

          before do
            params.merge!(
              module_config: %w[subnetcache],
              send_client_subnet: ['192.0.2.0/24', '2001::db8:/48']
            )
          end

          it do
            expect(subject).to contain_concat__fragment(
              'unbound-modules'
            ).with_content(
              %r{send-client-subnet: "192.0.2.0/24"}
            ).with_content(
              %r{send-client-subnet: "2001::db8:/48"}
            ).without_content(
              %r{client-subnet-zone:}
            ).with_content(
              %r{client-subnet-always-forward: no}
            ).with_content(
              %r{max-client-subnet-ipv6: 56}
            ).with_content(
              %r{max-client-subnet-ipv4: 24}
            )
          end
        end

        context 'subnetcache client_subnet_zone' do
          before do
            params.merge!(
              module_config: %w[subnetcache],
              client_subnet_zone: ['example.com', 'example.net']
            )
          end

          it do
            expect(subject).to contain_concat__fragment(
              'unbound-modules'
            ).without_content(
              %r{send-client-subnet:}
            ).without_content(
              %r{client-subnet-zone: "example.com"}
            ).without_content(
              %r{client-subnet-zone: "example.net"}
            ).without_content(
              %r{client-subnet-always-forward: no}
            ).without_content(
              %r{max-client-subnet-ipv6: 56}
            ).without_content(
              %r{max-client-subnet-ipv4: 24}
            )
          end
        end

        context 'subnetcache client_subnet_always_forward' do
          before do
            params.merge!(
              module_config: %w[subnetcache],
              client_subnet_always_forward: true
            )
          end

          it do
            expect(subject).to contain_concat__fragment(
              'unbound-modules'
            ).without_content(
              %r{send-client-subnet:}
            ).without_content(
              %r{client-subnet-zone:}
            ).without_content(
              %r{client-subnet-always-forward: yes}
            ).without_content(
              %r{max-client-subnet-ipv6: 56}
            ).without_content(
              %r{max-client-subnet-ipv4: 24}
            )
          end
        end

        context 'subnetcache max_client_subnet_ipv6' do
          before do
            params.merge!(
              module_config: %w[subnetcache],
              max_client_subnet_ipv6: 42
            )
          end

          it do
            expect(subject).to contain_concat__fragment(
              'unbound-modules'
            ).without_content(
              %r{send-client-subnet:}
            ).without_content(
              %r{client-subnet-zone:}
            ).without_content(
              %r{client-subnet-always-forward: no}
            ).without_content(
              %r{max-client-subnet-ipv6: 42}
            ).without_content(
              %r{max-client-subnet-ipv4: 24}
            )
          end
        end

        context 'subnetcache max_client_subnet_ipv4' do
          before do
            params.merge!(
              module_config: %w[subnetcache],
              max_client_subnet_ipv4: 21
            )
          end

          it do
            expect(subject).to contain_concat__fragment(
              'unbound-modules'
            ).without_content(
              %r{send-client-subnet:}
            ).without_content(
              %r{client-subnet-zone:}
            ).without_content(
              %r{client-subnet-always-forward: no}
            ).without_content(
              %r{max-client-subnet-ipv6: 56}
            ).without_content(
              %r{max-client-subnet-ipv4: 42}
            )
          end
        end

        context 'ipsecmod not supported' do
          before do
            params.merge!(
              module_config: %w[ipsecmod],
              ipsecmod_hook: '/foo/bar'
            )
          end

          it do
            expect(subject).to contain_concat__fragment(
              'unbound-modules'
            ).without_content(
              %r{ipsecmod-enabled:}
            ).without_content(
              %r{ipsecmod-hook:}
            ).without_content(
              %r{ipsecmod-strict:}
            ).without_content(
              %r{ipsecmod-max-ttl:}
            ).without_content(
              %r{ipsecmod-ignore-bogus:}
            ).without_content(
              %r{ipsecmod-whitelist:}
            )
          end
        end

        context 'ipsecmod disable' do
          let(:facts) { os_facts.merge(unbound_version: '1.6.4') }

          before do
            params.merge!(
              module_config: %w[ipsecmod],
              ipsecmod_hook: '/foo/bar',
              ipsecmod_enabled: false
            )
          end

          it do
            expect(subject).to contain_concat__fragment(
              'unbound-modules'
            ).with_content(
              %r{ipsecmod-enabled: no}
            ).with_content(
              %r{ipsecmod-hook: "/foo/bar"}
            ).with_content(
              %r{ipsecmod-strict: no}
            ).with_content(
              %r{ipsecmod-max-ttl: 3600}
            ).with_content(
              %r{ipsecmod-ignore-bogus: no}
            ).without_content(
              %r{ipsecmod-whitelist:}
            )
          end
        end

        context 'ipsecmod default' do
          let(:facts) { os_facts.merge(unbound_version: '1.6.4') }

          before do
            params.merge!(
              module_config: %w[ipsecmod],
              ipsecmod_hook: '/foo/bar'
            )
          end

          it do
            expect(subject).to contain_concat__fragment(
              'unbound-modules'
            ).with_content(
              %r{ipsecmod-enabled: yes}
            ).with_content(
              %r{ipsecmod-hook: "/foo/bar"}
            ).with_content(
              %r{ipsecmod-strict: no}
            ).with_content(
              %r{ipsecmod-max-ttl: 3600}
            ).with_content(
              %r{ipsecmod-ignore-bogus: no}
            ).without_content(
              %r{ipsecmod-whitelist:}
            )
          end
        end

        context 'ipsecmod ipsecmod-hook' do
          let(:facts) { os_facts.merge(unbound_version: '1.6.4') }

          before do
            params.merge!(
              module_config: %w[ipsecmod],
              ipsecmod_hook: '/foo/bar/42'
            )
          end

          it do
            expect(subject).to contain_concat__fragment(
              'unbound-modules'
            ).with_content(
              %r{ipsecmod-enabled: yes}
            ).with_content(
              %r{ipsecmod-hook: "/foo/bar/42"}
            ).with_content(
              %r{ipsecmod-strict: no}
            ).with_content(
              %r{ipsecmod-max-ttl: 3600}
            ).with_content(
              %r{ipsecmod-ignore-bogus: no}
            ).without_content(
              %r{ipsecmod-whitelist:}
            )
          end
        end

        context 'ipsecmod ipsecmod_strict' do
          let(:facts) { os_facts.merge(unbound_version: '1.6.4') }

          before do
            params.merge!(
              module_config: %w[ipsecmod],
              ipsecmod_hook: '/foo/bar',
              ipsecmod_strict: true
            )
          end

          it do
            expect(subject).to contain_concat__fragment(
              'unbound-modules'
            ).with_content(
              %r{ipsecmod-enabled: yes}
            ).with_content(
              %r{ipsecmod-hook: "/foo/bar"}
            ).with_content(
              %r{ipsecmod-strict: yes}
            ).with_content(
              %r{ipsecmod-max-ttl: 3600}
            ).with_content(
              %r{ipsecmod-ignore-bogus: no}
            ).without_content(
              %r{ipsecmod-whitelist:}
            )
          end
        end

        context 'ipsecmod ipsecmod_max_ttl' do
          let(:facts) { os_facts.merge(unbound_version: '1.6.4') }

          before do
            params.merge!(
              module_config: %w[ipsecmod],
              ipsecmod_hook: '/foo/bar',
              ipsecmod_max_ttl: 42
            )
          end

          it do
            expect(subject).to contain_concat__fragment(
              'unbound-modules'
            ).with_content(
              %r{ipsecmod-enabled: yes}
            ).with_content(
              %r{ipsecmod-hook: "/foo/bar"}
            ).with_content(
              %r{ipsecmod-strict: no}
            ).with_content(
              %r{ipsecmod-max-ttl: 42}
            ).with_content(
              %r{ipsecmod-ignore-bogus: no}
            ).without_content(
              %r{ipsecmod-whitelist:}
            )
          end
        end

        context 'ipsecmod ipsecmod-ignore-bogus' do
          let(:facts) { os_facts.merge(unbound_version: '1.6.4') }

          before do
            params.merge!(
              module_config: %w[ipsecmod],
              ipsecmod_hook: '/foo/bar',
              ipsecmod_ignore_bogus: true
            )
          end

          it do
            expect(subject).to contain_concat__fragment(
              'unbound-modules'
            ).with_content(
              %r{ipsecmod-enabled: yes}
            ).with_content(
              %r{ipsecmod-hook: "/foo/bar"}
            ).with_content(
              %r{ipsecmod-strict: no}
            ).with_content(
              %r{ipsecmod-max-ttl: 3600}
            ).with_content(
              %r{ipsecmod-ignore-bogus: yes}
            ).without_content(
              %r{ipsecmod-whitelist:}
            )
          end
        end

        context 'ipsecmod ipsecmod-whitelist' do
          let(:facts) { os_facts.merge(unbound_version: '1.6.4') }

          before do
            params.merge!(
              module_config: %w[ipsecmod],
              ipsecmod_hook: '/foo/bar',
              ipsecmod_whitelist: ['example.com', 'example.net']
            )
          end

          it do
            expect(subject).to contain_concat__fragment(
              'unbound-modules'
            ).with_content(
              %r{ipsecmod-enabled: yes}
            ).with_content(
              %r{ipsecmod-hook: "/foo/bar"}
            ).with_content(
              %r{ipsecmod-strict: no}
            ).with_content(
              %r{ipsecmod-max-ttl: 3600}
            ).with_content(
              %r{ipsecmod-ignore-bogus: no}
            ).with_content(
              %r{ipsecmod-whitelist: "example.com"}
            ).with_content(
              %r{ipsecmod-whitelist: "example.net"}
            )
          end
        end

        context 'python' do
          before do
            params.merge!(
              module_config: %w[python],
              python_script: '/foo/bar'
            )
          end

          it do
            expect(subject).to contain_concat__fragment(
              'unbound-modules'
            ).with_content(
              %r{python:}
            ).with_content(
              %r{\s+python-script: "/foo/bar"}
            )
          end
        end

        context 'cachedb' do
          before do
            params.merge!(
              module_config: %w[cachedb]
            )
          end

          it do
            expect(subject).to contain_concat__fragment(
              'unbound-modules'
            ).with_content(
              %r{cachedb:}
            ).without_content(
              %r{\s+backend:}
            ).with_content(
              %r{\s+secret-seed: "default"}
            ).without_content(
              %r{\s+redis-server-host:}
            ).without_content(
              %r{\s+redis-server-port:}
            ).without_content(
              %r{\s+redis-timeout:}
            )
          end
        end

        context 'cachedb backend redis' do
          before do
            params.merge!(
              module_config: %w[cachedb],
              backend: 'redis'
            )
          end

          it do
            expect(subject).to contain_concat__fragment(
              'unbound-modules'
            ).with_content(
              %r{cachedb:}
            ).with_content(
              %r{\s+backend: "redis"}
            ).with_content(
              %r{\s+secret-seed: "default"}
            ).with_content(
              %r{\s+redis-server-host: "127.0.0.1"}
            ).with_content(
              %r{\s+redis-server-port: 6379}
            ).with_content(
              %r{\s+redis-timeout: 100}
            )
          end
        end

        context 'cachedb backend foobar' do
          before do
            params.merge!(
              module_config: %w[cachedb],
              backend: 'foobar'
            )
          end

          it do
            expect(subject).to contain_concat__fragment(
              'unbound-modules'
            ).with_content(
              %r{cachedb:}
            ).with_content(
              %r{\s+backend: "foobar"}
            ).with_content(
              %r{\s+secret-seed: "default"}
            ).without_content(
              %r{\s+redis-server-host:}
            ).without_content(
              %r{\s+redis-server-port:}
            ).without_content(
              %r{\s+redis-timeout:}
            )
          end
        end

        context 'cachedb redis_server_host' do
          before do
            params.merge!(
              module_config: %w[cachedb],
              backend: 'redis',
              redis_server_host: '192.0.2.1'
            )
          end

          it do
            expect(subject).to contain_concat__fragment(
              'unbound-modules'
            ).with_content(
              %r{cachedb:}
            ).with_content(
              %r{\s+backend: "redis"}
            ).with_content(
              %r{\s+secret-seed: "default"}
            ).with_content(
              %r{\s+redis-server-host: "192.0.2.1"}
            ).with_content(
              %r{\s+redis-server-port: 6379}
            ).with_content(
              %r{\s+redis-timeout: 100}
            )
          end
        end

        context 'cachedb redis_server_port' do
          before do
            params.merge!(
              module_config: %w[cachedb],
              backend: 'redis',
              redis_server_port: 42
            )
          end

          it do
            expect(subject).to contain_concat__fragment(
              'unbound-modules'
            ).with_content(
              %r{cachedb:}
            ).with_content(
              %r{\s+backend: "redis"}
            ).with_content(
              %r{\s+secret-seed: "default"}
            ).with_content(
              %r{\s+redis-server-host: "127.0.0.1"}
            ).with_content(
              %r{\s+redis-server-port: 42}
            ).with_content(
              %r{\s+redis-timeout: 100}
            )
          end
        end

        context 'cachedb redis-timeout' do
          before do
            params.merge!(
              module_config: %w[cachedb],
              backend: 'redis',
              redis_timeout: 42
            )
          end

          it do
            expect(subject).to contain_concat__fragment(
              'unbound-modules'
            ).with_content(
              %r{cachedb:}
            ).with_content(
              %r{\s+backend: "redis"}
            ).with_content(
              %r{\s+secret-seed: "default"}
            ).with_content(
              %r{\s+redis-server-host: "127.0.0.1"}
            ).with_content(
              %r{\s+redis-server-port: 6379}
            ).with_content(
              %r{\s+redis-timeout: 42}
            )
          end
        end
      end

      context 'with modified access' do
        let(:params) do
          {
            access: ['10.21.30.0/24 allow', '10.21.30.5/32 reject', '127.0.0.1/32 allow_snoop', '123.123.123.0/20']
          }
        end

        it do
          expect(subject).to contain_concat__fragment('unbound-header').with_content(
            %r{^  access-control: 10.21.30.0/24 allow\n  access-control: 10.21.30.5/32 reject\n  access-control: 127.0.0.1/32 allow_snoop\n  access-control: 123.123.123.0/20 allow}
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

        it do
          expect(subject).to contain_concat__fragment('unbound-stub-example-stub.com').with_content(
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

        it do
          expect(subject).to contain_concat__fragment('unbound-forward-example-forward.com').with_content(
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

        it do
          expect(subject).to contain_concat__fragment('unbound-header').with_content(
            %r{^\s+domain-insecure: 0.0.10.in-addr.arpa.$}
          ).with_content(
            %r{^\s+domain-insecure: example.com.$}
          )
        end
      end

      context 'local_zone passed to class with nodefault' do
        let(:params) do
          {
            local_zone: { '0.0.10.in-addr.arpa.' => 'nodefault' }
          }
        end

        it do
          expect(subject).to contain_concat__fragment('unbound-header').with_content(
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

        it do
          expect(subject).to contain_concat__fragment('unbound-header').with_content(
            %r{^  extended-statistics: yes\n}
          )
        end
      end

      context 'custom log_identity passed to class' do
        let(:facts) { os_facts.merge(unbound_version: '1.6.1') }
        let(:params) { { log_identity: 'bind' } }

        it do
          expect(subject).to contain_concat__fragment('unbound-header').with_content(
            %r{^  log-identity: "bind"\n}
          )
        end
      end

      context 'custom log_time_ascii passed to class' do
        let(:params) { { log_time_ascii: true } }

        it do
          expect(subject).to contain_concat__fragment('unbound-header').with_content(
            %r{^  log-time-ascii: yes\n}
          )
        end
      end

      context 'custom log_queries passed to class' do
        let(:params) { { log_queries: true } }

        it do
          expect(subject).to contain_concat__fragment('unbound-header').with_content(
            %r{^  log-queries: yes\n}
          )
        end
      end

      context 'custom log_replies passed to class' do
        let(:facts) { os_facts.merge(unbound_version: '1.6.1') }
        let(:params) { { log_replies: true } }

        it do
          expect(subject).to contain_concat__fragment('unbound-header').with_content(
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

        it do
          expect(subject).to contain_concat__fragment('unbound-remote').with_content(
            %r{^  control-enable: yes\n}
          )
        end

        it { is_expected.to contain_service(service).with_restart("#{control_path} reload") }

        case os_facts[:os]['family']
        when 'FreeBSD'
          it { is_expected.to contain_exec('unbound-control-setup').with_command('/usr/local/sbin/unbound-control-setup -d /usr/local/etc/unbound') }
        when 'OpenBSD'
          it { is_expected.to contain_exec('unbound-control-setup').with_command('/usr/sbin/unbound-control-setup -d /var/unbound/etc') }
          it { is_expected.to contain_exec('restart unbound').with_command('/usr/sbin/rcctl restart unbound') }
        else
          it { is_expected.to contain_exec('unbound-control-setup').with_command('/usr/sbin/unbound-control-setup -d /etc/unbound') }
          it { is_expected.to contain_exec('restart unbound').with_command('/bin/systemctl restart unbound') }
        end
      end

      context 'service management diabled' do
        let(:params) { { manage_service: false, } }

        it { is_expected.not_to contain_service(service) }
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

        it do
          expect(subject).to contain_concat__fragment('unbound-remote').with_content(
            %r{^  control-enable: yes\n}
          )
        end

        it { is_expected.to contain_exec('unbound-control-setup').with_command('/no/bin/unbound-control-setup -d /var/nowhere/unbound') }
      end

      context 'control enablement with interfaces' do
        let(:params) do
          {
            control_enable: true,
            interface: [
              '1.2.3.4',
              '4.3.2.1'
            ],
            restart_cmd: '/bin/false',
            confdir: '/etc/unbound'
          }
        end

        it {
          expect(subject).to contain_file('/etc/unbound/interfaces.txt').
            with_content(%r{^1.2.3.4$}).
            with_content(%r{^4.3.2.1$}).
            that_notifies('Exec[restart unbound]')
        }

        it {
          expect(subject).to contain_exec('restart unbound').
            that_requires('Service[unbound]')
        }
      end

      context 'custom interface selection' do
        let(:params) do
          {
            interface: ['::1', '127.0.0.1']
          }
        end

        it do
          expect(subject).to contain_concat__fragment('unbound-header').with_content(
            %r{^  interface: ::1\n  interface: 127.0.0.1\n}
          )
        end
      end

      context 'empty pidfile' do
        let(:params) { { pidfile: :undef } }

        it do
          expect(subject).to contain_concat__fragment(
            'unbound-header'
          ).without_content('pidfile:')
        end
      end

      context 'roothints' do
        context 'no root hints in config' do
          let(:params) do
            {
              hints_file: 'builtin'
            }
          end

          it do
            expect(subject).to contain_concat__fragment(
              'unbound-header'
            ).without_content(%r{root-hints})
          end

          it { is_expected.not_to contain_systemd__timer('roothints.timer') }
        end

        context 'no root hints in config and update_root_hints=unmanaged' do
          let(:params) do
            {
              hints_file: 'builtin',
              update_root_hints: 'unmanaged'
            }
          end

          it do
            expect(subject).to contain_concat__fragment(
              'unbound-header'
            ).without_content(%r{root-hints})
          end

          it { is_expected.not_to contain_systemd__timer('roothints.timer') }
        end

        context 'no root hints in config and update_root_hints=absent' do
          let(:params) do
            {
              hints_file: 'builtin',
              update_root_hints: 'absent'
            }
          end

          it do
            expect(subject).to contain_concat__fragment(
              'unbound-header'
            ).without_content(%r{root-hints})
          end

          it { is_expected.to contain_systemd__timer('roothints.timer').with_ensure('absent') }
        end

        context 'update_root_hints=absent' do
          let(:params) do
            {
              update_root_hints: 'absent'
            }
          end

          it { is_expected.to contain_systemd__timer('roothints.timer').with_ensure('absent') }
        end

        context 'hieradata root hints' do
          let(:params) do
            {
              skip_roothints_download: true,
              hints_file_content: File.read('spec/classes/expected/hieradata-root-hint.conf'),
            }
          end

          it do
            expect(subject).to contain_file(hints_file).with(
              'ensure' => 'file',
              'mode' => '0444',
              'content' => File.read('spec/classes/expected/hieradata-root-hint.conf')
            )
          end
        end

        context 'with File defaults' do
          let(:pre_condition) { "File { mode => '0644', owner => 'root', group => 'root' }" }

          it { is_expected.to compile.with_all_deps }
        end
      end

      context 'RPZs config' do
        let(:params) do
          {
            module_config: ['respip'],
            rpzs: {
              'test1' => {
                'primary' => ['192.0.1.2', 'primary.example.org'],
              },
              'test2' => {
                'url' => ['https://primary.example.org/zone'],
                'allow_notify' => ['192.0.1.2', '2001:db8::'],
                'zonefile' => '/foo/bar',
                'rpz_action_override' => 'drop',
                'rpz_log' => true,
                'rpz_log_name' => 'foobar',
                'tags' => %w[foo bar],
              },
              'test3' => {
                'url' => ['https://primary.example.org/zone'],
                'allow_notify' => ['192.0.1.2', '2001:db8::'],
                'zonefile' => '/foo/bar',
                'rpz_action_override' => 'cname',
                'rpz_cname_override' => 'cname.example.org',
                'rpz_log' => true,
                'rpz_log_name' => 'foobar',
                'tags' => %w[foo bar],
              },
            }
          }
        end

        it { is_expected.to compile.with_all_deps }

        it do
          is_expected.to contain_concat__fragment('unbound-modules').
            with_content(
              %r{
                rpz:
                \s+name:\stest1
                \s+primary:\s"192\.0\.1\.2"
                \s+primary:\s"primary\.example\.org"
              }x
            ).
            with_content(
              %r{
                rpz:
                \s+name:\stest2
                \s+url:\s"https://primary\.example\.org/zone"
                \s+allow-notify:\s"192\.0\.1\.2"
                \s+allow-notify:\s"2001:db8::"
                \s+zonefile:\s"/foo/bar"
                \s+rpz-action-overrude:\s"drop"
                \s+rpz-log:\syes
                \s+rpz-log-name:\s"foobar"
                \s+tags:\s"foo"
                \s+tags:\s"bar"
              }x
            ).
            with_content(
              %r{
                rpz:
                \s+name:\stest3
                \s+url:\s"https://primary\.example\.org/zone"
                \s+allow-notify:\s"192\.0\.1\.2"
                \s+allow-notify:\s"2001:db8::"
                \s+zonefile:\s"/foo/bar"
                \s+rpz-action-overrude:\s"cname"
                \s+rpz-cname-override:\s"cname\.example\.org"
                \s+rpz-log:\syes
                \s+rpz-log-name:\s"foobar"
                \s+tags:\s"foo"
                \s+tags:\s"bar"
              }x
            )
        end
      end

      context 'with force_restart' do
        let(:params) { { force_restart: true, control_enable: true } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_service(service).with_restart(nil) }
      end
    end
  end
  # rubocop:enable RSpec/MultipleMemoizedHelpers
end
