module TExp
  class MonthInterval < DayInterval
    register_parse_callback('c')

    def day_multiplier
      28
    end
    
    def interval_unit
      "month"
    end
    
    def inspect
      case interval
      when 1
        "once per month"
      when 0.5
        base = "twice per month"
      when 0.25
        base = "4 times per month"
      else
        base = super
      end
      base + " (#{interval * day_multiplier} days)"
    end
    

  end
end
