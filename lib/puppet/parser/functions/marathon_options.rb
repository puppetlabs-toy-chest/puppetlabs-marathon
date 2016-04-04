module Puppet::Parser::Functions
  newfunction(
    :marathon_options,
    type: :rvalue,
    arity: -2,
    doc: 'Convert a hash of Marathon options to a structure for create_resources function'
  ) do |args|
    structure = {}
    args.each do |options|
      raise Puppet::ParseError, "marathon_options() Options should be provided as a Hash! Got: #{options.inspect}" unless options.is_a? Hash
      options.each do |key, value|
        next unless key && !value.nil?
        if value.is_a? FalseClass
          structure.delete key
          structure["disable_#{key}"] = {}
          structure["disable_#{key}"]['value'] = ''
        elsif value.is_a? TrueClass
          structure.delete "disable_#{key}"
          structure[key] = {}
          structure[key]['value'] = ''
        else
          structure[key] = {}
          structure[key]['value'] = value
        end
      end
    end
    structure
  end
end
