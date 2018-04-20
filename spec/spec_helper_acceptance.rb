# frozen_string_literal: true

require 'beaker-rspec'

modules = [
  'puppetlabs-stdlib',
  'puppetlabs-concat'
]
def install_modules(host, modules)
  module_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
  install_dev_puppet_module_on(host, source: module_root)
  modules.each do |m|
    on(host, puppet('module', 'install', m))
  end
end
# Install Puppet on all hosts
hosts.each do |host|
  step "install packages on #{host}"
  if host['platform'] =~ %r{freebsd}
    # default installs incorect version
    host.install_package('dns/bind-tools')
    host.install_package('puppet4')
  else
    # https://github.com/moby/moby/issues/33099
    if host['platform'] =~ %r{^el-}
      host.install_package('bind-utils')
    else
      host.install_package('dnsutils')
    end
    on(host, 'sysctl net.ipv6.conf.all.disable_ipv6=0')
    install_puppet_on(
      host,
      version: '4',
      puppet_agent_version: '1.9.0',
      default_action: 'gem_install'
    )
  end
  # remove search list and domain from resolve.conf
  install_modules(host, modules)
end
RSpec.configure do |c|
  c.formatter = :documentation
  # c.before :suite do
  #   hosts.each do |host|
  #   end
  # end
end
