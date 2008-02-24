require 'date'

module TExp
  class Week < Base
    register_parse_callback('k')

    def initialize(weeks)
      @weeks = listize(weeks)
    end

    def include?(date)
      @weeks.include?(week_from_front(date)) ||
        @weeks.include?(week_from_back(date))
    end

    def encode(codes)
      encode_list(codes, @weeks)
      codes << 'k'
    end

    def inspect
      "it is the " + ordinal_list(@weeks) + " week of the month"
    end

    def to_hash
      { 'type' => 'k', 'k1' => @weeks.map { |w| w.to_s } }
    end

    private

    def week_from_front(date)
      week = ((date.day-1) / 7) + 1
    end

    def week_from_back(date)
      last_day = last_day_of_month(date)
      -(((last_day - date.day) / 7) + 1)
    end

    def self.days_in_month(month)
      d = Date.new(2007, month, 1) + 31
      while d.day < 27
        d -= 1
      end
      d.day
    end

    DAYS_IN_MONTH = [ 0 ] +
      (1..12).collect { |m| days_in_month(m) }

    def last_day_of_month(date)
      DAYS_IN_MONTH[date.month] +
        (date.month == 2 && Date.leap?(date.year) ? 1 : 0)
    end
  end
end
