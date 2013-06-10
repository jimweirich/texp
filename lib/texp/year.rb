require 'texp/date_part_expression'

module TExp
  class Year < DatePartExpression
    register_parse_callback('y')

    # Human readable version of the temporal expression.
    def inspect
      "the year is " + humanize_list(@parts)
    end

    private

    def extract_part(date)
      date.year
    end
  end
end
