#!/usr/bin/env ruby

require 'date'
require 'test/unit'
require 'texp'

class WeekTest < Test::Unit::TestCase

  def test_week_include_with_one_week
    te = TExp::Week.new([1])
    assert te.include?(Date.parse("Feb 1, 2008"))
    assert te.include?(Date.parse("Feb 2, 2008"))
    assert te.include?(Date.parse("Feb 3, 2008"))
    assert te.include?(Date.parse("Feb 5, 2008"))
    assert te.include?(Date.parse("Feb 6, 2008"))
    assert te.include?(Date.parse("Feb 7, 2008"))
    assert ! te.include?(Date.parse("Feb 8, 2008"))
  end

  def test_week_include_with_several_weeks
    te = TExp::Week.new([2,4])
    assert ! te.include?(Date.parse("Feb 1, 2008"))
    assert ! te.include?(Date.parse("Feb 7, 2008"))
    assert   te.include?(Date.parse("Feb 8, 2008"))
    assert   te.include?(Date.parse("Feb 14, 2008"))
    assert ! te.include?(Date.parse("Feb 15, 2008"))
    assert ! te.include?(Date.parse("Feb 21, 2008"))
    assert   te.include?(Date.parse("Feb 22, 2008"))
    assert   te.include?(Date.parse("Feb 28, 2008"))
  end

  def test_week_with_last_week_of_month
    te = TExp::Week.new([-1])
    assert !  te.include?(Date.parse("Feb 1, 2008"))
    assert !  te.include?(Date.parse("Feb 22, 2008"))
    assert   te.include?(Date.parse("Feb 23, 2008"))
    assert   te.include?(Date.parse("Feb 29, 2008"))
  end

  # Test some private methods

  def test_week_from_back
    te = TExp::Week.new([1])
    assert_equal -1, te.send(:week_from_back, Date.parse("Mar 31, 2008"))
    assert_equal -1, te.send(:week_from_back, Date.parse("Mar 25, 2008"))
    assert_equal -2, te.send(:week_from_back, Date.parse("Mar 24, 2008"))
  end

  def test_last_day_of_month
    te = TExp::Week.new([1])
    assert_equal 31, te.send(:last_day_of_month, Date.parse("Jan 21, 2008"))
    assert_equal 29, te.send(:last_day_of_month, Date.parse("Feb 21, 2008"))
    assert_equal 28, te.send(:last_day_of_month, Date.parse("Feb 21, 2007"))
    assert_equal 30, te.send(:last_day_of_month, Date.parse("Nov 1, 2007"))
    assert_equal 31, te.send(:last_day_of_month, Date.parse("Dec 1, 2007"))
  end
end

