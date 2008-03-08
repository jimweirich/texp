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

end

