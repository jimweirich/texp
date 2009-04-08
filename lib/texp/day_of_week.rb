module TExp
  class DayOfWeek < Base
    attr_reader :days
    
    register_parse_callback('w')

    def initialize(days)
      @days = listize(days)
    end

    # Is +date+ included in the temporal expression.
    def includes?(date)
      @days.include?(date.wday)
    end

    # Human readable version of the temporal expression.
    def inspect
      "on " +
        humanize_list(@days, "and") { |d| Date::DAYNAMES[d] }
    end

    # Encode the temporal expression into +codes+.
    def encode(codes)
      encode_list(codes, @days)
      codes << encoding_token
    end
  end
end
