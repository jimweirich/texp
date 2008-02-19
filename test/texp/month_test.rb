#!/usr/bin/env ruby

require 'test/unit'
require 'date'
require 'texp'

class MonthTest < Test::Unit::TestCase

  def setup
    @date = Date.parse("Feb 14, 2008")
  end

  def test_initial_conditions
    te = TExp::Month.new(2)
    assert te.include?(@date)
    assert te.include?(@date + 1)
    assert ! te.include?(@date + 30)
  end
end

