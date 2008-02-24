module TExp
  class TermsBase < Base
    class << self
      def parse_callback(stack)
        stack.push self.new(*stack.pop)
      end
    end
  end

  class And < TermsBase
    register_parse_callback('a')

    def initialize(*terms)
      @terms = terms
    end

    def include?(date)
      @terms.all? { |te| te.include?(date) }
    end

    def inspect
      humanize_list(@terms, "and") { |item| item.inspect }
    end

    def encode(codes)
      encode_list(codes, @terms)
      codes << 'a'
    end
  end

  class Or < TermsBase
    register_parse_callback('o')

    def initialize(*terms)
      @terms = terms
    end

    def include?(date)
      @terms.any? { |te| te.include?(date) }
    end

    def inspect
      humanize_list(@terms) { |item| item.inspect }
    end

    def encode(codes)
      encode_list(codes, @terms)
      codes << 'o'
    end
  end

  class Not < Base
    register_parse_callback('n')

    def initialize(term)
      @term = term
    end

    def include?(date)
      ! @term.include?(date)
    end

    def inspect
      "it is not the case that " + @term.inspect
    end

    def encode(codes)
      @term.encode(codes)
      codes << 'n'
    end
  end
end
