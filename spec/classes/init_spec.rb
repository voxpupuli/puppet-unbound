require 'spec_helper'

describe 'unbound' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts.merge({:concat_basedir => '/dne'}) }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class("unbound") }


      # Check the default options are left undef and out of the resulting fragment
      it { is_expected.to contain_concat__fragment("unbound-header") }
      it { is_expected.to_not contain_concat__fragment("unbound-header").with_content(/infra-cache-slabs/) }
      it { is_expected.to_not contain_concat__fragment("unbound-header").with_content(/key-cache-slabs/) }
      it { is_expected.to_not contain_concat__fragment("unbound-header").with_content(/msg-cache-slabs/) }
      it { is_expected.to_not contain_concat__fragment("unbound-header").with_content(/rrset-cache-slabs/) }
      it { is_expected.to_not contain_concat__fragment("unbound-header").with_content(/num-queries-per-thread/) }


      case facts[:osfamily]
      when 'Debian'
        it { is_expected.to contain_package("unbound") }
        it { is_expected.to contain_service("unbound") }
        it { is_expected.to contain_concat("/etc/unbound/unbound.conf") }
        it { is_expected.to contain_file("/etc/unbound") }
        it { is_expected.to contain_file("/etc/unbound/conf.d") }
        it { is_expected.to contain_file("/etc/unbound/keys.d") }
        it { is_expected.to contain_file("/etc/unbound/root.hints") }

      when 'RedHat'
        it { is_expected.to contain_package("unbound") }
        it { is_expected.to contain_service("unbound") }
        it { is_expected.to contain_concat("/etc/unbound/unbound.conf") }
        it { is_expected.to contain_file("/etc/unbound") }
        it { is_expected.to contain_file("/etc/unbound/conf.d") }
        it { is_expected.to contain_file("/etc/unbound/keys.d") }
        it { is_expected.to contain_file("/etc/unbound/root.hints") }

      when 'OpenBSD'
        it { is_expected.to_not contain_package("unbound") }
        it { is_expected.to contain_service("unbound") }
        it { is_expected.to contain_concat("/var/unbound/etc/unbound.conf") }
        it { is_expected.to contain_file("/var/unbound/etc") }
        it { is_expected.to contain_file("/var/unbound/etc/conf.d") }
        it { is_expected.to contain_file("/var/unbound/etc/keys.d") }
        it { is_expected.to contain_file("/var/unbound/etc/root.hints") }

      when 'FreeBSD'
        it { is_expected.to contain_package("unbound") }
        it { is_expected.to contain_service("unbound") }
        it { is_expected.to contain_concat("/usr/local/etc/unbound/unbound.conf") }
        it { is_expected.to contain_file("/usr/local/etc/unbound") }
        it { is_expected.to contain_file("/usr/local/etc/unbound/conf.d") }
        it { is_expected.to contain_file("/usr/local/etc/unbound/keys.d") }
        it { is_expected.to contain_file("/usr/local/etc/unbound/root.hints") }

      end

      context 'with modified access' do
        let (:params) {{
          :access => ["10.21.30.0/24 allow", "10.21.30.5/32 reject", "127.0.0.1/32 allow_snoop" , "123.123.123.0/20"]
        }}

        it { should contain_class('concat::setup') }
        it { should contain_concat__fragment('unbound-header').with_content(
          /^  access-control: 10.21.30.0\/24 allow\n  access-control: 10.21.30.5\/32 reject\n  access-control: 127.0.0.1\/32 allow_snoop\n  access-control: 123.123.123.0\/20 allow/
        )}

      end

      context "with a different config file" do
        let (:params) {{ :config_file => '/etc/unbound/unbound.conf.d/foobar.conf' }}
        it { should contain_concat('/etc/unbound/unbound.conf.d/foobar.conf') }
      end

      context "stub passed to class" do
        let (:params) {{
          :stub => { 'example-stub.com' => { 'address' => [ '10.0.0.1', '10.0.0.2' ], 'insecure' => 'true' } },
        }}
        it { should contain_class('concat::setup') }
        it { should contain_concat__fragment('unbound-stub-example-stub.com').with_content(
          /^stub-zone:\n  name: "example-stub.com"\n  stub-addr: 10.0.0.1\n  stub-addr: 10.0.0.2/
        )}
      end

      context "forward passed to class" do
        let (:params) {{
          :forward => { 'example-forward.com' => { 'address' => [ '10.0.0.1', '10.0.0.2' ], 'forward_first' => 'yes' } },
        }}
        it { should contain_class('concat::setup') }
        it { should contain_concat__fragment('unbound-forward-example-forward.com').with_content(
          /^forward-zone:\n  name: "example-forward.com"\n  forward-addr: 10.0.0.1\n  forward-addr: 10.0.0.2\n  forward-first: yes/
        )}
      end

      context "custom extended_statistics passed to class" do
        let (:params) {{
          :extended_statistics => true,
        }}
        it { should contain_class('concat::setup') }
        it { should contain_concat__fragment('unbound-header').with_content(
            /^  extended-statistics: yes\n/
        )}
      end

      context "platform control enablement" do
        let (:params) {{
          :control_enable     => true,
        }}
        it { should contain_class('unbound::remote') }
        it { should contain_class('concat::setup') }
        it { should contain_concat__fragment('unbound-remote').with_content(
            /^  control-enable: yes\n/
        )}

        case facts[:osfamily]
        when 'FreeBSD'
          it { should contain_exec('unbound-control-setup').with_command('/usr/local/sbin/unbound-control-setup -d /usr/local/etc/unbound') }
        when 'OpenBSD'
          it { should contain_exec('unbound-control-setup').with_command('/usr/sbin/unbound-control-setup -d /var/unbound/etc') }
        else
          it { should contain_exec('unbound-control-setup').with_command('/usr/sbin/unbound-control-setup -d /etc/unbound') }
        end
      end

      context "arbitrary control enablement" do
        let (:params) {{
          :control_enable => true,
          :control_setup_path => '/no/bin/unbound-control-setup',
          :confdir => '/var/nowhere/unbound',
        }}
        it { should contain_class('unbound::remote') }
        it { should contain_class('concat::setup') }
        it { should contain_concat__fragment('unbound-remote').with_content(
            /^  control-enable: yes\n/
        )}

        it { should contain_exec('unbound-control-setup').with_command('/no/bin/unbound-control-setup -d /var/nowhere/unbound') }
      end

    end
  end

end
