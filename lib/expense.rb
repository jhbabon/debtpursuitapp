require 'bigdecimal'

class Expense
  attr_reader :owner
  attr_writer :amount

  def initialize( options = Hash.new )
    @owner  = options.delete( 'owner' ).to_s
    @amount = options.delete( 'amount' ).to_s
  end

  def amount
    return BigDecimal.new( @amount ) if @amount.is_a?(String)
    @amount
  end

  def valid?
    return false if ( @owner.nil? || @owner.empty? )
    return false if ( @amount.nil? || @amount.empty? )
    return false unless @amount.match( /^\d+(\.)?\d*$/ )

    true
  end
end
