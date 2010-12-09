class Contact < ActiveRecord::Base
  after_create :create_budget

  # TODO: validates email format
  validates_presence_of :email, :first_name, :last_name

  belongs_to :user
  belongs_to :budget

  def full_name
    "#{first_name} #{last_name}"
  end

  protected

  def create_budget
    Budget.create(:user => user, :contact => self)
  end
end
