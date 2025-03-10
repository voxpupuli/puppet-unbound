# frozen_string_literal: true

require 'spec_helper'
input = "Long TXT Record #{'X' * 255}"
output = "\"Long TXT Record #{'X' * 239}\"\"#{'X' * 16}\""

describe 'unbound::split_txt' do
  it { is_expected.to run.with_params(input).and_return(output) }
end
