require 'test_helper'

class YearTest < Minitest::Test

  def setup
    @date = Date.parse("Feb 14, 2008")
  end

  def test_single_arg
    te = TExp::Year.new(2008)
    assert te.includes?(@date)
    assert te.includes?(@date + 30)
    assert ! te.includes?(@date + 365)
  end

  def test_two_args
    te = TExp::Year.new([2007,2008])
    assert te.includes?(@date - 365)
    assert te.includes?(@date)
    assert te.includes?(@date + 30)
    assert ! te.includes?(@date + 365)
  end
end
