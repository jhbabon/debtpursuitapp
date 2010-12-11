module Person
  def self.included(base)
    base.has_many :debts, :as => :debtor, :class_name => "Debt"
    base.has_many :loans, :as => :lender, :class_name => "Debt"
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def polymorphic_id
    "#{self.id}_#{self.class.to_s}"
  end
end
