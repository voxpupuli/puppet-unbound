# frozen_string_literal: true

Facter.add(:unbound_version) do
  confine { Facter.value(:kernel) != 'windows' }
  confine { Facter::Core::Execution.which('unbound') }
  setcode do
    unbound_version = Facter::Core::Execution.execute('unbound -V 2>&1')
    %r{Version\s+(\d+(?:\.\d+){2})\s+}.match(unbound_version)[1]
  end
end
