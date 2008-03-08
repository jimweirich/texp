class Time
  unless Time.now.respond_to?(:to_date)
    def to_date
      Date.new(self.year, self.month, self.day)
    end
  end
end
