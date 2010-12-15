class Debt < ActiveRecord::Base
  before_save :set_date

  validates_presence_of :amount
  validates_numericality_of :amount, :greater_than => 0

  scope :owed_by, proc { |person| where(self.arel_owed_by(person).to_sql) }
  scope :lent_by, proc { |person| where(self.arel_lent_by(person).to_sql) }
  scope :owned_by, proc { |person|
    where(self.arel_owed_by(person).or(self.arel_lent_by(person)).to_sql)
  }
  scope :shared_by, proc { |person1, person2| owned_by(person1).owned_by(person2) }
  scope :recent, limit(5).order("created_at DESC")
  scope :paid, where(:paid => true)
  scope :unpaid, where(:paid => false)
  # scope :total_debt, proc { |person|  }

  belongs_to :debtor, :polymorphic => true
  belongs_to :lender, :polymorphic => true
  has_many :comments, :dependent => :destroy

  def amount=(value)
    self[:amount] = value.blank? ? value : value.to_s.gsub(/'|,/,".").to_f
  end

  def partner(person)
    return lender if debt?(person)
    return debtor if loan?(person)
  end

  def type(person)
    return 'debt' if debt?(person)
    return 'loan' if loan?(person)
  end

  def debt?(person)
    debtor == person
  end

  def loan?(person)
    lender == person
  end

  %w(debtor lender).each do |method|
    src = <<-end_src
    def #{method}_str=(value)
      self.#{method}_id = value.split("_").first
      self.#{method}_type = value.split("_").last
    end

    def #{method}_str
      #{method} ? #{method}.polymorphic_id : nil
    end
    end_src
    class_eval src, __FILE__, __LINE__
  end

  { "debt" => "owed", "loan" => "lent" }.each do |type, method|
    src = <<-end_src
    def self.total_#{type}(person)
      #{method}_by(person).unpaid.sum(:amount)
    end
    end_src
    class_eval src, __FILE__, __LINE__
  end

  def self.total_sum(person)
    self.total_loan(person) - self.total_debt(person)
  end

  protected

  { "owed" => "debtor", "lent" => "lender" }.each do |method, role|
    src = <<-end_src
    def self.arel_#{method}_by(person)
      t = Debt.arel_table
      t[:#{role}_id].eq(person.id).and(t[:#{role}_type].eq(person.class.to_s))
    end
    end_src
    class_eval src, __FILE__, __LINE__
  end

  def set_date
    self[:date] ||= Date.today
  end
end
