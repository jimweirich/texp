require 'test_helper'

class OperatorsTest < Minitest::Test
  def setup
    @monday    = Date.parse("Mar 3, 2008")
    @tuesday   = Date.parse("Mar 4, 2008")
    @wednesday = Date.parse("Mar 5, 2008")
    @thursday  = Date.parse("Mar 6, 2008")
    @friday    = Date.parse("Mar 7, 2008")
  end

  def test_union
    te = TExp.parse("2w") + TExp.parse("3w")

    assert ! te.includes?(@monday)
    assert   te.includes?(@tuesday)
    assert   te.includes?(@wednesday)
    assert ! te.includes?(@thursday)
    assert ! te.includes?(@friday)
  end

  def test_intersection
    te = TExp.parse("2w") * TExp.parse("1k")

    assert   te.includes?(@tuesday)
    assert ! te.includes?(@wednesday)
    assert ! te.includes?(@tuesday+7)
  end

  def test_difference
    te = TExp.parse("3w1,1s") - TExp.parse("3w")

    assert ! te.includes?(@monday)
    assert   te.includes?(@tuesday)
    assert ! te.includes?(@wednesday)
    assert   te.includes?(@thursday)
    assert ! te.includes?(@friday)
  end

  def test_negate
    te = -TExp.parse("3w")

    assert   te.includes?(@monday)
    assert   te.includes?(@tuesday)
    assert ! te.includes?(@wednesday)
    assert   te.includes?(@thursday)
    assert   te.includes?(@friday)
  end
end
