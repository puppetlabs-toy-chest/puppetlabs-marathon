Puppet::Type.type(:marathon_group).provide(:default) do
  desc "Implements managing Marathon groups through its REST api."

  confine :feature => :httparty

  def initialize(*args)
    super
    require 'httparty'
    require 'json'
  end
  mk_resource_methods
end
