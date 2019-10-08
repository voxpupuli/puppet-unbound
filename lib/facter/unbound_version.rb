# frozen_string_literal: true

Facter.add(:unbound_version) do
  confine { Facter.value(:kernel) != 'windows' }
  setcode do
    if Facter::Util::Resolution.which('unbound')
      unbound_version = Facter::Util::Resolution.exec('unbound -V 2>&1')
      %r{Version\s+(\d+(?:\.\d+){2})\s+}.match(unbound_version)[1]
    end
  end
end
