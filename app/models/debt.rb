class Debt < ActiveRecord::Base
  before_save :set_date

  KINDS = %w(debt loan)

  validates_presence_of :amount, :budget_id
  validates_numericality_of :amount, :greater_than => 0
  validates_inclusion_of :kind, :in => self::KINDS

  belongs_to :budget

  scope :owned_by, proc { |user| joins(:budget).where("budgets.user_id = ?", user.id) }
  scope :recent, limit(5).order("updated_at DESC")

  self::KINDS.each do |method|
    src = <<-END_SRC
    def #{method}?
      self.kind == "#{method}"
    end
    END_SRC
    class_eval src, __FILE__, __LINE__
  end

  def amount=(value)
    self[:amount] = value.blank? ? value : value.to_s.gsub(/'|,/,".").to_f
  end

  def amount
    self[:amount] ||= 0
    self.debt? ? (self[:amount] * -1) : self[:amount]
  end

  protected

  def set_date
    self[:date] ||= Date.today
  end
end
