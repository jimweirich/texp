#!/usr/bin/env ruby

require 'test/unit'
require 'date'
require 'texp'
require 'flexmock/test_unit'

######################################################################
class TExpParseLexicalTest < Test::Unit::TestCase
  def setup
    @tokens = []
    flexmock(TExp).should_receive(:compile).with(any).
      and_return { |tok| @tokens << tok }
  end

  def test_letters
    assert_lex "abc", 'a', 'b', 'c'
  end

  def test_numbers
    assert_lex "1,23,4", '1', '23', '4'
  end

  def test_positive_numbers
    assert_lex "+1,23,+4", '+1', '23', '+4'
  end

  def test_negative_numbers
    assert_lex "-1,23,-4", '-1', '23', '-4'
  end

  def test_punctuation
    assert_lex "[@]()|&", '[', '@', ']', '(', ')', '|', '&'
  end

  def test_dates
    assert_lex "2008-02-14", "2008-02-14"
  end

  def test_bad_dates
    assert_lex "2008-2-14", "2008", "-2", "-14"
  end

  def test_extension_tokens
    assert_lex "<hi>", "<hi>"
  end

  EXPECTED = [
    '[', '[', '2008', 'y', '2', 'm', '14', 'd', ']', 'a', '12', 'm',
    '[', '1', '15', ']', 'd', '2008-02-14', '3', 'i', ']', 'o'
  ]
  
  def test_mixed
    assert_lex "[[2008y2m14d]a12m[1,15]d2008-02-14,3i]o", *EXPECTED
  end

  def test_mixed_with_spaces
    assert_lex "[[2008y 2m 14d]a 12m [1,15]d 2008-02-14,3i ]o", *EXPECTED
  end

  private

  def assert_lex(string, *tokens)
    TExp.parse(string)
    assert_equal tokens, @tokens
  end
end


######################################################################
class ParseTest < Test::Unit::TestCase
  def setup
    @date = Date.parse("Feb 14, 2008")
  end

  def test_bad_parse_string
    assert_raise TExp::ParseError do
      TExp.parse("(1,2)d")
    end
  end

  def test_unbalanced_list
    assert_raise TExp::ParseError do
      TExp.parse("[1")
    end
  end

  def test_unbalanced_list2
    assert_raise TExp::ParseError do
      TExp.parse("1]")
    end
  end

  def test_parse_date
    assert_equal Date.parse("Feb 14, 2008"), TExp.parse("2008-02-14")
  end

  def test_parse_interval
    te = TExp.parse("2008-02-14,2i")
    assert te.includes?(@date)
    assert ! te.includes?(@date+1)
    assert te.includes?(@date+2)
  end

  def test_parse_day_of_month
    te = TExp.parse("14d")
    te.includes?(@date)
  end

  def test_parse_list
    te = TExp.parse("[1,2,3]")
    assert_equal [1,2,3], te
  end

  def test_parse_day_of_month_with_multiple_args
    te = TExp.parse("[13,14]d")
    assert te.includes?(@date)
    assert te.includes?(@date-1)
    assert ! te.includes?(@date+2)
  end

  def test_parse_day_of_week_with_single_arg
    te = TExp.parse("4w")
    assert te.includes?(@date)
    assert ! te.includes?(@date+2)
  end

  def test_parse_day_of_week_with_multiple_args
    te = TExp.parse("[3,4]w")
    assert te.includes?(@date)
    assert te.includes?(@date-1)
    assert ! te.includes?(@date+2)
  end

  def test_parse_month_with_single_arg
    te = TExp.parse("2m")
    assert te.includes?(@date)
    assert ! te.includes?(@date + 30)
  end

  def test_parse_month_with_multiple_args
    te = TExp.parse("[2,3]m")
    assert te.includes?(@date)
    assert te.includes?(@date + 30)
    assert ! te.includes?(@date + 60)
  end

  def test_parse_year_with_single_arg
    te = TExp.parse("2008y")
    assert te.includes?(@date)
    assert ! te.includes?(@date + 365)
  end

  def test_parse_year_with_multiple_args
    te = TExp.parse("[2007,2008]y")
    assert te.includes?(@date)
    assert te.includes?(@date - 365)
    assert ! te.includes?(@date + 365)
  end

  def test_parse_window
    te = TExp.parse("3w2,1s")
    assert ! te.includes?(Date.parse("Mar 2, 2008"))
    assert   te.includes?(Date.parse("Mar 3, 2008"))
    assert   te.includes?(Date.parse("Mar 4, 2008"))
    assert   te.includes?(Date.parse("Mar 5, 2008"))
    assert   te.includes?(Date.parse("Mar 6, 2008"))
    assert ! te.includes?(Date.parse("Mar 7, 2008"))
  end

  def test_parse_not
    te = TExp.parse("14dn")
    assert ! te.includes?(@date)
    assert te.includes?(@date + 1)
  end

  def test_parse_and
    TExp.parse("14d").includes?(@date)
    TExp.parse("2m").includes?(@date)
    te = TExp.parse("[14d 2m] a")
    assert te.includes?(@date)
    assert ! te.includes?(@date + 1)
    assert ! te.includes?(@date + 365)
  end

  def test_parse_or
    te = TExp.parse("[14d 15d] o")
    assert te.includes?(@date)
    assert te.includes?(@date + 1)
    assert ! te.includes?(@date + 2)
  end

  def test_parse_every_day
    te = TExp.parse('e')
    assert te.includes?(Date.today)
  end
end

######################################################################
class ParseReverseTest < Test::Unit::TestCase
  def setup
    @date = Date.parse("Feb 14, 2008")
  end

  def test_round_trip
    assert_round_trip("2008-02-14,2i")
    assert_round_trip("14d")
    assert_round_trip("[13,14]d")
    assert_round_trip("[3,4]w")
    assert_round_trip("2m")
    assert_round_trip("[2,3]m")
    assert_round_trip("2008y")
    assert_round_trip("[2007,2008]y")
    assert_round_trip("14dn")
    assert_round_trip("[14d2m]a")
    assert_round_trip("[14d15d]o")
    assert_round_trip("14do")
    assert_round_trip("[]o")
    assert_round_trip("e")
    assert_round_trip("1k")
    assert_round_trip("[1,2]k")
    assert_round_trip("[1,2,-1]k")
    assert_round_trip("3w2,1s")
  end

  private

  def assert_round_trip(string)
    te = TExp.parse(string)
    assert_equal string, te.to_s
  end
end

