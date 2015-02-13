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
end
