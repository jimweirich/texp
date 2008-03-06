module TExp
  class DayOfMonth < Base
    register_parse_callback('d')

    def initialize(days)
      @days = listize(days)
    end

    # Is +date+ included in the temporal expression.
    def include?(date)
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

    def to_hash
      build_hash do |b|
        b.with(@days.map { |d| d.to_s })
      end
    end
  end
end
