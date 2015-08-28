Puppet::Type.type(:marathon_event_subscription).provide(:default) do
  desc "Implements creating Marathon event subscriptions through its REST api."

  confine :feature => :httparty

  def initialize(*args)
    super
    require 'httparty'
    require 'json'
  end
  mk_resource_methods
end
