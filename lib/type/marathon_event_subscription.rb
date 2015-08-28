Puppet::Type.newtype(:marathon_event_subscription) do

  @doc = "Manage Marathon event subscription objects."
  ensurable
end
