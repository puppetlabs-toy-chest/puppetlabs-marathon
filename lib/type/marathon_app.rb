Puppet::Type.newtype(:marathon_app) do

  @doc = "Manage the state of a Marathon application"

  ensurable

  newparam(:id, :namevar => true) do 
    desc "The id of the Marathon application."
  end

  newparam(:host) do
    desc "The host/port to the Marathon host. Defaults to localhost."
    defaultto 'http://localhost:8080'
  end

  newproperty(:cmd) do
    desc "The command that is executed."

    validate do |val|
      unless val.is_a? String
        raise ArgumentError, "cmd parameter must be a String, got value of type #{val.class}"
      end
    end
  end

  newproperty(:args, :array_matching => :all) do
    desc "An array of strings that represents an alternative mode of specifying the command to run."
    validate do |val|
      unless val.is_a? String
        raise ArgumentError, "args parameter must be an array of strings, got value of type #{val.class}"
      end
    end
  end

  newproperty(:cpus) do
    desc "Amount of cpu shares to allocate to an application."

    defaultto 0.1

    validate do |val|
      unless (val.is_a?(Float) || val.is_a?(Fixnum))
        raise ArgumentError, "cpus parameter must be a Float or Fixnum, got value of type #{val.class}"
      end
    end
  end

  newproperty(:mem) do
    desc "Amount of disk to allocate to an application."

    defaultto 64

    validate do |val|
      unless (val.is_a?(Float) || val.is_a?(Fixnum))
        raise ArgumentError, "mem parameter must be a FLoat or Fixnum, got value of type #{val.class}"
      end
    end
  end

  newproperty(:ports, :array_matching => :all) do
    desc "An array of required port resources on the host."
    validate do |val|
      unless val.is_a? Fixnum
        raise ArgumentError, "ports parameter must be an array of Fixnum, got value of type #{val.class}"
      end
    end
  end

  newproperty(:requiredPorts, :boolean => true, :parent => Puppet::Property::Boolean) do
    desc "Whether or not the specified ports are required."
  end

  newproperty(:disk) do
    desc "Amount of disk to allocate to an application."

    defaultto 256

    validate do |val|
      unless (val.is_a?(Float) || val.is_a?(Fixnum))
        raise ArgumentError, "disk parameter must be a Float or Fixnum, got value of type #{val.class}"
      end
    end
  end

  newproperty(:container) do
    desc "The subfields that contain data needed to run the application in a container"

    validate do |val|
      unless val.is_a? Hash
        raise ArgumentError, "container parameter must be a Hash, got value of type #{val.class}"
      end
    end
  end

  newproperty(:env) do
    desc "Key value pairs that get added to the environment of the started process."

    validate do |val|
      if val.is_a?(Hash) && val.has_key?('name') && val.has_key?('value')
        raise ArgumentError, 'detected env parameter with keys "name" and "value". The marathon_app type does not support the Marathon API way of setting environment variables, sending an array of hashes. The marathon_app type expects a hash of { NAME => VALUE }'
      end
    end
  end
end
