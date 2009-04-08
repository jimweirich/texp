#!/usr/bin/env ruby

require 'test/texp_tests'

class WeekIntervalTest < Test::Unit::TestCase

  def test_week_interval
    te = TExp::WeekInterval.new(Date.parse("Feb 10, 2008"), 1)
    assert ! te.includes?(Date.parse("Feb 9, 2008"))
    assert te.includes?(Date.parse("Feb 10, 2008"))
    assert ! te.includes?(Date.parse("Feb 11, 2008"))
    assert ! te.includes?(Date.parse("Feb 12, 2008"))
    assert ! te.includes?(Date.parse("Feb 16, 2008"))
    assert te.includes?(Date.parse("Feb 17, 2008"))
    assert ! te.includes?(Date.parse("Feb 18, 2008"))
    assert ! te.includes?(Date.parse("Feb 23, 2008"))
    assert te.includes?(Date.parse("Feb 24, 2008"))
    assert ! te.includes?(Date.parse("Feb 25, 2008"))
  end

  def test_day_interval_without_start_date
    te = TExp::DayInterval.new(0, 3)
    assert ! te.includes?(Date.parse("Feb 10, 2008"))
    assert_equal "0,3i", te.to_s
    assert_equal "0,3i", TExp.parse("0,3i").to_s
  end

  def test_day_interval_excludes_dates_before_start
    date = d("Mar 1, 2008")
    te = TExp::DayInterval.new(date, 3)

    assert_not_includes te, date-3, date-2, date-1
  end
end

