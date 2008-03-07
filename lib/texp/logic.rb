module TExp

  # Base class for temporal expressions with multiple sub-expressions
  # (i.e. terms).
  class TermsBase < Base

    # Create an multi-term temporal expression.
    def initialize(*terms)
      @terms = terms
    end

    # Set the anchor date for this temporal expression.
    def set_anchor_date(date)
      @terms.each do |term| term.set_anchor_date(date) end
    end

    class << self
      # Parsing callback for terms based temporal expressions.  The
      # top of the stack is assumed to be a list that is *-expanded to
      # the temporal expression's constructor.
      def parse_callback(stack)
        stack.push self.new(*stack.pop)
      end
    end
  end

  # Logically AND a list of temporal expressions.  A date is included
  # only if it is included in all of the sub-expressions.
  class And < TermsBase
    register_parse_callback('a')

    # Is +date+ included in the temporal expression.
    def include?(date)
      @terms.all? { |te| te.include?(date) }
    end

    # Human readable version of the temporal expression.
    def inspect
      humanize_list(@terms, "and") { |item| item.inspect }
    end

    # Encode the temporal expression into +codes+.
    def encode(codes)
      encode_list(codes, @terms)
      codes << encoding_token
    end
  end

  # Logically OR a list of temporal expressions.  A date is included
  # if it is included in any of the sub-expressions.
  class Or < TermsBase
    register_parse_callback('o')

    # Is +date+ included in the temporal expression.
    def include?(date)
      @terms.any? { |te| te.include?(date) }
    end

    # Human readable version of the temporal expression.
    def inspect
      humanize_list(@terms) { |item| item.inspect }
    end

    # Encode the temporal expression into +codes+.
    def encode(codes)
      encode_list(codes, @terms)
      codes << encoding_token
    end
  end

  # Logically NEGATE a temporal expression.  A date is included if it
  # is not included in the sub-expression.
  class Not < Base
    register_parse_callback('n')

    # Create a NOT temporal expression.
    def initialize(term)
      @term = term
    end

    # Is date included in the temporal expression.
    def include?(date)
      ! @term.include?(date)
    end

    # Set the anchor date for this temporal expression.
    def set_anchor_date(date)
      @term.set_anchor_date(date)
    end

    # Human readable version of the temporal expression.
    def inspect
      "it is not the case that " + @term.inspect
    end

    # Encode the temporal expression into +codes+.
    def encode(codes)
      @term.encode(codes)
      codes << encoding_token
    end
  end
end
