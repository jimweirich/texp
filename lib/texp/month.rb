module TExp
  class Month < Base
    register_parse_callback('m')

    def initialize(months)
      @months = listize(months)
    end

    def include?(date)
      @months.include?(date.month)
    end

    def inspect
      "the month is " +
        humanize_list(@months) { |m| Date::MONTHNAMES[m] }
    end

    def encode(codes)
      encode_list(codes, @months)
      codes << 'm'
    end
  end
end
