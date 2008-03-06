module TExp
  class DayInterval < Base
    register_parse_callback('i')

    def initialize(base_date, interval)
      @base_date = base_date
      @interval = interval
    end

    def include?(date)
      ((date.mjd - base_mjd) % @interval) == 0
    end

    def inspect
      if @interval == 1
        "every day starting on #{humanize_date(@base_date)}"
      else
        "every #{ordinal(@interval)} day starting on #{humanize_date(@base_date)}"
      end
    end

    def encode(codes)
      encode_date(codes, @base_date)
      codes << ',' << @interval << 'i'
    end

    def to_hash
      { "type" => "i", "i1" => @base_date.to_s, "i2" => @interval.to_s }
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
