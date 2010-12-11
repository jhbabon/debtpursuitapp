class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :update, :to => :pay
    alias_action :update, :to => :unpay

    can :create, :all
    can [:read, :update, :destroy], Contact, :user_id => user.id
    can [:pay, :unpay, :read, :update, :destroy], Debt do |debt|
      debt.debtor.id == user.id || debt.lender.id == user.id
    end
  end
end
