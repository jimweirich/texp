require 'texp/date_part_expression'

module TExp
  class Month < DatePartExpression
    register_parse_callback('m')

    # Human readable version of the temporal expression.
    def inspect
      "the month is " +
        humanize_list(@parts) { |m| Date::MONTHNAMES[m] }
    end

    private

    def extract_part(date)
      date.month
    end
  end
end
