module TExp

  # Build a temporal expression hash representation
  #
  # Usage:
  #
  #   builder = HashBuilder.new(encoding_token)
  #   builder.with(the_first_paramter)
  #   builder.with(the_next_parameter)
  #   hash = builder.hash
  #
  class HashBuilder
    # Convert the builder to a hash.
    attr_reader :hash
    
    # Create a temporal expression params hash builder.
    def initialize(type)
      @type = type
      @hash = { 'type' => type }
      @args = 0
    end
    
    # Add an argument to the hash.
    def with(arg)
      @args += 1
      @hash["#{@type}#{@args}"] = simplify(arg)
      self
    end
    
    # Simplify the value to be placed in the hash.  Essentially we
    # want only strings and lists.
    def simplify(value)
      case value
      when String
        value
      when Array
        value.map { |item| simplify(item) }
      else
        value.to_s
      end
    end
  end

end
