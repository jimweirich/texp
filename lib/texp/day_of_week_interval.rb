# To change this template, choose Tools | Templates
# and open the template in the editor.
module TExp
  class DayOfWeekInterval < And
    register_parse_callback('q')
    def initialize(*args)
      if args.size == 3
        day, week_interval, start_date = args[0..2]
        @day_texp = DayOfWeek.new(day)
        @week_interval_texp = WeekInterval.new(
          find_day_of_week_on_or_after(start_date, day),
          week_interval
        )
        super(@day_texp, @week_interval_texp)
      else
        @day_texp, @week_interval_texp = args[0], args[1]
        super(@day_texp, @week_interval_texp)
      end
    end

    def find_day_of_week_on_or_after(date, day_of_week)
      raise ArgumentError, "#{day_of_week} is not a valid day of week" unless
      (0..6).to_a.include? day_of_week
      while date.wday != day_of_week
        date = date + 1
      end
      date
    end

    def reanchor(date)
      super(find_day_of_week_on_or_after(date, @day_texp.days[0]))
    end

    def inspect
      "#{@week_interval_texp.inspect} #{@day_texp.inspect}"
    end
  end
end
