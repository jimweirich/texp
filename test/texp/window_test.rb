#!/usr/bin/env ruby

require 'date'
require 'test/unit'
require 'texp'

class WindowTest < Test::Unit::TestCase

  def test_window
    wed = TExp.parse("3w")
    te = TExp::Window.new(wed, 2, 1)
    assert ! te.include?(Date.parse("Mar 2, 2008"))
    assert   te.include?(Date.parse("Mar 3, 2008"))
    assert   te.include?(Date.parse("Mar 4, 2008"))
    assert   te.include?(Date.parse("Mar 5, 2008"))
    assert   te.include?(Date.parse("Mar 6, 2008"))
    assert ! te.include?(Date.parse("Mar 7, 2008"))
  end

  def test_narrow_window
    wed = TExp.parse("3w")
    te = TExp::Window.new(wed, 0, 0)
    assert ! te.include?(Date.parse("Mar 2, 2008"))
    assert ! te.include?(Date.parse("Mar 3, 2008"))
    assert ! te.include?(Date.parse("Mar 4, 2008"))
    assert   te.include?(Date.parse("Mar 5, 2008"))
    assert ! te.include?(Date.parse("Mar 6, 2008"))
    assert ! te.include?(Date.parse("Mar 7, 2008"))
  end

end

