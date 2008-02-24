module TExp
  class DayOfMonth < Base
    register_parse_callback('d')

    def initialize(days)
      @days = listize(days)
    end

    def include?(date)
      @days.include?(date.day)
    end

    def inspect
      "the day of the month is the " +
        ordinal_list(@days)
    end

    def encode(codes)
      encode_list(codes, @days)
      codes << 'd'
    end

    def to_hash
      { "type" => 'd', 'd1' => @days.map { |d| d.to_s } }
    end
  end
end
