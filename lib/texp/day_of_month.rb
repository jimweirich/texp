module TExp
  class DayOfMonth < Expression
    register_parse_callback('d')

    def initialize(days)
      @days = listize(days)
    end

    # Is +date+ included in the temporal expression.
    def includes?(date)
      @days.include?(date.day)
    end

    # Human readable version of the temporal expression.
    def inspect
      "the day of the month is the " +
        ordinal_list(@days)
    end

    # Encode the temporal expression into +codes+.
    def encode(codes)
      encode_list(codes, @days)
      codes << encoding_token
    end
  end
end
