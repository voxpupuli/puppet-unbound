require 'spec_helper'
require 'pry'

describe 'unbound_version fact' do
  subject { Facter.fact(:unbound_version).value }

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      case facts[:os]['family']
      when 'FreeBSD'
        let(:unbound_cmd) { '/usr/local/sbin/unbound' }
      else
        let(:unbound_cmd) { '/usr/sbin/unbound' }
      end

      let(:unbound_version_output) do
        <<-EOS
Version 1.9.3

Configure line: --with-ssl=/usr --with-libexpat=/usr/local --disable-dnscrypt --disable-dnstap --enable-ecdsa --disable-event-api --enable-gost --with-libevent --disable-subnet --disable-tfo-client --disable-tfo-server --with-pthreads --prefix=/usr/local --localstatedir=/var --mandir=/usr/local/man --infodir=/usr/local/share/info/ --build=amd64-portbld-freebsd12.0
Linked libs: libevent 2.1.11-stable (it uses kqueue), OpenSSL 1.1.1a-freebsd  20 Nov 2018
Linked modules: dns64 respip validator iterator

BSD licensed, see LICENSE in source package for details.
Report bugs to unbound-bugs@nlnetlabs.nl or https://github.com/NLnetLabs/unbound/issues
EOS
      end

      after { Facter.clear }

      before do
        File.stubs(:executable?)
        Facter.expects(:value).with('kernel').returns(facts[:os]['kernel'])
        File.expects(:exists?).with(unbound_cmd).returns true
      end

      # before do
      #   Facter.fact(:osfamily).expects(:value).returns(facts[:os]['family'])
      #   File.stubs(:executable?)
      #   case facts[:os]['family']
      #   when 'FreeBSD'
      #     File.expects(:executable?).with('/usr/local/sbin/unbound').returns true
      #     Facter::Util::Resolution.expects(:exec).with('/usr/local/sbin/unbound -V').returns(unbound_version_output)
      #   else
      #     File.expects(:executable?).with('/usr/sbin/unbound').returns true
      #   Facter::Util::Resolution.expects(:exec).with('/usr/sbin/unbound -V').returns(unbound_version_output)
      #   end
      # end

      context 'returns the desired value' do
        it {
          Facter::Util::Resolution.expects(:exec).with("#{unbound_cmd} -V 2>&1").returns(unbound_version_output)
          binding.pry

          is_expected.to eq '1.9.3'
          # expect(Facter.value('unbound_version')).to eq('1.9.3')
        }
      end
    end
  end
end
