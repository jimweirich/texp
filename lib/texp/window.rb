module TExp
  class Window < SingleTermExpression
    register_parse_callback('s')

    def initialize(texp, prewindow_days, postwindow_days)
      super(texp)
      @prewindow_days = prewindow_days
      @postwindow_days = postwindow_days
    end

    # Is +date+ included in the temporal expression.
    def includes?(date)
      find_pivot(date) != nil
    end

    # Return the first day of the window for a given date.  Return nil
    # if the date is not in a window.
    def first_day_of_window(date)
      pivot = find_pivot(date)
      pivot ? pivot - @prewindow_days : nil
    end

    # Return the first day of the window for a given date.  Return nil
    # if the date is not in a window.
    def last_day_of_window(date)
      pivot = find_pivot(date)
      pivot ? pivot + @postwindow_days : nil
    end

    # Find the matching date for the window.
    def find_pivot(date)
      d = date - @postwindow_days
      while d <= date + @prewindow_days
        return d if @term.includes?(d)
        d += 1
      end
      return nil
    end

    # Human readable version of the temporal expression.
    def inspect
      @term.inspect + ", " +
        "or up to #{days(@prewindow_days)} prior, " +
        "or up to #{days(@postwindow_days)} after"
    end

    # Encode the temporal expression into +codes+.
    def encode(codes)
      @term.encode(codes)
      codes << @prewindow_days << "," << @postwindow_days << "s"
    end

    private

    def days(n)
      n == 1 ? "#{n} day" : "#{n} days"
    end

    # Parsing callback for window temporal expressions.
    def self.parse_callback(stack)
      postwindow = stack.pop
      prewindow = stack.pop
      te = stack.pop
      stack.push TExp::Window.new(te, prewindow, postwindow)
    end
  end
end
