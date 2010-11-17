class Contact < ActiveRecord::Base
  validates_presence_of :email, :first_name, :last_name

  belongs_to :user

  def full_name
    "#{first_name} #{last_name}"
  end
end
