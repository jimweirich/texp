require 'test/texp_tests'
require 'texp'

class TimeExtTest < Test::Unit::TestCase
  def test_time_to_date
    assert_equal Date.today, Time.now.to_date
  end
end
