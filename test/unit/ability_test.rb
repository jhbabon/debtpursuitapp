require 'test_helper'

class AbilityTest < ActiveSupport::TestCase
  test "user can create anything" do
    user = Factory.create(:user)
    ability = Ability.new(user)

    assert ability.can? :create, Contact
    assert ability.can? :create, Debt
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

  test "user can only pay, read, update and destroy debts which he owns" do
    user = Factory.create(:user)
    ability = Ability.new(user)

    assert ability.can? :read, Factory.build(:debt, :debtor => user)
    assert ability.can? :pay, Factory.build(:debt, :debtor => user)
    assert ability.can? :update, Factory.build(:debt, :debtor => user)
    assert ability.can? :destroy, Factory.build(:debt, :debtor => user)
    assert ability.can? :read, Factory.build(:debt, :lender => user)
    assert ability.can? :pay, Factory.build(:debt, :lender => user)
    assert ability.can? :update, Factory.build(:debt, :lender => user)
    assert ability.can? :destroy, Factory.build(:debt, :lender => user)
    assert ability.cannot? :read, Factory.build(:debt)
    assert ability.cannot? :pay, Factory.build(:debt)
    assert ability.cannot? :update, Factory.build(:debt)
    assert ability.cannot? :destroy, Factory.build(:debt)
  end
end
