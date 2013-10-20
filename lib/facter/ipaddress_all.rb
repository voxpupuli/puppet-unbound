Facter.add("ipaddress_all") do
  setcode do
     Facter.value('interfaces').split(',').collect {|i| Facter.value("ipaddress_#{i}")}.select {|i| i}.join(',')
  end
end
