module TExp

  ####################################################################
  # Logically AND a list of temporal expressions.  A date is included
  # only if it is included in all of the sub-expressions.
  class And < MultiTermBase
    register_parse_callback('a')

    # Is +date+ included in the temporal expression.
    def includes?(date)
      @terms.all? { |te| te.includes?(date) }
    end

    # Human readable version of the temporal expression.
    def inspect
      humanize_list(@terms, "and") { |item| item.inspect }
    end

    # Encode the temporal expression into +codes+.
    def encode(codes)
      encode_list(codes, @terms)
      codes << encoding_token
    end
  end # class And

  ####################################################################
  # Logically OR a list of temporal expressions.  A date is included
  # if it is included in any of the sub-expressions.
  class Or < MultiTermBase
    register_parse_callback('o')

    # Is +date+ included in the temporal expression.
    def includes?(date)
      @terms.any? { |te| te.includes?(date) }
    end

    # Human readable version of the temporal expression.
    def inspect
      humanize_list(@terms) { |item| item.inspect }
    end

    # Encode the temporal expression into +codes+.
    def encode(codes)
      encode_list(codes, @terms)
      codes << encoding_token
    end
  end # class Or

  ####################################################################
  # Logically NEGATE a temporal expression.  A date is included if it
  # is not included in the sub-expression.
  class Not < SingleTermBase
    register_parse_callback('n')

    # Is date included in the temporal expression.
    def includes?(date)
      ! @term.includes?(date)
    end

    # Human readable version of the temporal expression.
    def inspect
      "it is not the case that " + @term.inspect
    end

    # Encode the temporal expression into +codes+.
    def encode(codes)
      @term.encode(codes)
      codes << encoding_token
    end
  end # class Not
  
end
