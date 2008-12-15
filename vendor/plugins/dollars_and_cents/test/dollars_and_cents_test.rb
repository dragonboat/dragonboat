# I'm a dummy class to keep D&C from complaining when loaded outside of a Rails
# environment.
module ActiveRecord
  class Base
  end
end

require 'test/unit'
require 'lib/dollars_and_cents'

class DollarsAndCentsTest < Test::Unit::TestCase

  class TestRecord
    include DollarsAndCents
    attr_accessor :price_in_cents, :msrp_in_cents, :burning_in_cents
  end
  
  class TestPickyRecord
    include DollarsAndCents
    attr_accessor :price_in_cents, :price
  end
  
  F_PRICE   = 2999
  F_MSRP    = 4301
  F_BURNING = 4000021

  def setup
    @record = TestRecord.new
    @record.price_in_cents = F_PRICE
    @record.msrp_in_cents = F_MSRP
    @record.burning_in_cents = F_BURNING
    
    @picky = TestPickyRecord.new
    @picky.price_in_cents = 100
    @picky.price = 200
  end

  def test_reading
    assert_equal(29.99, @record.price)
    assert_equal(43.01, @record.msrp)
    assert_equal(40000.21, @record.burning)
  end
  
  def test_writing
    @record.price = 12.34
    assert_equal(12.34, @record.price)
    assert_equal(1234, @record.price_in_cents)
    
    @record.msrp = 456.78
    assert_equal(456.78, @record.msrp)
    assert_equal(45678, @record.msrp_in_cents)
    
    @record.msrp = "456.79"
    assert_equal(456.79, @record.msrp)
    assert_equal(45679, @record.msrp_in_cents)
    
    @record.burning = 987.32
    assert_equal(987.32, @record.burning)
    assert_equal(98732, @record.burning_in_cents)
  end
  
  def test_crap_values
    @record.price = 12.00
    assert_nothing_raised do
      @record.price = 'moo'
    end
    assert_equal 0.00, @record.price
    
    @record.price = 12.00
    assert_nothing_raised do
      @record.price = nil
    end
    assert_equal 0.00, @record.price
  end
  
  def test_doesnt_hide_other_methods
    @picky.price = 300
    assert_equal(100, @picky.price_in_cents)
    @picky.price_in_cents = 400
    assert_equal(300, @picky.price)
  end
  
  def test_works_with_numerics
    assert_equal 300, 3.00.to_cents
    assert_equal 3.00, 300.to_dollars
    
    assert_equal 0.03, 3.00.as_cents.to_dollars
    assert_equal 3, 3.00.as_cents.to_cents
    assert_equal 300, 3.00.as_dollars.to_cents
    assert_equal 3.00, 3.00.as_dollars.to_dollars
    
    assert_equal 0.03, "3.00".as_cents.to_dollars
    assert_equal 3, "3.00".as_cents.to_cents
    assert_equal 300, "3.00".as_dollars.to_cents
    assert_equal 3.00, "3.00".as_dollars.to_dollars
    
    assert_equal 300, "3.00".to_cents
    assert_equal 3.00, "300".to_dollars
    
    assert_equal 0, "monkey".to_cents
    assert_equal 0.00, "monkey".to_dollars
  end
  
  def test_victors_problem
    @record.price = "18.01"
    assert_equal 1801, @record.price_in_cents
    @record.price = "18.99"
    assert_equal 1899, @record.price_in_cents
    @record.price = "18.10"
    assert_equal 1810, @record.price_in_cents
    @record.price = "18.17"
    assert_equal 1817, @record.price_in_cents
    @record.price = "18.19"
    assert_equal 1819, @record.price_in_cents
    @record.price = "18.94"
    assert_equal 1894, @record.price_in_cents
    @record.price = "18.92"
    assert_equal 1892, @record.price_in_cents
  end
end
