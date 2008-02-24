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

    def ordinal_list(list, connector='or')
      humanize_list(list, connector) { |item| ordinal(item) }
    end

    def humanize_list(list, connector='or', &block)
      block ||= lambda { |item| item.to_s }
      list = list.sort if list.all? { |item| item.kind_of?(Integer) && item >= 0 }
      case list.size
      when 1
        block.call(list.first)
      else
        list[0...-1].collect { |d|
          block.call(d)
        }.join(", ") +
          " #{connector} " + block.call(list.last)
      end
    end

    def humanize_date(date)
      date.strftime("%B %d, %Y")
    end

    SUFFIX = {
      1 => "st",
      2 => "nd",
      3 => "rd",
      4 => "th",
      5 => "th",
      6 => "th",
      7 => "th",
      8 => "th",
      9 => "th",
      0 => "th",
      11 => "th",
      12 => "th",
      13 => "th",
    }

    def ordinal(n)
      if n == -1
        "last"
      elsif n == -2
        "next to the last"
      elsif n < 0
        ordinal(-n) + " from the last"
      else
        n.to_s + suffix(n)
      end        
    end

    def suffix(n)
      SUFFIX[n % 100] || SUFFIX[n % 10]
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
