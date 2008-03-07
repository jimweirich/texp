#!/usr/bin/env ruby

require 'test/unit'
require 'date'
require 'texp'

class DayIntervalTest < Test::Unit::TestCase

  def test_day_interval
    te = TExp::DayInterval.new(Date.parse("Feb 10, 2008"), 3)
    assert te.include?(Date.parse("Feb 10, 2008"))
    assert ! te.include?(Date.parse("Feb 11, 2008"))
    assert ! te.include?(Date.parse("Feb 12, 2008"))
    assert te.include?(Date.parse("Feb 13, 2008"))
    assert ! te.include?(Date.parse("Feb 14, 2008"))
    assert ! te.include?(Date.parse("Feb 15, 2008"))
    assert te.include?(Date.parse("Feb 16, 2008"))
    assert ! te.include?(Date.parse("Feb 17, 2008"))
    assert ! te.include?(Date.parse("Feb 18, 2008"))
  end

  def test_setting_anchor_date
    te = TExp::DayInterval.new(Date.parse("Feb 10, 2008"), 3)
    te.set_anchor_date(Date.parse("Feb 11, 2008"))
    assert ! te.include?(Date.parse("Feb 10, 2008"))
    assert te.include?(Date.parse("Feb 11, 2008"))
    assert ! te.include?(Date.parse("Feb 12, 2008"))
    assert ! te.include?(Date.parse("Feb 13, 2008"))
    assert te.include?(Date.parse("Feb 14, 2008"))    
  end

  def test_that_complex_expression_propagate_anchor_date
    two_day_cycle = TExp::DayInterval.new(Date.parse("Feb 14, 2008"), 2)
    three_day_cycle = TExp::DayInterval.new(Date.parse("Feb 14, 2008"), 3)
    year_2008 = TExp::Year.new(2008)

    te = TExp::And.new(
      year_2008,
      TExp::Or.new(two_day_cycle, TExp::Not.new(three_day_cycle)))

    new_date = Date.parse("Mar 23, 2008")
    te.set_anchor_date(new_date)
    assert_equal new_date, two_day_cycle.base_date
    assert_equal new_date, three_day_cycle.base_date
  end
end

