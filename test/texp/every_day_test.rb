#!/usr/bin/env ruby

require 'test/unit'
require 'date'

require 'texp'

class EveryDayTest < Test::Unit::TestCase

  def test_every_day
    te = TExp::EveryDay.new
    assert te.include?(Date.parse("Feb 15, 2008"))
  end
end

