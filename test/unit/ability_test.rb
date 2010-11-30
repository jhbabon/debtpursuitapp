require 'test_helper'

class AbilityTest < ActiveSupport::TestCase
  test "user can create anything" do
    user = Factory.create(:user)
    ability = Ability.new(user)

    assert ability.can? :create, Budget
    assert ability.can? :create, Contact
    assert ability.can? :create, Debt
  end

  test "user can only pay, read, update and destroy budgets which he owns" do
    user = Factory.create(:user)
    ability = Ability.new(user)

    assert ability.can? :read, Factory.build(:budget, :user => user)
    assert ability.can? :update, Factory.build(:budget, :user => user)
    assert ability.can? :destroy, Factory.build(:budget, :user => user)
    assert ability.can? :pay, Factory.build(:budget, :user => user)
    assert ability.can? :unpay, Factory.build(:budget, :user => user)
    assert ability.cannot? :read, Factory.build(:budget)
    assert ability.cannot? :update, Factory.build(:budget)
    assert ability.cannot? :destroy, Factory.build(:budget)
    assert ability.cannot? :pay, Factory.build(:budget)
    assert ability.cannot? :unpay, Factory.build(:budget)
  end

  test "user can only read, update and destroy contacts which he owns" do
    user = Factory.create(:user)
    ability = Ability.new(user)

    assert ability.can? :read, Factory.build(:contact, :user => user)
    assert ability.can? :update, Factory.build(:contact, :user => user)
    assert ability.can? :destroy, Factory.build(:contact, :user => user)
    assert ability.cannot? :read, Factory.build(:contact)
    assert ability.cannot? :update, Factory.build(:contact)
    assert ability.cannot? :destroy, Factory.build(:contact)
  end

  test "user can only pay, read, update anda destroy debts which he owns" do
    user = Factory.create(:user)
    ability = Ability.new(user)

    assert ability.can? :read, Factory.build(:debt, :budget => Factory.create(:budget, :user => user))
    assert ability.can? :update, Factory.build(:debt, :budget => Factory.create(:budget, :user => user))
    assert ability.can? :destroy, Factory.build(:debt, :budget => Factory.create(:budget, :user => user))
    assert ability.can? :pay, Factory.build(:debt, :budget => Factory.create(:budget, :user => user))
    assert ability.can? :unpay, Factory.build(:debt, :budget => Factory.create(:budget, :user => user))
    assert ability.cannot? :read, Factory.build(:debt, :budget => Factory.create(:budget))
    assert ability.cannot? :update, Factory.build(:debt, :budget => Factory.create(:budget))
    assert ability.cannot? :destroy, Factory.build(:debt, :budget => Factory.create(:budget))
    assert ability.cannot? :pay, Factory.build(:debt, :budget => Factory.create(:budget))
    assert ability.cannot? :unpay, Factory.build(:debt, :budget => Factory.create(:budget))
  end
end
