module TExp
  class Month < Base
    register_parse_callback('m')

    def initialize(months)
      @months = listize(months)
    end

    # Is +date+ included in the temporal expression.
    def include?(date)
      @months.include?(date.month)
    end

    # Human readable version of the temporal expression.
    def inspect
      "the month is " +
        humanize_list(@months) { |m| Date::MONTHNAMES[m] }
    end

    # Encode the temporal expression into +codes+.
    def encode(codes)
      encode_list(codes, @months)
      codes << encoding_token
    end

    def to_hash
      build_hash do |b|
        b.with @months
      end
    end
  end
end
