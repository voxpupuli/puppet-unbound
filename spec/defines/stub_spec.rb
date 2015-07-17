require 'spec_helper'

describe 'unbound::stub' do

  let(:facts) {
    {
      :operatingsystem => 'OpenBSD',
      :concat_basedir => '/dne'
    }
  }

  context "with a single address" do
    let(:title) { '10.0.10.in-addr.arpa.' }
    let(:params) { {:address => 'ns1.example.com'} }
    it do
      should contain_unbound__stub__validate_addr('ns1.example.com,10.0.10.in-addr.arpa.')
    end
  end

  context "with multiple addresses" do
    let(:title) { '10.0.10.in-addr.arpa.' }
    let(:params) { {:address => [ 'ns1.example.com', '10.0.0.10@10053', 'ns2.example.com' ] } }

    it do
      should contain_unbound__stub__validate_addr('ns1.example.com,10.0.10.in-addr.arpa.')
      should contain_unbound__stub__validate_addr('10.0.0.10@10053,10.0.10.in-addr.arpa.')
      should contain_unbound__stub__validate_addr('ns2.example.com,10.0.10.in-addr.arpa.')
    end
  end

end
