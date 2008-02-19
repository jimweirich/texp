module TExp
  class DayOfMonth < Base
    register_parse_callback('d', self)

    def initialize(days)
      @days = listize(days)
    end

    def include?(date)
      @days.include?(date.day)
    end

    def encode(codes)
      encode_list(codes, @days)
      codes << 'd'
    end
  end
end
