module TExp
  class DayInterval < Base
    register_parse_callback('i', self)

    def initialize(base_date, interval)
      @base_date = base_date
      @interval = interval
    end

    def include?(date)
      ((date.mjd - base_mjd) % @interval) == 0
    end

    def encode(codes)
      encode_date(codes, @base_date)
      codes << ',' << @interval << 'i'
    end

    private

    def base_mjd
      @base_date.mjd
    end

    def formatted_date
      @base_date.strftime("%Y-%m-%d")
    end

    class << self
      def parse_callback(stack)
        interval = stack.pop
        date = stack.pop
        stack.push TExp::DayInterval.new(date, interval)
      end
    end
  end
end
