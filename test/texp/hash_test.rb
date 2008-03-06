#!/usr/bin/env ruby

require 'test/unit'
require 'date'
require 'texp'

######################################################################
# TODO: This test is incomplete.
#
class ToHashTest < Test::Unit::TestCase
  def test_interval_to_hash
    assert_hash '2008-02-14,2i', 'type' => 'i', 'i1' => '2008-02-14', 'i2' => '2'
    assert_hash '[0,2]w', 'type' => 'w', 'w1' => ['0', '2']
    assert_hash '[1,15]d', 'type' => 'd', 'd1' => ['1', '15']
    assert_hash '[1,2,-1]k', 'type' => 'k', 'k1' => ['1', '2', '-1']
    assert_hash '[1,3]m', 'type' => 'm', 'm1' => ['1', '3']
    assert_hash '[2008,2010]y', 'type' => 'y', 'y1' => ['2008', '2010']
    assert_hash 'e', 'type' => 'e'
  end

  def assert_hash(texp, hash)
    assert_equal hash, TExp.parse(texp).to_hash, "should match for '#{texp}'"
#    assert_equal texp, TExp.from_params('1' => hash).to_s
  end
end

