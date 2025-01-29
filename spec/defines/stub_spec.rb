# frozen_string_literal: true

require 'spec_helper'

describe 'unbound::stub' do
  let(:title) { 'lab.example.com' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'basic' do
        let(:params) do
          {
            address: ['::1']
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_unbound__stub('lab.example.com') }

        it {
          expect(subject).to contain_concat__fragment('unbound-stub-lab.example.com').with(
            content: <<~ZONE
              stub-zone:
                name: "lab.example.com"
                stub-addr: ::1
            ZONE
          )
        }
      end

      context 'unbound::address' do
        let(:params) do
          {
            address: '10.0.0.10@10053',
            nameservers: ['ns1.example.com', 'ns2.example.com'],
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_unbound__stub('lab.example.com') }

        it {
          expect(subject).to contain_concat__fragment('unbound-stub-lab.example.com').with(
            content: <<~ZONE
              stub-zone:
                name: "lab.example.com"
                stub-addr: 10.0.0.10@10053
                stub-host: ns1.example.com
                stub-host: ns2.example.com
            ZONE
          )
        }
      end

      context 'with no_cache set' do
        let(:params) do
          {
            address: ['::1'],
            no_cache: true
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_unbound__stub('lab.example.com') }

        it {
          expect(subject).to contain_concat__fragment('unbound-stub-lab.example.com').with(
            content: <<~ZONE
              stub-zone:
                name: "lab.example.com"
                stub-addr: ::1
                stub-no-cache: yes
            ZONE
          )
        }
      end

      context 'with stub_first set' do
        let(:params) do
          {
            address: ['::1'],
            stub_first: true
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_unbound__stub('lab.example.com') }

        it {
          expect(subject).to contain_concat__fragment('unbound-stub-lab.example.com').with(
            content: <<~ZONE
              stub-zone:
                name: "lab.example.com"
                stub-addr: ::1
                stub-first: yes
            ZONE
          )
        }
      end

      context 'with address set as string' do
        let(:params) do
          {
            address: '::1',
            no_cache: true
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_unbound__stub('lab.example.com') }

        it {
          expect(subject).to contain_concat__fragment('unbound-stub-lab.example.com').with(
            content: <<~ZONE
              stub-zone:
                name: "lab.example.com"
                stub-addr: ::1
                stub-no-cache: yes
            ZONE
          )
        }
      end
    end
  end
end
