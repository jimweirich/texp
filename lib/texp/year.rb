module TExp
  class Year < Base
    register_parse_callback('y')

    def initialize(years)
      @years = listize(years)
    end

    # Is +date+ included in the temporal expression.
    def include?(date)
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
    
    def to_hash
      build_hash do |b|
        b.with @years
      end
    end
  end
end
