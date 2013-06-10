module TExp
  class Expression

    # Combine two temporal expressions so that the result will match
    # the union of the dates matched by the individual temporal
    # expressions.
    #
    # <b>Examples:</b>
    #
    #    dow(:monday) + dow(:tuesday) # Match any date falling on Monday or Tuesday
    #
    def +(texp)
      TExp::Or.new(self, texp)
    end

    # Combine two temporal expressions so that the result will match
    # the intersection of the dates matched by the individual temporal
    # expressions.
    #
    # <b>Examples:</b>
    #
    #    month("Feb") * day(14) # Match the 14th of February (in any year)
    #
    def *(texp)
      TExp::And.new(self, texp)
    end

    # Combine two temporal expressions so that the result will match
    # the any date matched by left expression except for dates matched
    # by the right expression.
    #
    # <b>Examples:</b>
    #
    #    month("Feb") - dow(:mon)    # Match any day in February except Mondays
    #
    def -(texp)
      TExp::And.new(self, TExp::Not.new(texp))
    end

    # Return a new temporal expression that negates the sense of the
    # current expression.  In other words, match everything the
    # current expressions does not match and don't match anything that
    # it does.
    #
    # <b>Examples:</b>
    #
    #    -dow(:mon)    # Match everything but Mondays
    #
    def -@()
      TExp::Not.new(self)
    end
  end
end
