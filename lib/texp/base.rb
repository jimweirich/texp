require 'texp/hash_builder'

module TExp
  # Abstract Base class for all Texp Temporal Expressions.
  class Base

    # Convert the temporal expression into an encoded string (that can
    # be parsed by TExp.parse).
    def to_s
      codes = []
      encode(codes)
      codes.join("")
    end

    def set_anchor_date(date)
      # do nothing
    end

    private

    # Coerce +arg+ into a list (i.e. Array) if it is not one already.
    def listize(arg)
      case arg
      when Array
        arg
      else
        [arg]
      end
    end

    # Encode the date into the codes receiver.
    def encode_date(codes, date)
      codes << date.strftime("%Y-%m-%d")
    end

    # Encode the list into the codes receiver.  All
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

    # For the list of integers as a list of ordinal numbers.  By
    # default, use 'or' as a connectingin word. (e.g. [1,2,3] => "1st,
    # 2nd, or 3rd")
    def ordinal_list(list, connector='or')
      humanize_list(list, connector) { |item| ordinal(item) }
    end

    # Format the list in a human readable format.  By default, use
    # "or" as a connecting word. (e.g. ['a', 'b', 'c'] => "a, b, or
    # c")
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

    # Format +date+ in a standard, human-readable format.
    def humanize_date(date)
      date.strftime("%B %d, %Y")
    end

    # Hash of cardinal integers to ordinal suffixes.
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

    # Return the ordinal abbreviation for the integer +n+.  (e.g. 1 =>
    # "1st", 3 => "3rd")
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

    # The ordinal suffex appropriate for the given number.  (e.g. 1 =>
    # "st", 2 => "nd")
    def suffix(n)
      SUFFIX[n % 100] || SUFFIX[n % 10]
    end

    # Convenience method for accessing the class encoding token.
    def encoding_token
      self.class.encoding_token
    end

    # Build a params hash for this temporal expression.
    def build_hash
      builder = HashBuilder.new(encoding_token)
      yield builder if block_given?
      builder.hash
    end

    class << self
      # The token to be used for encoding this temporal expression.
      attr_reader :encoding_token
      
      # Register a parse callack for the encoding token for this
      # class.  
      def register_parse_callback(token, callback=self)
        @encoding_token = token if callback == self
        TExp.register_parse_callback(token, callback)
      end
  
      # The default parsing callback for single argument time
      # expressions.  Override if you need anything more complicated.
      def parse_callback(stack)
        stack.push new(stack.pop)
      end
    end
  end
end
