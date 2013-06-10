require 'texp/date_part_expression'

module TExp
  class DayOfMonth < DatePartExpression
    register_parse_callback('d')

    # Human readable version of the temporal expression.
    def inspect
      "the day of the month is the " + ordinal_list(@parts)
    end

    private

    def extract_part(date)
      date.day
    end
  end
end
