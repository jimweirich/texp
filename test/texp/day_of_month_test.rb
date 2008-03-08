#!/usr/bin/env ruby

require 'date'
require 'test/unit'
require 'texp'

class DayOfMonthTest < Test::Unit::TestCase

  def test_day_of_month_with_single_arg
    te = TExp::DayOfMonth.new(14)
    assert te.includes?(Date.parse("Dec 14, 2006"))
    assert te.includes?(Date.parse("Feb 14, 2008"))
    assert ! te.includes?(Date.parse("Feb 15, 2008"))
  end

  def test_day_of_include_with_one_day
    te = TExp::DayOfMonth.new([10, 14, 16])
    assert te.includes?(Date.parse("Feb 10, 2008"))
    assert ! te.includes?(Date.parse("Feb 11, 2008"))
    assert ! te.includes?(Date.parse("Feb 12, 2008"))
    assert ! te.includes?(Date.parse("Feb 13, 2008"))
    assert te.includes?(Date.parse("Feb 14, 2008"))
    assert ! te.includes?(Date.parse("Feb 15, 2008"))
    assert te.includes?(Date.parse("Feb 16, 2008"))
  end
end

