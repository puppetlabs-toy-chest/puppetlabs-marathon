Puppet.features.add(:httparty) do
  begin
    require 'httparty'
  rescue LoadError => e
    warn "Can't manage Marathon resources without the 'httparty' Ruby gem. #{e}"
  end
end
