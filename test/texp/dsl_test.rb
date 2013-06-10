require 'test_helper'

class BuilderTest < Minitest::Test
  def test_day_builder
    date = d("Mar 12, 2008")
    te = TExp.day(12)

    assert_includes te, date, date+31, date+365
    assert_not_includes te, date+1, date-1
  end

  def test_day_builder_with_lists
    date = d("Mar 12, 2008")
    te = TExp.day(12, 13)

    assert_includes te, date, date+1, date+31, date+32, date+365, date+366
    assert_not_includes te, date+2, date-1
  end

  def test_week_builder
    date = d("Mar 12, 2008")
    te = TExp.week(2)

    assert_includes te, date, date+1
    assert_not_includes te, date+7, date-7
  end

  def test_week_builder_with_lists
    date = d("Mar 12, 2008")
    te = TExp.week(2,-1)

    assert_includes te, date, date+1, d("Mar 28, 2008")
    assert_not_includes te, date+7, date-7
  end

  def test_week_builder_with_symbol_weeks
    date = d("Mar 12, 2008")
    te = TExp.week(:second,  :last)

    assert_includes te, date, date+1, d("Mar 28, 2008")
    assert_not_includes te, date+7, date-7
  end

  def test_month_builder
    date = d("Mar 12, 2008")
    te = TExp.month(3)

    assert_includes te, date, date+1
    assert_not_includes te, date+31
  end

  def test_month_builder_with_lists
    date = d("Mar 12, 2008")
    te = TExp.month(3,4)

    assert_includes te, date, date+1, date+31
    assert_not_includes te, date+62
  end

  def test_month_builder_with_string_months
    date = d("Jan 1, 2008")
    te = TExp.month("January", :feb)

    assert_includes te, date, date+1, date+32
    assert_not_includes te, date+60
  end

  def test_year_builder
    date = d("Mar 12, 2008")
    te = TExp.year(2008)

    assert_includes te, date, date+1
    assert_not_includes te, date+365
  end

  def test_year_builder_with_list
    date = d("Mar 12, 2008")
    te = TExp.year(2008, 2009)

    assert_includes te, date, date+1, date+365
    assert_not_includes te, date-365, date + 2*365
  end

  def test_on_builder_with_day_month
    date = d("Mar 12, 2008")
    te = TExp.on(12, 3)

    assert_includes te, date, date+365
    assert_not_includes te, date-1, date+1, date+31
  end

  def test_on_builder_with_day_and_string_month
    date = d("Mar 12, 2008")
    te = TExp.on(12, "Mar")

    assert_includes te, date, date+365
    assert_not_includes te, date-1, date+1, date+31
  end

  def test_on_builder_with_string_date
    date = d("Mar 12, 2008")
    te = TExp.on("Mar 12, 2008")

    assert_includes te, date
    assert_not_includes te, date-1, date+1, date+31, date+365
  end

  def test_on_builder_with_date
    date = d("Mar 12, 2008")
    te = TExp.on(date)

    assert_includes te, date
    assert_not_includes te, date-1, date+1, date+31, date+365
  end

  def test_on_builder_with_day_month_year
    date = d("Mar 12, 2008")
    te = TExp.on(12, 3, 2008)

    assert_includes te, date
    assert_not_includes te, date-1, date+1, date+31, date+365
  end

  def test_on_builder_with_day_string_month_and_year
    date = d("Mar 12, 2008")
    te = TExp.on(12, "March", 2008)

    assert_includes te, date
    assert_not_includes te, date-1, date+1, date+31, date+365
  end

  def test_on_builder_with_time
    date = Date.today
    te = TExp.on(Time.now)

    assert_includes te, date
    assert_not_includes te, date-1, date+1, date+31, date+365
  end

  def test_on_builder_arbitrary_to_string
    obj = Object.new
    def obj.to_s
      "Nov 18, 1956"
    end

    date = d("Nov 18, 1956")
    te = TExp.on(obj)

    assert_includes te, date
    assert_not_includes te, date-1, date+1, date+31, date+365
  end

  def test_on_builder_with_invalid_arguments
    assert_raises(ArgumentError) do TExp.on(1) end
    assert_raises(ArgumentError) do TExp.on(1,2,3,4) end
    assert_raises(ArgumentError) do TExp.on(nil, nil) end
    assert_raises(ArgumentError) do TExp.on(0, 1) end
    assert_raises(ArgumentError) do TExp.on(1, 0) end
    assert_raises(ArgumentError) do TExp.on(32, 1) end
    assert_raises(ArgumentError) do TExp.on(1, 13) end
    assert_raises(ArgumentError) do TExp.on(0, 1, 2008) end
    assert_raises(ArgumentError) do TExp.on(1, 0, 2008) end
    assert_raises(ArgumentError) do TExp.on(32, 1, 2008) end
    assert_raises(ArgumentError) do TExp.on(1, 13, 2008) end
    assert_raises(ArgumentError) do TExp.on(1, 'nox') end
    assert_raises(ArgumentError) do TExp.on(1, 'nox', 2008) end
  end

  def test_dow_builder
    date = d("Mar 4, 2008")
    [
      TExp.dow(2),
      TExp.dow("Tue"),
      TExp.dow(:tuesday)
    ].each do |te|
      assert_includes te, date, date+7
      assert_not_includes te, date-1, date+1
    end
  end

  def test_dow_builder_with_lists
    date = d("Mar 3, 2008")
    [
      TExp.dow(1, 3, 5),
      TExp.dow("Mon", "we", "FRIDAY"),
      TExp.dow(:mon, :wed, :fr)
    ].each do |te|
      assert_includes te, date, date+2, date+4
      assert_not_includes te, date-1, date+1, date+3, date+5
    end
  end

  def test_interval_builder_with_days
    date = d("Mar 1, 2008")
    te = TExp.every(3, :days).reanchor(date)

    assert_includes te, date, date+3, date+6
    assert_not_includes te, date-3, date-2, date-1, date+1, date+2, date+4
  end

  def test_interval_builder_with_weeks
    date = d("Mar 1, 2008")
    te = TExp.every(3, :weeks).reanchor(date)

    assert_includes te, date, date+3*7, date+6*7
    assert_not_includes te, date-3, date-2, date-1, date+1, date+2, date+3, date+4
    assert_not_includes te, date+1*7, date+2*7, date+4*7
  end

  def test_interval_builder_with_months
    date = d("Mar 1, 2008")
    te = TExp.every(3, :months).reanchor(date)

    assert_includes te, date, date+3*30, date+6*30
    assert_not_includes te, date-3, date-2, date-1, date+1, date+2, date+3, date+4
    assert_not_includes te, date+1*30, date+2*30, date+4*30
  end

  def test_interval_builder_with_years
    date = d("Mar 1, 2008")
    te = TExp.every(3, :years).reanchor(date)

    assert_includes te, date, date+3*365, date+6*365
    assert_not_includes te, date-3, date-2, date-1, date+1, date+2, date+3, date+4
    assert_not_includes te, date+1*365, date+2*365, date+4*365
  end

  def test_window_builder
    date = Date.today
    te = TExp.on(date).window(1,2)

    assert_includes  te, date-1, date, date+1, date+2
    assert_not_includes te, date-2, date+3
  end

  def test_window_builder_with_symetrical_sides
    date = Date.today
    te = TExp.on(date).window(2)

    assert_includes  te, date-2, date-1, date, date+1, date+2
    assert_not_includes te, date-3, date+3
  end

  def test_window_builder_with_units
    date = Date.today
    te = TExp.on(date).window(1, :week)

    assert_includes  te, date-7, date-2, date-1, date, date+1, date+2, date+7
    assert_not_includes te, date-8, date+8
  end

  def test_window_builder_with_asymetrical_units
    date = Date.today
    te = TExp.on(date).window(1, :week, 3, :days)

    assert_includes  te, date-7, date-2, date-1, date, date+1, date+2, date+3
    assert_not_includes te, date-8, date+4
  end

  def test_window_builder_with_bad_units
    assert_raises ArgumentError do
      te = TExp.on(Date.today).window(1, nil)
    end
  end

  def test_eval
    te = texp {
      dow(:mon) * month(:feb)
    }
    date = d("Feb 4, 2008")
    assert_includes te, date, date+7
    assert_not_includes te, date+1
  end

  def test_eval_with_eternal_references
    te = texp {
      dow(:mon) * month(favorite_month)
    }
    date = d("Feb 4, 2008")
    assert_includes te, date, date+7
    assert_not_includes te, date+1
  end

  def favorite_month
    :feb
  end
end
