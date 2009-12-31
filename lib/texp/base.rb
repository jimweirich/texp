module TExp
  
  class TExpError < StandardError
  end
  
  class TExpIncludeError < TExpError
  end

  ####################################################################
  # Abstract Base class for all Texp Temporal Expressions.
  class Base
    include Enumerable
    
    # Convert the temporal expression into an encoded string (that can
    # be parsed by TExp.parse).
    def to_s
      codes = []
      encode(codes)
      codes.join("")
    end

    def include?(*args)
      raise TExpIncludeError, "Use includes? rather than include?"
    end

    # Create a new temporal expression with a new anchor date.
    def reanchor(date)
      self
    end

    # Return the first day of the window for the temporal expression.
    # If the temporal expression is not a windowed expression, then
    # the first day of the window is the given date.
    def first_day_of_window(date)
      includes?(date) ? date : nil
    end

    # Return the last day of the window for the temporal expression.
    # If the temporal expression is not a windowed expression, then
    # the last day of the window is the given date.
    def last_day_of_window(date)
      includes?(date) ? date : nil
    end

    # Iterate over all temporal expressions and subexpressions (in
    # post order).
    def each()                  # :yield: temporal_expression
      yield self
    end
    
    # :call-seq:
    #   window(days)
    #   window(predays, postdays)
    #   window(n, units)
    #   window(pre, pre_units, post, post_units)
    #
    # Create a new temporal expression that matches a window around
    # any date matched by the current expression.
    #
    # If a single numeric value is given, then a symetrical window of
    # the given number of days is created around each date matched by
    # the current expression.  If a symbol representing units is given
    # in addition to the numeric, then the appropriate scale factor is
    # applied to the numeric value.
    #
    # If two numberic values are given (with or without unit symbols),
    # then the window will be asymmetric.  The firsts numeric value
    # will be the pre-window, and the second numeric value will be the
    # post window.
    #
    # The following unit symbols are recognized:
    #
    # * :day, :days   (scale by 1)
    # * :week, :weeks (scale by 7)
    # * :month, :months (scale by 30)
    # * :year, :years (scale by 365)
    #
    # <b>Examples:</b>
    #
    #   texp.window(3)         # window of 3 days on either side
    #   texp.window(3, :days)  # window of 3 days on either side
    #   texp.window(1, :week)  # window of 1 week on either side
    #   texp.window(3, :days, 2, :weeks)
    #                          # window of 3 days before any match,
    #                          # and 2 weeks after any match.
    #
    def window(*args)
      prewindow, postwindow = TExp.normalize_units(args)
      postwindow ||= prewindow
      TExp::Window.new(self, prewindow, postwindow)
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
    }                           # :nodoc:

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
    end # class << self
  end # class Base

  ####################################################################
  # Base class for temporal expressions with a single sub-expressions
  # (i.e. term).
  class SingleTermBase < Base
    # Create a single term temporal expression.
    def initialize(term)
      @term = term
    end

    # Create a new temporal expression with a new anchor date.
    def reanchor(date)
      new_term = @term.reanchor(date)
      (@term == new_term) ? self : self.class.new(new_term)
    end

    # Iterate over all temporal expressions and subexpressions (in
    # post order).
    def each()                  # :yield: temporal_expression
      yield @term
      yield self
    end
  end # class SingleTermBase

  ####################################################################
  # Base class for temporal expressions with multiple sub-expressions
  # (i.e. terms).
  class MultiTermBase < Base

    # Create an multi-term temporal expression.
    def initialize(*terms)
      @terms = terms
    end

    # Create a new temporal expression with a new anchor date.
    def reanchor(date)
      new_terms = @terms.collect { |term| term.reanchor(date) }
      if new_terms == @terms
        self
      else
        self.class.new(*new_terms)
      end
    end

    # Iterate over all temporal expressions and subexpressions (in
    # post order).
    def each()                  # :yield: temporal_expression
      @terms.each do |term| yield term end
      yield self
    end

    class << self
      # Parsing callback for terms based temporal expressions.  The
      # top of the stack is assumed to be a list that is *-expanded to
      # the temporal expression's constructor.
      def parse_callback(stack)
        stack.push self.new(*stack.pop)
      end
    end
  end # class << self

end # class MultiTermBase
