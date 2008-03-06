module TExp
  class Window < Base
    register_parse_callback('s')

    def initialize(texp, prewindow_days, postwindow_days)
      @texp = texp
      @prewindow_days = prewindow_days
      @postwindow_days = postwindow_days      
    end

    def include?(date)
      @texp.include?(date) ||
        (1..@prewindow_days).any? { |i| @texp.include?(date + i) } ||
        (1..@postwindow_days).any? { |i| @texp.include?(date - i) }
    end

    def inspect
      "TBD"
    end

    def encode(codes)
      @texp.encode(codes)
      codes << @prewindow_days << "," << @postwindow_days << "s"
    end

    def to_hash
    end

    class << self
      def parse_callback(stack)
        postwindow = stack.pop
        prewindow = stack.pop
        te = stack.pop
        stack.push TExp::Window.new(te, prewindow, postwindow)
      end
    end # class << self

  end
end
