module TExp
  class << self
    def from_db(string)
      stack = []
      string.split(":").each do |code|
        case code
        when /^\d+$/
          stack.push(code.to_i)
        when /^\d\d\d\d-\d\d-\d\d$/
          stack.push(Date.parse(code))
        when 'x'
          n = stack.pop
          args = []
          n.times do args.unshift(stack.pop) end
          stack.push args
        when 'e'
          stack.push TExp::EveryDay.new
        when 'm'
          stack.push TExp::DayOfMonth.new(stack.pop)
        when 'w'
          stack.push TExp::DayOfWeek.new(stack.pop)
        when 'i'
          interval = stack.pop
          date = stack.pop
          stack.push TExp::DayInterval.new(date, interval)
        when 'a'
          right = stack.pop
          left = stack.pop
          stack.push(TExp::And.new(left, right))
        when 'o'
          right = stack.pop
          left = stack.pop
          stack.push(TExp::Or.new(left, right))
        else
          fail "Unknown TExp DB Code"
        end
      end
      stack.pop
    end
  end
end
