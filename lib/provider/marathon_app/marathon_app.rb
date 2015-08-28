Puppet::Type.type(:marathon_app).provide(:default) do
  desc "Implements creating Marathon applications through its REST api."

  confine :feature => :httparty

  def initialize(*args)
    super
    require 'httparty'
    require 'json'
  end
  mk_resource_methods
end
