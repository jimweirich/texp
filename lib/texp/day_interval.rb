module TExp
  class DayInterval < Base
    register_parse_callback('i')

    attr_reader :base_date, :interval

    def day_multiplier
      1
    end
    
    def interval_unit
      "day"
    end
    
    def initialize(base_date, interval)
      @base_date = base_date.kind_of?(Date) ? base_date : nil
      @interval = interval
    end

    # Is +date+ included in the temporal expression.
    def includes?(date)
      if @base_date.nil? || date < @base_date
        false
      else
        ((date.mjd - base_mjd) % (@interval * day_multiplier)) == 0
      end
    end

    # Create a new temporal expression with a new anchor date.
    def reanchor(new_anchor_date)
      self.class.new(new_anchor_date, @interval)
    end

    # Human readable version of the temporal expression.
    def inspect
      if @interval == 1
        "every #{interval_unit}"
      elsif @interval == 2
        "every other #{interval_unit}"
      else
        "every #{@interval} #{pluralize(interval_unit)}"
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

    def pluralize(word)
      "#{word}s"
    end

    def base_mjd
      @base_date.mjd
    end

    class << self
      def parse_callback(stack)
        interval = stack.pop
        date = stack.pop
        stack.push self.new(date, interval)
      end
    end
  end
end
