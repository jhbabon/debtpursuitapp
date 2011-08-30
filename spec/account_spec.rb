require File.dirname( __FILE__ ) + '/spec_helper'

describe "account management" do

  it "should calculate debts from the given expenses" do
    expenses = [
      Expense.new( { 'owner' => 'test1', 'amount' => '10' } ),
      Expense.new( { 'owner' => 'test2', 'amount' => '5' } ),
      Expense.new( { 'owner' => 'test3', 'amount' => '0' } ),
      Expense.new( { 'owner' => 'test4', 'amount' => '2' } ),
      Expense.new( { 'owner' => 'test5', 'amount' => '1' } ),
    ]

    debts = [
      { :lender => 'test1', :debtor => 'test3', :quantity => BigDecimal.new( '3.6' ) },
      { :lender => 'test1', :debtor => 'test5', :quantity => BigDecimal.new( '2.6' ) },
      { :lender => 'test1', :debtor => 'test4', :quantity => BigDecimal.new( '0.2' ) },
      { :lender => 'test2', :debtor => 'test4', :quantity => BigDecimal.new( '1.4' ) },
    ]

    calculated_debts = Account.calculate( expenses )
    calculated_debts.must_equal debts

    expenses = [
      Expense.new( { 'owner' => 'test1', 'amount' => '20' } ),
      Expense.new( { 'owner' => 'test2', 'amount' => '0' } ),
      Expense.new( { 'owner' => 'test3', 'amount' => '0' } ),
      Expense.new( { 'owner' => 'test4', 'amount' => '0' } ),
    ]

    debts = [
      { :lender => 'test1', :debtor => 'test2', :quantity => BigDecimal.new( '5' ) },
      { :lender => 'test1', :debtor => 'test3', :quantity => BigDecimal.new( '5' ) },
      { :lender => 'test1', :debtor => 'test4', :quantity => BigDecimal.new( '5' ) },
    ]

    calculated_debts = Account.calculate( expenses )
    calculated_debts.must_equal debts
  end
end
