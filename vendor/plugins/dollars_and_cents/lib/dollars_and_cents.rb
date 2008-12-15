# :title: dollars_and_cents plugin for Rails

module DollarsAndCents

  module Conversions
    CENTS_TO_DOLLARS = 100.00
    attr_accessor :is_dollars
    attr_accessor :is_cents
  
    # Assumes +self+ is in cents, and returns the equivalent amount in dollars.
    def to_dollars
      unless @is_dollars
        self.to_f / CENTS_TO_DOLLARS
      else
        self.to_f
      end
    end
    
    # Assumes +self+ is in dollars and returns the equivalent amount in cents,
    # rounded up to the nearest cent.
    def to_cents
      unless @is_cents
        (self.to_f * CENTS_TO_DOLLARS).round
      else
        self.to_i
      end
    end
    
    def as_cents
      x = self
      x.is_dollars = false
      x.is_cents = true
      x
    end
    
    def as_dollars
      x = self
      x.is_dollars = true
      x.is_cents = false
      x
    end
  end

  def method_missing(symbol, *args) #:nodoc:
    if respond_to?(sym_to_cents_attribute(symbol))
      process_cents_attribute(symbol, args)
    else
      super
    end
  end
  
protected
  CENTS_SUFFIX = '_in_cents'

  def sym_to_cents_attribute(symbol)
    symbol.to_s.gsub(/(.)([=]?)+$/,"\\1#{CENTS_SUFFIX}\\2")
  end
  
  def process_cents_attribute(symbol, *args)
    args.flatten!
    method = sym_to_cents_attribute(symbol)
    if method =~ /=$/
      raise ArgumentError.new("wrong number of arguments (#{args.size} for 1)") if args.size != 1
      raise TypeError.new("cannot convert #{args.first.class} into Numeric") unless args.first.is_a?(Numeric) || args.first.is_a?(String) || args.first.nil?
      self.send(method, args.first.to_f.to_cents)
    else
      raise ArgumentError.new("wrong number of arguments (#{args.size} for 0)") if args.size != 0
      value = self.send(method)
      if value && value.is_a?(Numeric)
        return value.to_dollars
      else
        return value
      end
    end
  end
  
end

class Numeric #:nodoc:
  include DollarsAndCents::Conversions
end

class String #:nodoc:
  include DollarsAndCents::Conversions
end

module ActiveRecord #:nodoc:
  class Base #:nodoc:
    include DollarsAndCents
  end
end
