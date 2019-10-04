Facter.add(:unbound_version) do
  unbound_bin = case Facter.value('kernel')
                when 'FreeBSD'
                  '/usr/local/sbin/unbound'
                else
                  '/usr/sbin/unbound'
                end
  output = Facter::Util::Resolution.exec("#{unbound_bin} -V 2>&1")
  puts output
  setcode do
    return unless File.exist? unbound_bin
    # Facter::Util::Resolution.exec("#{unbound_bin} -V 2>&1").match(%r{^Version\s(\d\.\d\.\d)})[1]
    Facter::Util::Resolution.exec("#{unbound_bin} -V 2>&1")
  end
end
