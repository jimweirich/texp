#!/usr/bin/env ruby

require 'test/unit'
require 'date'
require 'texp'

class LogicTest < Test::Unit::TestCase

  DATE = Date.parse("Feb 14, 2008")
  LEFT = TExp::DayInterval.new(DATE, 2)
  RIGHT = TExp::DayInterval.new(DATE, 3)
  TT = DATE
  TF = DATE+2
  FT = DATE+3
  FF = DATE+1

  def test_constants
    assert LEFT.include?(TT)
    assert LEFT.include?(TF)
    assert ! LEFT.include?(FT)
    assert ! LEFT.include?(FF)
    assert RIGHT.include?(TT)
    assert RIGHT.include?(FT)
    assert ! RIGHT.include?(TF)
    assert ! RIGHT.include?(FF)
  end

  def test_and
    te = TExp::And.new(LEFT, RIGHT, LEFT, RIGHT)
    assert te.include?(TT)
    assert ! te.include?(FT)
    assert ! te.include?(TF)
    assert ! te.include?(FF)
  end

  def test_or
    te = TExp::Or.new(LEFT, RIGHT, LEFT, RIGHT)
    assert te.include?(TT)
    assert te.include?(FT)
    assert te.include?(TF)
    assert ! te.include?(FF)
  end

  def test_not
    te = TExp::Not.new(LEFT)
    assert ! te.include?(TT)
    assert te.include?(FF)
  end

end

