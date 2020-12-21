# frozen_string_literal: true

require 'spec_helper'

describe 'Unbound::Rpz' do
  describe 'valid modes' do
    values = [
      {
        'primary' => ['primary.example.org'],
        'master' => ['mastr.example.org'],
        'url' => ['http://rpz.example.org/zone'],
        'allow_notify' => ['192.0.2.1'],
        'zonefile' => '/foo/zone',
        'rpz_action_override' => 'passthru',
        'rpz_cname_override' => 'cname.example.org',
        'rpz_log' => true,
        'rpz_log_name' => 'rpzlog',
        'tags' => %w[foo bar]
      },
      {
        'primary' => ['primary.example.org'],
      },
      {
        'master' => ['mastr.example.org'],
      },
      {
        'url' => ['http://rpz.example.org/zone'],
      },
      {
        'allow_notify' => ['192.0.2.1'],
      },
      {
        'zonefile' => '/foo/zone',
      },
      {
        'rpz_action_override' => 'passthru',
      },
      {
        'rpz_cname_override' => 'cname.example.org',
      },
      {
        'rpz_log' => true,
      },
      {
        'rpz_log_name' => 'rpzlog',
      },
      {
        'tags' => %w[foo bar]
      }
    ]
    values.each do |value|
      describe value.inspect do
        it { is_expected.to allow_value(value) }
      end
    end
  end
end
