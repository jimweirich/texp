require 'test_helper'

class EveryDayTest < Minitest::Test
  def test_every_day
    te = TExp::EveryDay.new
    assert te.includes?(Date.parse("Feb 15, 2008"))
  end
end
