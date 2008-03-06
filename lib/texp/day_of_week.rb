module TExp
  class DayOfWeek < Base
    register_parse_callback('w')

    def initialize(days)
      @days = listize(days)
    end

    # Is +date+ included in the temporal expression.
    def include?(date)
      @days.include?(date.wday)
    end

    # Human readable version of the temporal expression.
    def inspect
      "the day of the week is " +
        humanize_list(@days) { |d| Date::DAYNAMES[d] }
    end

    def to_hash
      build_hash do |b|
        b.with(@days)
      end
    end

    # Encode the temporal expression into +codes+.
    def encode(codes)
      encode_list(codes, @days)
      codes << encoding_token
    end
  end
end
