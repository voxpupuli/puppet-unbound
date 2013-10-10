Facter.add("ipaddress_all") do
  setcode do
    Facter::Util::Resolution::exec("ip addr | awk 'BEGIN {ORS=\",\"} /inet / {split($2,a,\"/\"); print a[1]}'")
  end
end
