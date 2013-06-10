require 'test_helper'

class LogicTest < Minitest::Test

  DATE = Date.parse("Feb 14, 2008")
  LEFT = TExp::DayInterval.new(DATE, 2)
  RIGHT = TExp::DayInterval.new(DATE, 3)
  TT = DATE
  TF = DATE+2
  FT = DATE+3
  FF = DATE+1

  def test_constants
    assert LEFT.includes?(TT)
    assert LEFT.includes?(TF)
    assert ! LEFT.includes?(FT)
    assert ! LEFT.includes?(FF)
    assert RIGHT.includes?(TT)
    assert RIGHT.includes?(FT)
    assert ! RIGHT.includes?(TF)
    assert ! RIGHT.includes?(FF)
  end

  def test_and
    te = TExp::And.new(LEFT, RIGHT, LEFT, RIGHT)
    assert te.includes?(TT)
    assert ! te.includes?(FT)
    assert ! te.includes?(TF)
    assert ! te.includes?(FF)
  end

  def test_or
    te = TExp::Or.new(LEFT, RIGHT, LEFT, RIGHT)
    assert te.includes?(TT)
    assert te.includes?(FT)
    assert te.includes?(TF)
    assert ! te.includes?(FF)
  end

  def test_not
    te = TExp::Not.new(LEFT)
    assert ! te.includes?(TT)
    assert te.includes?(FF)
  end

end
