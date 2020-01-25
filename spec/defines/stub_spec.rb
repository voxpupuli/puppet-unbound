require 'spec_helper'

describe 'unbound::stub' do
  let(:title) { 'lab.example.com' }

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      it { is_expected.to contain_unbound__stub('lab.example.com') }
    end
  end
end
