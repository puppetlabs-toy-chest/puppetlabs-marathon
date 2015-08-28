Puppet::Type.newtype(:marathon_app) do

  @doc = "Manage the state of a Marathon application"

  ensurable

end
