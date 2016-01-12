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
  end
end
