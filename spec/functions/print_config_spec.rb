# frozen_string_literal: true

require 'spec_helper'

describe 'unbound::print_config' do
  it { is_expected.to run.with_params('string_name', 'string_value').and_return('  string_name: "string_value"') }
  it { is_expected.to run.with_params('int_name', 42).and_return('  int_name: 42') }
  it { is_expected.to run.with_params('true_name', true).and_return('  true_name: yes') }
  it { is_expected.to run.with_params('false_name', false).and_return('  false_name: no') }

  it do
    is_expected.to run.with_params('list_name', %w[value1 value2]).
      and_return("  list_name: \"value1\"\n  list_name: \"value2\"")
  end

  context 'with version' do
    let(:facts) { { 'unbound_version' => '1.21.0' } }

    it { is_expected.to run.with_params('supported', 42, '1.11.0').and_return('  supported: 42') }
    it { is_expected.to run.with_params('supported', 42, '1.21.0').and_return('  supported: 42') }
    it { is_expected.to run.with_params('unsupported', 42, '1.22.0').and_return('') }
  end
end
