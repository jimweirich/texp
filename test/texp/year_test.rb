#!/usr/bin/env ruby

require 'test/unit'
require 'date'
require 'texp'

class YearTest < Test::Unit::TestCase

  def setup
    @date = Date.parse("Feb 14, 2008")
  end

  def test_single_arg
    te = TExp::Year.new(2008)
    assert te.include?(@date)
    assert te.include?(@date + 30)
    assert ! te.include?(@date + 365)
  end

  def test_single_arg
    te = TExp::Year.new([2007,2008])
    assert te.include?(@date - 365)
    assert te.include?(@date)
    assert te.include?(@date + 30)
    assert ! te.include?(@date + 365)
  end
end

