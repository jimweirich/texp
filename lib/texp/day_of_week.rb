module TExp
  class DayOfWeek < Base
    register_parse_callback('w')

    def initialize(days)
      @days = listize(days)
    end

    def include?(date)
      @days.include?(date.wday)
    end

    def inspect
      "the day of the week is " +
        humanize_list(@days) { |d| Date::DAYNAMES[d] }
    end

    def encode(codes)
      encode_list(codes, @days)
      codes << 'w'
    end
  end
end
