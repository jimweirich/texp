require 'test_helper'

class DayOfWeekTest < Minitest::Test

  def test_day_of_week_include_with_one_day
    te = TExp::DayOfWeek.new([1])
    assert ! te.includes?(Date.parse("Feb 10, 2008"))
    assert te.includes?(Date.parse("Feb 11, 2008"))
    assert ! te.includes?(Date.parse("Feb 12, 2008"))
    assert ! te.includes?(Date.parse("Feb 13, 2008"))
    assert ! te.includes?(Date.parse("Feb 14, 2008"))
    assert ! te.includes?(Date.parse("Feb 15, 2008"))
    assert ! te.includes?(Date.parse("Feb 16, 2008"))
  end

  def test_day_of_week_include_with_several_days
    te = TExp::DayOfWeek.new([1, 3, 5])
    assert ! te.includes?(Date.parse("Feb 10, 2008"))
    assert te.includes?(Date.parse("Feb 11, 2008"))
    assert ! te.includes?(Date.parse("Feb 12, 2008"))
    assert te.includes?(Date.parse("Feb 13, 2008"))
    assert ! te.includes?(Date.parse("Feb 14, 2008"))
    assert te.includes?(Date.parse("Feb 15, 2008"))
    assert ! te.includes?(Date.parse("Feb 16, 2008"))
  end
end
