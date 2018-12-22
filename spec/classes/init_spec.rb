require 'spec_helper'

describe 'unbound' do
  let(:params) { {} }

  on_supported_os.each do |os, facts|
    context "on #{os}" do
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

      let(:facts) { facts.merge(concat_basedir: '/dne') }
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
        it do
          is_expected.to contain_concat__fragment(
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
      context 'module config' do
        context 'dns64' do
          before { params.merge!(module_config: %w[dns64]) }
          it do
            is_expected.to contain_concat__fragment(
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
            is_expected.to contain_concat__fragment(
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
            is_expected.to contain_concat__fragment(
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
            is_expected.to contain_concat__fragment(
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
          let(:facts) { facts.merge(unbound_version: '1.6.1') }

          before { params.merge!(module_config: %w[subnetcache]) }
          it do
            is_expected.to contain_concat__fragment(
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
          let(:facts) { facts.merge(unbound_version: '1.6.1') }

          before do
            params.merge!(
              module_config: %w[subnetcache],
              send_client_subnet: ['192.0.2.0/24', '2001::db8:/48']
            )
          end
          it do
            is_expected.to contain_concat__fragment(
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
            is_expected.to contain_concat__fragment(
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
            is_expected.to contain_concat__fragment(
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
            is_expected.to contain_concat__fragment(
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
            is_expected.to contain_concat__fragment(
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
            is_expected.to contain_concat__fragment(
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
          let(:facts) { facts.merge(unbound_version: '1.6.4') }

          before do
            params.merge!(
              module_config: %w[ipsecmod],
              ipsecmod_hook: '/foo/bar',
              ipsecmod_enabled: false
            )
          end
          it do
            is_expected.to contain_concat__fragment(
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
          let(:facts) { facts.merge(unbound_version: '1.6.4') }

          before do
            params.merge!(
              module_config: %w[ipsecmod],
              ipsecmod_hook: '/foo/bar'
            )
          end
          it do
            is_expected.to contain_concat__fragment(
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
          let(:facts) { facts.merge(unbound_version: '1.6.4') }

          before do
            params.merge!(
              module_config: %w[ipsecmod],
              ipsecmod_hook: '/foo/bar/42'
            )
          end
          it do
            is_expected.to contain_concat__fragment(
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
          let(:facts) { facts.merge(unbound_version: '1.6.4') }

          before do
            params.merge!(
              module_config: %w[ipsecmod],
              ipsecmod_hook: '/foo/bar',
              ipsecmod_strict: true
            )
          end
          it do
            is_expected.to contain_concat__fragment(
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
          let(:facts) { facts.merge(unbound_version: '1.6.4') }

          before do
            params.merge!(
              module_config: %w[ipsecmod],
              ipsecmod_hook: '/foo/bar',
              ipsecmod_max_ttl: 42
            )
          end
          it do
            is_expected.to contain_concat__fragment(
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
          let(:facts) { facts.merge(unbound_version: '1.6.4') }

          before do
            params.merge!(
              module_config: %w[ipsecmod],
              ipsecmod_hook: '/foo/bar',
              ipsecmod_ignore_bogus: true
            )
          end
          it do
            is_expected.to contain_concat__fragment(
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
          let(:facts) { facts.merge(unbound_version: '1.6.4') }

          before do
            params.merge!(
              module_config: %w[ipsecmod],
              ipsecmod_hook: '/foo/bar',
              ipsecmod_whitelist: ['example.com', 'example.net']
            )
          end
          it do
            is_expected.to contain_concat__fragment(
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
        context 'python ' do
          before do
            params.merge!(
              module_config: %w[python],
              python_script: '/foo/bar'
            )
          end
          it do
            is_expected.to contain_concat__fragment(
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
            is_expected.to contain_concat__fragment(
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
            is_expected.to contain_concat__fragment(
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
            is_expected.to contain_concat__fragment(
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
            is_expected.to contain_concat__fragment(
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
            is_expected.to contain_concat__fragment(
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
            is_expected.to contain_concat__fragment(
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

        it do
          is_expected.to contain_concat__fragment('unbound-header').with_content(
            %r{^  interface: ::1\n  interface: 127.0.0.1\n}
          )
        end
      end
      context 'empty pidfile' do
        let(:params) { { pidfile: :undef } }

        it do
          is_expected.to contain_concat__fragment(
            'unbound-header'
          ).without_content('pidfile:')
        end
      end
    end
  end
end
