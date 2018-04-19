require 'spec_helper'

if Puppet::Util::Package.versioncmp(Puppet.version, '4.5.0') >= 0
  describe 'Unbound::Local_zone_type' do
    describe 'valid modes' do
      %w[
        deny refuse static transparent redirect nodefault typetransparent
        inform inform_deny always_transparent always_refuse always_nxdomain
      ].each do |value|
        describe value.inspect do
          it { is_expected.to allow_value(value) }
        end
      end
    end

    describe 'invalid modes' do
      context 'with garbage inputs' do
        [
          nil,
          [nil],
          [nil, nil],
          { 'foo' => 'bar' },
          {},
          '',
          'ネット',
          '644',
          '7777',
          '1',
          '22',
          '333',
          '55555',
          '0x123',
          '0649',
          'deNy',
          'refse',
          'sta tic'
        ].each do |value|
          describe value.inspect do
            it { is_expected.not_to allow_value(value) }
          end
        end
      end
    end
  end
end
