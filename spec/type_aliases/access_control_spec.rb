# frozen_string_literal: true

require 'spec_helper'

describe 'Unbound::Access_control' do
  describe 'valid modes' do
    values = [
      {
        'action' => 'deny',
      },
      {
        'action' => 'allow',
        'tags' => %w[fuu foo],
        'rr_string' => 'a string',
        'view' => 'another string :o',
      },
      {
        'action' => 'allow',
        'rr_string' => '0.0.0.0/0',
      },
      {
        'action' => 'allow',
        'rr_string' => '::/0',
      }
    ]
    values.each do |value|
      describe value.inspect do
        it { is_expected.to allow_value(value) }
      end
    end
  end
end
