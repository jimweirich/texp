require 'test/unit'
require 'texp'

class BaseEachTest < Test::Unit::TestCase
  def test_each_on_base
    te = basic_texp
    assert_equal [te], te.collect { |t| t }
  end

  def test_each_on_single_term
    te = single_term_texp
    assert_equal [@basic, @single], te.collect { |t| t }
  end

  def test_each_on_multi_term
    te = multi_term_texp
    assert_equal [@basic, @multi], te.collect { |t| t }
  end

  def test_complains_about_include
    assert_raise RuntimeError do
      basic_texp.include? Date.parse("Feb 1, 2009")
    end
  end

  private

  def basic_texp
    @basic = TExp::DayOfMonth.new(1)
  end

  def single_term_texp
    @single = TExp::Not.new(basic_texp)
  end

  def multi_term_texp
    @multi = TExp::And.new(basic_texp)
  end

end

class BaseAnchorTest < Test::Unit::TestCase
  def test_setting_anchor_date
    start_date = Date.parse("Feb 10, 2008")
    te = TExp::DayInterval.new(start_date, 3)
    assert_cycle(te, start_date, 3)

    te2 = te.reanchor(start_date+1)

    assert_cycle(te, start_date, 3)
    assert_cycle(te2, start_date+1, 3)
  end

  def assert_cycle(te, start_date, n)
    (0...2*n).each do |i|
      if (i % n) == 0
        assert te.includes?(start_date + i)
      else
        assert ! te.includes?(start_date + i)
      end
    end
  end

  def test_that_complex_expression_propagate_anchor_date
    start_date = Date.parse("Feb 14, 2008")
    two_day_cycle = TExp::DayInterval.new(start_date, 2)
    three_day_cycle = TExp::DayInterval.new(start_date, 3)
    year_2008 = TExp::Year.new(2008)

    te = TExp::And.new(
      year_2008,
      TExp::Or.new(two_day_cycle, TExp::Not.new(three_day_cycle)))

    new_date = Date.parse("Feb 15, 2008")
    te2 = te.reanchor(new_date)

    assert_complex_cycle(te, start_date)
    assert_complex_cycle(te2, new_date)
  end

  def assert_complex_cycle(te, start_date)
    assert te.includes?(start_date)
    assert te.includes?(start_date+1)
    assert te.includes?(start_date+2)
    assert ! te.includes?(start_date+3)
    assert te.includes?(start_date+4)
  end
end
