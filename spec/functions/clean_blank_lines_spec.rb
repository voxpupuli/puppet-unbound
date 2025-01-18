# frozen_string_literal: true

require 'spec_helper'

input = <<-TEXT
  string_name: "string_value"

  int_name: 42

  true_name: yes
TEXT
output = <<-TEXT
  string_name: "string_value"
  int_name: 42
  true_name: yes
TEXT

describe 'unbound::clean_blank_lines' do
  it { is_expected.to run.with_params(input).and_return(output) }
end
