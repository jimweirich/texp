module TExp
  class EveryDay < Base
    register_parse_callback('e')

    # Is +date+ included in the temporal expression.
    def includes?(date)
      true
    end

    # Human readable version of the temporal expression.
    def inspect
      "every day"
    end

    # Encode the temporal expression into +codes+.
    def encode(codes)
      codes << encoding_token
    end

    def self.parse_callback(stack)
      stack.push TExp::EveryDay.new
    end
  end
end
