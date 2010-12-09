class Budget < ActiveRecord::Base
  has_one :contact, :dependent => :destroy
  has_one :user, :through => :contact
  has_many :debts

  def paid=(value)
    debts.each { |debt| debt.update_attributes({ :paid => value }) }
  end

  def paid?
    debts.all? { |debt| debt.paid? } || total == 0
  end

  def total_debt
    debts.reject { |debt|
      debt.paid? || debt.loan?
    }.inject(0) { |total, debt|
      total += debt.amount
    }
  end

  def total_loan
    debts.reject { |debt|
      debt.paid? || debt.debt?
    }.inject(0) { |total, debt|
      total += debt.amount
    }
  end

  def total
    total_loan + total_debt
  end
end
