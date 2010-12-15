class Contact < ActiveRecord::Base
  include Person

  after_destroy :keep_shared_debts

  validates_presence_of :email, :first_name, :last_name if "friend_id.nil?"

  belongs_to :user
  belongs_to :friend, :foreign_key => "friend_id", :class_name => 'User'

  scope :linked, where("friend_id IS NOT ?", nil)
  scope :unlinked, where(:friend_id => nil)

  def proxy
    proxy? ? friend : self
  end

  def proxy?
    !friend.nil?
  end

  def self.reverse_proxy(person)
    if person.is_a?(User)
      Contact.where("friend_id = ?", person.id).first
    elsif person.is_a?(Contact)
      person
    end
  end

  %w(email first_name last_name).each do |method|
    src = <<-end_src
    def #{method}
      proxy? ? friend.#{method} : self[:#{method}]
    end
    end_src
    class_eval src, __FILE__, __LINE__
  end

  protected

  def keep_shared_debts
    if proxy?
      mirror = Contact.reverse_proxy(user)
      mirror.update_attributes({ :friend => nil,
                                 :email => user.email,
                                 :first_name => user.first_name,
                                 :last_name => user.last_name })
      Debt.shared_by(user, friend).each do |debt|
        debt.update_attributes({ :debtor => mirror }) if debt.debt?(user)
        debt.update_attributes({ :lender => mirror }) if debt.loan?(user)
      end
    else
      Debt.owned_by(self).each { |debt| debt.destroy }
    end
  end
end
