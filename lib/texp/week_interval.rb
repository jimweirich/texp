module TExp
  class WeekInterval < DayInterval
    register_parse_callback('b')

    def day_multiplier
      7
    end
    
    def interval_unit
      "week"
    end
  end
end
