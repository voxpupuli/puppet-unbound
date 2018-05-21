require 'spec_helper'

describe Facter::Util::Fact do
  before { Facter.clear }

  context 'unbound' do
    context 'With version output' do
      before do
        expect(Facter::Util::Resolution).to receive('/usr/sbin/unbound').with('-V 2>&1').once { "\nVersion 1.5.10\n" }
      end
      it { expect(Facter.value(:unbound_version)).to eq('1.5.10') }
    end
  end
end
