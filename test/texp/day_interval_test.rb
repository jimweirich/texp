#!/usr/bin/env ruby

require 'test/unit'
require 'date'
require 'texp'

class DayIntervalTest < Test::Unit::TestCase

  def test_day_interval
    te = TExp::DayInterval.new(Date.parse("Feb 10, 2008"), 3)
    assert te.includes?(Date.parse("Feb 10, 2008"))
    assert ! te.includes?(Date.parse("Feb 11, 2008"))
    assert ! te.includes?(Date.parse("Feb 12, 2008"))
    assert te.includes?(Date.parse("Feb 13, 2008"))
    assert ! te.includes?(Date.parse("Feb 14, 2008"))
    assert ! te.includes?(Date.parse("Feb 15, 2008"))
    assert te.includes?(Date.parse("Feb 16, 2008"))
    assert ! te.includes?(Date.parse("Feb 17, 2008"))
    assert ! te.includes?(Date.parse("Feb 18, 2008"))
  end

  def test_day_interval_without_start_date
    te = TExp::DayInterval.new(0, 3)
    assert ! te.includes?(Date.parse("Feb 10, 2008"))
    assert_equal "0,3i", te.to_s
    assert_equal "0,3i", TExp.parse("0,3i").to_s
  end

end

