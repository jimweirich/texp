#require 'rubygems'
require 'test/unit'
require 'texp'

# Convenience method for parsing dates.
def d(date_string)
  Date.parse(date_string)
end

module TExpAssertions
  def assert_includes(te, *dates)
    dates.each do |date|
      date = Date.parse(date) if date.kind_of?(String)
      assert te.includes?(date), "#{te} should include #{date}"
    end
  end

  def assert_not_includes(te, *dates)
    dates.each do |date|
      date = Date.parse(date) if date.kind_of?(String)
      assert ! te.includes?(date), "#{te} should not include #{date}"
    end
  end
end

class Test::Unit::TestCase
  include TExpAssertions
end
