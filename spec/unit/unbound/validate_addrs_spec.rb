require 'spec_helper'
require 'puppet_x/unbound/validate_addrs'

describe 'PuppetX::Unbound::ValidateAddrs' do
  subject(:validate) { PuppetX::Unbound::ValidateAddrs }
  describe "#ip_list" do
    context "a single address" do
      it "should not raise an error" do
        expect { PuppetX::Unbound::ValidateAddrs.new('10.0.0.1').ip_list }.to_not raise_error
      end

      it "should return the desired results" do
        expect(PuppetX::Unbound::ValidateAddrs.new('127.0.0.1@5353').ip_list).to eq(['127.0.0.1@5353'])
        expect(PuppetX::Unbound::ValidateAddrs.new(['10.0.0.1']).ip_list).to eq(['10.0.0.1'])
        expect(PuppetX::Unbound::ValidateAddrs.new(['127.0.0.1@5353']).ip_list).to eq(['127.0.0.1@5353'])
      end

      it "should not return any names" do
        expect(PuppetX::Unbound::ValidateAddrs.new(['ns1.example.com@5353']).ip_list).to eq([])
      end
    end

    context "multiple addresss specifications" do
      it "should return the desired results" do
        expect(validate.new(['10.0.0.1','10.1.0.1','fc00::']).ip_list).to eq(['10.0.0.1','10.1.0.1','fc00::'])
        expect(validate.new(['127.0.0.1@5353','10.1.0.1','fc00::']).ip_list).to eq(['127.0.0.1@5353','10.1.0.1','fc00::'])
        expect(validate.new(['10.0.0.1','10.1.0.1','ns1.example.com','fc00::']).ip_list).to eq(['10.0.0.1','10.1.0.1','fc00::'])
      end
    end
  end

  describe "#name_list" do
    context "a single address" do
      it "should not raise an error" do
        expect { PuppetX::Unbound::ValidateAddrs.new('10.0.0.1').name_list }.to_not raise_error
        expect { PuppetX::Unbound::ValidateAddrs.new('ns1.example.com').name_list }.to_not raise_error
      end

      it "should return the desired results" do
        expect(PuppetX::Unbound::ValidateAddrs.new(['ns1.example.com']).name_list).to eq(['ns1.example.com'])
        expect(PuppetX::Unbound::ValidateAddrs.new(['ns1.example.com@5353']).name_list).to eq(['ns1.example.com@5353'])
      end

      it "should not return any IP addresses" do
        expect(PuppetX::Unbound::ValidateAddrs.new(['127.0.0.1@5353']).name_list).to eq([])
      end
    end

    context "multiple addresss specifications" do
      it "should return the desired results" do
        expect(validate.new(['10.0.0.1','ns1.example.com','fc00::']).name_list).to eq(['ns1.example.com'])
        expect(validate.new(['ns2.example.com','ns1.example.com','fc00::']).name_list).to eq(['ns2.example.com','ns1.example.com'])
        expect(validate.new(['ns1.example.com@5353','ns2.example.com']).name_list).to eq(['ns1.example.com@5353','ns2.example.com'])
      end
    end
  end

  describe "#validate" do
    context "when valid addresses are passed" do
      it "should not raise and error" do
        expect { validate.new('10.0.0.10').validate }.to_not raise_error
        expect { validate.new('fc00::').validate }.to_not raise_error
        expect { validate.new(['ns1.example.com', '10.0.0.10@10053']).validate }.to_not raise_error
        expect { validate.new(['ns1.example.com', '10.0.0.10@10053', 'ns2.example.com' ]).validate }.to_not raise_error
      end
      it "should raise an error when multiple @ signs are found" do
        expect { validate.new('10.0.0.10@5353@53').validate }.to raise_error(Puppet::ParseError, /Too many @/)
        expect { validate.new('10.0.0.10@@53').validate }.to raise_error(Puppet::ParseError, /Too many @/)
        expect { validate.new('@@').validate }.to raise_error(Puppet::ParseError, /Too many @/)
        expect { validate.new('fc00::@53@53').validate }.to raise_error(Puppet::ParseError, /Too many @/)
      end
      it "should raise an error if the port is not numeric" do
        expect { validate.new('fc00::@fc00::').validate }.to raise_error(Puppet::ParseError, /is not numeric/)
      end
    end
  end
end

