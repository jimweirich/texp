require 'test_helper'

class TimeExtTest < Minitest::Test
  def test_time_to_date
    assert_equal Date.today, Time.now.to_date
  end
end
