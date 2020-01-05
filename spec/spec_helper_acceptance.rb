require 'beaker-rspec'
require 'beaker-puppet'
require 'beaker/puppet_install_helper'
require 'beaker/module_install_helper'

run_puppet_install_helper unless ENV['BEAKER_provision'] == 'no'

RSpec.configure do |c|
  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    install_module
    install_module_dependencies

    hosts.each do |host|
      if fact_on(host, 'osfamily') == 'FreeBSD'
        host.install_package('dns/bind-tools')
      else
        if fact_on(host, 'osfamily') == 'RedHat'
          host.install_package('bind-utils')
        else
          host.install_package('dnsutils')
        end

        on(host, 'sysctl net.ipv6.conf.all.disable_ipv6=0')
      end
    end
  end
end
