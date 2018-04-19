require 'spec_helper'
require 'puppet_x/unbound/validate_addrs'

describe 'PuppetX::Unbound::ValidateAddrs' do
  subject(:validate) { PuppetX::Unbound::ValidateAddrs }

  describe '#ip_list' do
    context 'a single address' do
      it 'does not raise an error' do
        expect { PuppetX::Unbound::ValidateAddrs.new('10.0.0.1').ip_list }.not_to raise_error
      end

      it 'handles v4@port style' do
        expect(PuppetX::Unbound::ValidateAddrs.new('127.0.0.1@5353').ip_list).to eq(['127.0.0.1@5353'])
      end
      it 'handles v4 style' do
        expect(PuppetX::Unbound::ValidateAddrs.new(['10.0.0.1']).ip_list).to eq(['10.0.0.1'])
      end
      it 'handles [v4@port] style' do
        expect(PuppetX::Unbound::ValidateAddrs.new(['127.0.0.1@5353']).ip_list).to eq(['127.0.0.1@5353'])
      end

      it 'does not return any names' do
        expect(PuppetX::Unbound::ValidateAddrs.new(['ns1.example.com@5353']).ip_list).to eq([])
      end
    end

    context 'multiple addresss specifications' do
      it 'handles mixed case 1' do
        expect(validate.new(['10.0.0.1', '10.1.0.1', 'fc00::']).ip_list).to eq(['10.0.0.1', '10.1.0.1', 'fc00::'])
      end

      it 'handles mixed case 2' do
        expect(validate.new(['127.0.0.1@5353', '10.1.0.1', 'fc00::']).ip_list).to eq(['127.0.0.1@5353', '10.1.0.1', 'fc00::'])
      end

      it 'handles mixed case 3' do
        expect(validate.new(['10.0.0.1', '10.1.0.1', 'ns1.example.com', 'fc00::']).ip_list).to eq(['10.0.0.1', '10.1.0.1', 'fc00::'])
      end
    end
  end

  describe '#name_list' do
    context 'a single address' do
      it 'handles an address' do
        expect { PuppetX::Unbound::ValidateAddrs.new('10.0.0.1').name_list }.not_to raise_error
      end

      it 'handles a name' do
        expect { PuppetX::Unbound::ValidateAddrs.new('ns1.example.com').name_list }.not_to raise_error
      end

      it 'handles the [name] case' do
        expect(PuppetX::Unbound::ValidateAddrs.new(['ns1.example.com']).name_list).to eq(['ns1.example.com'])
      end

      it 'handles the [name@port] case' do
        expect(PuppetX::Unbound::ValidateAddrs.new(['ns1.example.com@5353']).name_list).to eq(['ns1.example.com@5353'])
      end

      it 'does not return any IP addresses' do
        expect(PuppetX::Unbound::ValidateAddrs.new(['127.0.0.1@5353']).name_list).to eq([])
      end
    end

    context 'multiple addresss specifications' do
      it 'handles mixed case 1' do
        expect(validate.new(['10.0.0.1', 'ns1.example.com', 'fc00::']).name_list).to eq(['ns1.example.com'])
      end

      it 'handles mixed case 2' do
        expect(validate.new(['ns2.example.com', 'ns1.example.com', 'fc00::']).name_list).to eq(['ns2.example.com', 'ns1.example.com'])
      end

      it 'handles mixed case 3' do
        expect(validate.new(['ns1.example.com@5353', 'ns2.example.com']).name_list).to eq(['ns1.example.com@5353', 'ns2.example.com'])
      end
    end
  end

  describe '#validate' do
    context 'when valid addresses are passed' do
      it 'handles a v4 address' do
        expect { validate.new('10.0.0.10').validate }.not_to raise_error
      end

      it 'handles a v6 address' do
        expect { validate.new('fc00::').validate }.not_to raise_error
      end

      it 'mixed name and address' do
        expect { validate.new(['ns1.example.com', '10.0.0.10@10053']).validate }.not_to raise_error
      end

      it 'raises an error when multiple @ signs are found 1' do
        expect { validate.new('10.0.0.10@5353@53').validate }.to raise_error(Puppet::ParseError, %r{Too many @})
      end

      it 'raises an error when multiple @ signs are found 1' do
        expect { validate.new('10.0.0.10@@53').validate }.to raise_error(Puppet::ParseError, %r{Too many @})
      end

      it 'raises an error when multiple @ signs are found 1' do
        expect { validate.new('@@').validate }.to raise_error(Puppet::ParseError, %r{Too many @})
      end

      it 'raises an error when multiple @ signs are found 1' do
        expect { validate.new('fc00::@53@53').validate }.to raise_error(Puppet::ParseError, %r{Too many @})
      end

      it 'raises an error if the port is not numeric' do
        expect { validate.new('fc00::@fc00::').validate }.to raise_error(Puppet::ParseError, %r{is not numeric})
      end
    end
  end
end
