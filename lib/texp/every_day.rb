module TExp
  class EveryDay < Base
    register_parse_callback('e')

    # Is +date+ included in the temporal expression.
    def include?(date)
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

    def to_hash
      build_hash
    end

    class << self
      def parse_callback(stack)
        stack.push TExp::EveryDay.new
      end
    end
  end
end
