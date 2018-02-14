# frozen_string_literal: true

unbound_bin = case Facter.value('kernel')
              when 'FreeBSD'
                '/usr/local/sbin/unbound'
              else
                '/usr/sbin/unbound'
              end
if File.exist? unbound_bin
  unbound_version = Facter::Util::Resolution.exec(
    "#{unbound_bin} -V 2>&1"
  ).match(%r{\nVersion\s(\d\.\d\.\d)})[1]
  Facter.add(:unbound_version) do
    setcode do
      unbound_version
    end
  end
end
