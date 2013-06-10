require 'test_helper'

class MonthTest < Minitest::Test

  def setup
    @date = Date.parse("Feb 14, 2008")
  end

  def test_initial_conditions
    te = TExp::Month.new(2)
    assert te.includes?(@date)
    assert te.includes?(@date + 1)
    assert ! te.includes?(@date + 30)
  end
end
