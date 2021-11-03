# frozen_string_literal: true

require 'spec_helper'

describe 'unbound::localzone' do
  let(:title) { 'example.com' }
  let(:pre_condition) { 'class { "unbound": }' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with a TXT record (<255 characters)' do
        let(:params) do
          {
            type: 'transparent',
            local_data: [
              {
                name: 'txt.example.com',
                type: 'TXT',
                data: 'Short TXT Record'
              }
            ]
          }
        end

        it { is_expected.to contain_unbound__localzone('example.com') }

        it {
          expect(subject).to contain_concat__fragment('unbound-localzone-example.com').with(
            content: <<~ZONE
              server:
                local-zone: "example.com" transparent
                local-data: 'txt.example.com TXT "Short TXT Record"'
            ZONE
          )
        }
      end

      context 'with a TXT record (>255 characters)' do
        long_txt_record = "Long TXT Record #{'X' * 255}"
        long_txt_record_chunked = "Long TXT Record #{'X' * 239}\"\"#{'X' * 16}"
        let(:params) do
          {
            type: 'transparent',
            local_data: [
              {
                name: 'txt.example.com',
                type: 'TXT',
                data: long_txt_record
              }
            ]
          }
        end

        it { is_expected.to contain_unbound__localzone('example.com') }

        it {
          expect(subject).to contain_concat__fragment('unbound-localzone-example.com').with(
            content: <<~ZONE
              server:
                local-zone: "example.com" transparent
                local-data: 'txt.example.com TXT "#{long_txt_record_chunked}"'
            ZONE
          )
        }
      end
    end
  end
end
