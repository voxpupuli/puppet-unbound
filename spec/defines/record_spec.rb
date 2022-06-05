# frozen_string_literal: true

require 'spec_helper'

describe 'unbound::record' do
  let(:title) { 'record.example.com' }
  let(:pre_condition) { 'class { "unbound": }' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with a TXT record (<255 characters)' do
        let(:params) do
          {
            type: 'TXT',
            content: 'Short TXT Record',
            reverse: false
          }
        end

        it { is_expected.to contain_unbound__record('record.example.com') }

        it {
          expect(subject).to contain_concat__fragment('unbound-stub-record.example.com-local-record').with(
            content: "  local-data: 'record.example.com 14400 IN TXT \"Short TXT Record\"'\n"
          )
        }
      end

      context 'with a TXT record (>255 characters)' do
        long_txt_record = "Long TXT Record #{'X' * 255}"
        long_txt_record_chunked = "Long TXT Record #{'X' * 239}\"\"#{'X' * 16}"
        let(:params) do
          {
            type: 'TXT',
            content: long_txt_record,
            reverse: false
          }
        end

        it { is_expected.to contain_unbound__record('record.example.com') }

        it {
          expect(subject).to contain_concat__fragment('unbound-stub-record.example.com-local-record').with(
            content: "  local-data: 'record.example.com 14400 IN TXT \"#{long_txt_record_chunked}\"'\n"
          )
        }
      end

      context 'Multiple contents (answers)' do
        let(:params) do
          {
            content: ['192.0.2.53', '192.0.2.42'],
            reverse: false,
          }
        end

        it { is_expected.to contain_unbound__record('record.example.com') }

        it do
          is_expected.to contain_concat__fragment('unbound-stub-record.example.com-local-record').
            with_content(
              %r{
                  \s+local-data:\s"record.example.com\s14400\sIN\sA\s192.0.2.53"
                  \s+local-data:\s"record.example.com\s14400\sIN\sA\s192.0.2.42"
                }x
            )
        end
      end
    end
  end
end
