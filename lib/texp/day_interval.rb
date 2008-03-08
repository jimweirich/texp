module TExp
  class DayInterval < Base
    register_parse_callback('i')

    attr_reader :base_date

    def initialize(base_date, interval)
      @base_date = base_date.kind_of?(Date) ? base_date : nil
      @interval = interval
    end

    # Is +date+ included in the temporal expression.
    def includes?(date)
      if @base_date
        ((date.mjd - base_mjd) % @interval) == 0
      else
        false
      end
    end

    # Create a new temporal expression with a new anchor date.
    def reanchor(new_anchor_date)
      self.class.new(new_anchor_date, @interval)
    end

    # Human readable version of the temporal expression.
    def inspect
      if @interval == 1
        "every day starting on #{humanize_date(@base_date)}"
      else
        "every #{ordinal(@interval)} day starting on #{humanize_date(@base_date)}"
      end
    end

    # Encode the temporal expression into +codes+.
    def encode(codes)
      if @base_date
        encode_date(codes, @base_date)
      else
        codes << 0
      end
      codes << ',' << @interval << encoding_token
    end

    private

    def base_mjd
      @base_date.mjd
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
