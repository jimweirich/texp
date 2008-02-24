module TExp
  class EveryDay < Base
    register_parse_callback('e')

    def include?(date)
      true
    end

    def inspect
      "every day"
    end

    def encode(codes)
      codes << 'e'
    end

    class << self
      def parse_callback(stack)
        stack.push TExp::EveryDay.new
      end
    end
  end
end
