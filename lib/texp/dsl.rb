module TExp
  # DSL methods are available as methods on TExp (e.g. +TExp.day()+).
  # Alternatively, you can include the +TExp::Builder+ module into
  # whatever namespace to get direct access to these methods.
  #
  module DSL

    # Return a temporal expression that matches any date that falls on
    # a day of the month given in the argument list.
    # Examples:
    #
    #    day(1)       # Match any date that falls on the 1st of any month
    #    day(1, 15)   # Match any date that falls on the 1st or 15th of any month
    #
    def day(*days_of_month)
      TExp::DayOfMonth.new(days_of_month)
    end

    # Return a temporal expression that matches any date in the
    # specified week of the month.  Days 1 through 7 are considered
    # the first week of the month; days 8 through 14 are the second
    # week; and so on.
    #
    # The week is specified by a numeric argument.  Negative arguments
    # are calculated from the end of the month (e.g. -1 would request
    # the _last_ 7 days of the month).  The symbols <tt>:first</tt>,
    # <tt>:second</tt>, <tt>:third</tt>, <tt>:fourth</tt>,
    # <tt>:fifth</tt>, and <tt>:last</tt> are also recognized.
    #
    # Examples:
    #
    #   week(1)       # Match any date in the first 7 days of any month.
    #   week(1, 2)    # Match any date in the first or second 7 days of any month.
    #   week(:first)  # Match any date in the first 7 days of any month.
    #   week(:last)   # Match any date in the last 7 days of any month.
    #
    def week(*weeks)
      TExp::Week.new(Util.normalize_weeks(weeks))
    end

    # Return a temporal expression that matches any date in the list
    # of given months.
    #
    # <b>Examples:</b>
    #
    #   month(2)              # Match any date in February
    #   month(2, 8)           # Match any date in February or August
    #   month("February")     # Match any date in February
    #   month("Sep", "Apr", "Jun", "Nov")
    #                         # Match any date in any month with 30 days.
    #
    def month(*month)
      TExp::Month.new(Util.normalize_months(month))
    end

    # Return a temporal expression that matches the given list of
    # years.
    #
    # <b>Examples:</b>
    #
    #   year(2008)              # Match any date in 2008
    #   year(2000, 2004, 2008)  # Match any date in any of the three years
    def year(*years)
      TExp::Year.new(years)
    end

    # :call-seq:
    #   on(day, month)
    #   on(day, month_string)
    #   on(day, month, year)
    #   on(day, month_string, year)
    #   on(date)
    #   on(date_string)
    #   on(time)
    #   on(object_with_to_date)
    #   on(object_with_to_s)
    #
    # Return a temporal expression that matches a particular date of
    # the year.  The temporal expression will be pinned to a
    # particular year if a year is given (either explicity as a
    # parameter or implicitly via a +Date+ object).  If no year is
    # given, then the temporal expression will match that date in any
    # year.
    #
    # If only a single argument is given, then the argument may be a
    # string (which is parsed), a Date, a Time, or an object that
    # responds to +to_date+.  If the single argument is none of the
    # above, then it is converted to a string (via +to_s+) and given
    # to <tt>Date.parse()</tt>.
    #
    # Invalid arguments will cause +on+ to throw an ArgumentError
    # exception.
    #
    # <b>Examples:</b>
    #
    # The following examples all match Feb 14 of any year.
    #
    #   on(14, 2)
    #   on(14, "February")
    #   on(14, "Feb")
    #   on(14, :feb)
    #
    # The following examples all match Feb 14 of the year 2008.
    #
    #   on(14, 2, 2008)
    #   on(14, "February", 2008)
    #   on(14, "Feb", 2008)
    #   on(14, :feb, 2008)
    #   on("Feb 14, 2008")
    #   on(Date.new(2008, 2, 14))
    #
    def on(*args)
      if args.size == 1
        arg = args.first
        case arg
        when String
          date = Date.parse(arg)
        when Date
          date = arg
        else
          if arg.respond_to?(:to_date)
            date = arg.to_date
          else
            date = Util.try_parsing(arg.to_s)
          end
        end
        on(date.day, date.month, date.year)
      elsif args.size == 2
        day, month = Util.dm_args(args)
        TExp::And.new(
          TExp::DayOfMonth.new(day),
          TExp::Month.new(month))
      elsif args.size == 3
        day, month, year = Util.dmy_args(args)
        TExp::And.new(
          TExp::DayOfMonth.new(day),
          TExp::Month.new(Util.normalize_month(month)),
          TExp::Year.new(year))
      else
        fail DateArgumentError
      end
    rescue DateArgumentError
      fail ArgumentError, "Invalid arguents for on(): #{args.inspect}"
    end

    # Return a temporal expression matching the given days of the
    # week.
    #
    # <b>Examples:</b>
    #
    #   dow(2)                 # Match any date on a Tuesday
    #   dow("Tuesday")         # Match any date on a Tuesday
    #   dow(:mon, :wed, :fr)   # Match any date on a Monday, Wednesday or Friday
    #
    def dow(*dow)
      TExp::DayOfWeek.new(Util.normalize_dows(dow))
    end

    def every(n, unit, start_date=Date.today)
      value = Util.apply_units(unit, n)
      TExp::DayInterval.new(start_date, value)
    end
  end

  extend DSL
end

# Evaluate a temporal expression in the TExp environment.  Methods
# that are not found in the TExp environment will be redirected to the
# calling environment automatically.
#
# <b>Example:</b>
#
#   texp { day(1) * month(:feb) }   # Match the first of February (any year)
#
def texp(&block)
  TExp::DSL::Util.evaluate_expression_in_environment(&block)
end
