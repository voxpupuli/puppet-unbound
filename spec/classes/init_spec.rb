require 'spec_helper'

describe 'unbound' do
  context "supported operating systems" do
    [
      'Debian',
      'Ubuntu',
      'RedHat',
      'CentOS',
      'Scientific',
      'Darwin',
      'FreeBSD',
      'OpenBSD',
      'SLES',
      'OpenSuSE',
      'SuSE',
    ].each do |operatingsystem|
      describe "puppet class without any parameters on #{operatingsystem}" do
        let(:facts) {
          {
            :operatingsystem => operatingsystem,
            :concat_basedir => '/dne'
          }
        }
        it { should contain_class('unbound') }
      end
    end
  end
  context "puppet class with access control" do
    let (:facts) {{
      :operatingsystem => 'Ubuntu',
      :concat_basedir => '/dne'
    }}
    let (:params) {{
      :access => ["10.21.30.0/24 allow", "10.21.30.5/32 reject", "127.0.0.1/32 allow_snoop" , "123.123.123.0/20"]
    }}
    it { should contain_class('concat::setup') }
    it { should contain_concat('/etc/unbound/unbound.conf') }
    it { should contain_concat__fragment('unbound-header').with_content(
      /^  access-control: 10.21.30.0\/24 allow\n  access-control: 10.21.30.5\/32 reject\n  access-control: 127.0.0.1\/32 allow_snoop\n  access-control: 123.123.123.0\/20 allow/
    )}
    context "with a different config file" do
      before do
        params.merge!({ :config_file => '/etc/unbound/unbound.conf.d/foobar.conf' })
      end
      it { should contain_concat('/etc/unbound/unbound.conf.d/foobar.conf') }
    end
  end
  context "stub passed to class" do
    let (:facts) {{
      :operatingsystem => 'Ubuntu',
      :concat_basedir => '/dne'
    }}
    let (:params) {{
      :stub => { 'example-stub.com' => { 'address' => [ '10.0.0.1', '10.0.0.2' ], 'insecure' => 'true' } },
    }}
    it { should contain_class('concat::setup') }
    it { should contain_concat('/etc/unbound/unbound.conf') }
    it { should contain_concat__fragment('unbound-stub-example-stub.com').with_content(
      /^stub-zone:\n  name: "example-stub.com"\n  stub-addr: 10.0.0.1\n  stub-addr: 10.0.0.2/
    )}
    context "with a different config file" do
      before do
        params.merge!({ :config_file => '/etc/unbound/unbound.conf.d/foobar.conf' })
      end
      it { should contain_concat('/etc/unbound/unbound.conf.d/foobar.conf') }
    end
  end
  context "forward passed to class" do
    let (:facts) {{
      :operatingsystem => 'Ubuntu',
      :concat_basedir => '/dne'
    }}
    let (:params) {{
      :forward => { 'example-forward.com' => { 'address' => [ '10.0.0.1', '10.0.0.2' ], 'forward_first' => 'yes' } },
    }}
    it { should contain_class('concat::setup') }
    it { should contain_concat('/etc/unbound/unbound.conf') }
    it { should contain_concat__fragment('unbound-forward-example-forward.com').with_content(
      /^forward-zone:\n  name: "example-forward.com"\n  forward-addr: 10.0.0.1\n  forward-addr: 10.0.0.2\n  forward-first: yes/
    )}
    context "with a different config file" do
      before do
        params.merge!({ :config_file => '/etc/unbound/unbound.conf.d/foobar.conf' })
      end
      it { should contain_concat('/etc/unbound/unbound.conf.d/foobar.conf') }
    end
  end
  context "record passed to class" do
    let (:facts) {{
      :operatingsystem => 'Ubuntu',
      :concat_basedir => '/dne'
    }}
    let (:params) {{
      :record => { 'a.example-record.com' => { 'type' => 'A', 'content' => '10.0.0.1', 'ttl' => '14400', 'reverse' => true } },
    }}
    it { should contain_class('concat::setup') }
    it { should contain_concat('/etc/unbound/unbound.conf') }
    it { should contain_concat__fragment('unbound-stub-a.example-record.com-local-record').with_content(
        /^  local-data: \"a.example-record.com 14400 IN A 10.0.0.1\"\n  local-data-ptr: \"10.0.0.1 a.example-record.com\"\n/
    )}
    context "with a different config file" do
      before do
        params.merge!({ :config_file => '/etc/unbound/unbound.conf.d/foobar.conf' })
      end
      it { should contain_concat('/etc/unbound/unbound.conf.d/foobar.conf') }
    end
  end
  context "custom extended_statistics passed to class" do
    let (:facts) {{
      :operatingsystem => 'Ubuntu',
      :concat_basedir => '/dne'
    }}
    let (:params) {{
      :extended_statistics => true,
    }}
    it { should contain_class('concat::setup') }
    it { should contain_concat('/etc/unbound/unbound.conf') }
    it { should contain_concat__fragment('unbound-header').with_content(
        /^  extended-statistics: yes\n/
    )}
    context "with a different config file" do
      before do
        params.merge!({ :config_file => '/etc/unbound/unbound.conf.d/foobar.conf' })
      end
      it { should contain_concat('/etc/unbound/unbound.conf.d/foobar.conf') }
    end
  end
end
