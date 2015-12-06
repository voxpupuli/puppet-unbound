require_relative '../../../puppet_x/unbound/validate_addrs'


Puppet::Parser::Functions.newfunction(:validate_unbound_addr) do |args|
  if (args.size != 1) then
    raise(Puppet::ParseError, "validate_unbound_addr(): Wrong number of arguments "+
      "given #{arguments.size} for 1")
  end

  addresses = args.shift
  PuppetX::Unbound::ValidateAddrs.new(addresses)
end
