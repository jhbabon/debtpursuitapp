require File.dirname( __FILE__) + '/expense'

class Account
  class << self
    def calculate( expenses )
      new( expenses ).calculate
    end
  end

  def initialize( expenses )
    @expenses = expenses
  end

  def calculate
    result  = []
    cleaned = []
    loans.each do |lender, loan|
      debts.each do |debtor, debt|
        next if cleaned.include?( debtor )
        loan = loan - debt

        if loan >= 0
          cleaned << debtor
          payed = debt
        else
          loan = loan.abs
          debts.merge!( debtor => loan )
          payed = ( loan - debt ).abs
        end

        result << { :lender => lender, :debtor => debtor, :quantity => payed }
        break if loan.zero?
      end
    end

    result
  end

private

  def total
    @total ||= @expenses.inject( 0 ) { |t, ex| t += ex.amount }
  end

  def split
    @split ||= total / @expenses.count
  end

  def fixed_expenses
    @fixed_expenses ||= @expenses.inject( Hash.new ) do |ad, ex|
      ad[ ex.owner ] = ex.amount - split
      ad
    end
  end

  def loans
    @loans ||= select_expenses { |amount| amount > 0 }
  end

  def debts
    @debts ||= select_expenses { |amount| amount < 0 }
  end

  def select_expenses
    fixed_expenses.reject { |owner, amount|
      !( yield amount )
    }.sort { |a, b|
      b.last.abs <=> a.last.abs
    }.inject( Hash.new ) { |selected, ex|
      selected[ ex.first ] = ex.last.abs
      selected
    }
  end
end
