module TExp
  class Window < Base
    register_parse_callback('s')

    def initialize(texp, prewindow_days, postwindow_days)
      @texp = texp
      @prewindow_days = prewindow_days
      @postwindow_days = postwindow_days      
    end

    # Is +date+ included in the temporal expression.
    def include?(date)
      @texp.include?(date) ||
        (1..@prewindow_days).any? { |i| @texp.include?(date + i) } ||
        (1..@postwindow_days).any? { |i| @texp.include?(date - i) }
    end

    # Human readable version of the temporal expression.
    def inspect
      @texp.inspect + ", " +
        "or up to #{days(@prewindow_days)} prior, " +
        "or up to #{days(@postwindow_days)} after"
    end

    # Encode the temporal expression into +codes+.
    def encode(codes)
      @texp.encode(codes)
      codes << @prewindow_days << "," << @postwindow_days << "s"
    end

    def to_hash
      fail "TBD"
    end

    private

    def days(n)
      n == 1 ? "#{n} day" : "#{n} days"
    end

    class << self
      # Parsing callback for window temporal expressions.
      def parse_callback(stack)
        postwindow = stack.pop
        prewindow = stack.pop
        te = stack.pop
        stack.push TExp::Window.new(te, prewindow, postwindow)
      end
    end # class << self

  end
end
