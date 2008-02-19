module TExp
  class Base
    def to_s
      codes = []
      encode(codes)
      codes.join("")
    end

    private

    def listize(arg)
      case arg
      when Array
        arg
      else
        [arg]
      end
    end

    def encode_date(codes, date)
      codes << date.strftime("%Y-%m-%d")
    end

    def encode_list(codes, list)
      if list.empty?
        codes << "[]"
      elsif list.size == 1
        codes << list.first
      else
        codes << "["
        prev = nil
        list.each do |item|
          codes << "," if prev && ! prev.kind_of?(TExp::Base)
          codes << item.to_s
          prev = item
        end
        codes << "]"
      end
    end

    class << self
      def register_parse_callback(token, callback=self)
        TExp.register_parse_callback(token, callback)
      end
  
      def parse_callback(stack)
        stack.push new(stack.pop)
      end
    end
  end
end
