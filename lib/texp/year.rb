module TExp
  class Year < Expression
    register_parse_callback('y')

    def initialize(years)
      @years = listize(years)
    end

    # Is +date+ included in the temporal expression.
    def includes?(date)
      @years.include?(date.year)
    end

    # Human readable version of the temporal expression.
    def inspect
      "the year is " + humanize_list(@years)
    end

    # Encode the temporal expression into +codes+.
    def encode(codes)
      encode_list(codes, @years)
      codes << encoding_token
    end

  end
end
