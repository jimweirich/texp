module TExp
  class DatePartExpression < Expression
    def initialize(part)
      @parts = listize(part)
    end

    # Is +date+ included in the temporal expression.
    def includes?(date)
      @parts.include?(extract_part(date))
    end

    # Encode the temporal expression into +codes+.
    def encode(codes)
      encode_list(codes, @parts)
      codes << encoding_token
    end
  end
end
