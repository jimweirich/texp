#!/usr/bin/env ruby

require 'rubygems'
require 'test/unit'
require 'date'
require 'texp'
require 'flexmock/test_unit'

######################################################################
class InspectTest < Test::Unit::TestCase
  def test_inspect
    assert_inspect "e", "every day"

    assert_inspect "0w", "the day of the week is Sunday"
    assert_inspect "[0,1]w", "the day of the week is Sunday or Monday"
    assert_inspect "[0,1,4,2,3,6,5]w",
      "the day of the week is Sunday, Monday, Tuesday, Wednesday, Thursday, Friday or Saturday"

    assert_inspect "1d", "the day of the month is the 1st"
    assert_inspect "2d", "the day of the month is the 2nd"
    assert_inspect "3d", "the day of the month is the 3rd"
    assert_inspect "4d", "the day of the month is the 4th"
    assert_inspect "5d", "the day of the month is the 5th"
    assert_inspect "10d", "the day of the month is the 10th"
    assert_inspect "11d", "the day of the month is the 11th"
    assert_inspect "12d", "the day of the month is the 12th"
    assert_inspect "13d", "the day of the month is the 13th"
    assert_inspect "14d", "the day of the month is the 14th"
    assert_inspect "15d", "the day of the month is the 15th"
    assert_inspect "16d", "the day of the month is the 16th"
    assert_inspect "17d", "the day of the month is the 17th"
    assert_inspect "18d", "the day of the month is the 18th"
    assert_inspect "19d", "the day of the month is the 19th"
    assert_inspect "20d", "the day of the month is the 20th"
    assert_inspect "[1,10,15]d", "the day of the month is the 1st, 10th or 15th"

    assert_inspect "2008-02-15,3i", "every 3rd day starting on February 15, 2008"
    assert_inspect "2008-02-15,1i", "every day starting on February 15, 2008"

    assert_inspect "1k", "it is the 1st week of the month"
    assert_inspect "[1,3]k", "it is the 1st or 3rd week of the month"
    assert_inspect "[1,2,-1]k", "it is the 1st, 2nd or last week of the month"
    assert_inspect "[-5,-4,-3,-2,-1]k",
      "it is the 5th from the last, 4th from the last, 3rd from the last, next to the last or last week of the month"

    assert_inspect "2008y", "the year is 2008"

    assert_inspect "1m", "the month is January"
    assert_inspect "[1,2,4]m", "the month is January, February or April"

    assert_inspect "[1d1m]a",
      "the day of the month is the 1st and the month is January"
    assert_inspect "[1d1m]o",
      "the day of the month is the 1st or the month is January"

    assert_inspect "[1d1m]on",
      "it is not the case that the day of the month is the 1st or the month is January"

    assert_inspect "3w2,1s",
      "the day of the week is Wednesday, or up to 2 days prior, or up to 1 day after"
  end

  def assert_inspect(texp, string)
    assert_equal string, TExp.parse(texp).inspect
  end
end
