#!/usr/bin/env ruby

require 'date'
require 'test/unit'
require 'texp'

class WindowTest < Test::Unit::TestCase

  def test_window
    wed = TExp.parse("3w")
    te = TExp::Window.new(wed, 2, 1)
    assert ! te.includes?(Date.parse("Mar 2, 2008"))
    assert   te.includes?(Date.parse("Mar 3, 2008"))
    assert   te.includes?(Date.parse("Mar 4, 2008"))
    assert   te.includes?(Date.parse("Mar 5, 2008"))
    assert   te.includes?(Date.parse("Mar 6, 2008"))
    assert ! te.includes?(Date.parse("Mar 7, 2008"))
  end

  def test_narrow_window
    wed = TExp.parse("3w")
    te = TExp::Window.new(wed, 0, 0)
    assert ! te.includes?(Date.parse("Mar 2, 2008"))
    assert ! te.includes?(Date.parse("Mar 3, 2008"))
    assert ! te.includes?(Date.parse("Mar 4, 2008"))
    assert   te.includes?(Date.parse("Mar 5, 2008"))
    assert ! te.includes?(Date.parse("Mar 6, 2008"))
    assert ! te.includes?(Date.parse("Mar 7, 2008"))
  end

  def test_window_reporting
    mar5 = Date.parse("Mar 5, 2008")
    wed = TExp.parse("3w")
    te = TExp::Window.new(wed, 2, 1)

    assert_equal mar5-2, te.first_day_of_window(mar5)
    assert_equal mar5+1, te.last_day_of_window(mar5)
  end

  def test_window_reporting_when_outside_window
    mar5 = Date.parse("Mar 8, 2008")
    wed = TExp.parse("3w")
    te = TExp::Window.new(wed, 2, 1)

    assert_nil te.first_day_of_window(mar5)
    assert_nil te.last_day_of_window(mar5)
  end

  def test_windows_on_non_window_temporal_expressions
    mar5 = Date.parse("Mar 5, 2008")
    te = TExp.parse("3w")

    assert_equal mar5, te.first_day_of_window(mar5)
    assert_equal mar5, te.last_day_of_window(mar5)

    assert_nil te.first_day_of_window(mar5+1)
    assert_nil te.last_day_of_window(mar5+1)
  end

end

