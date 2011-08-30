require File.dirname( __FILE__ ) + '/spec_helper'

describe "expenses management" do
  it "should create new expense" do
    expense = new_expense

    expense.must_be_kind_of Expense
    expense.owner.must_equal 'test1'
    expense.amount.must_equal BigDecimal.new( '10' )
  end

  it "should not validate an expense without owner" do
    expense = new_expense( 'owner' => '' )
    assert !expense.valid?

    expense = new_expense( 'owner' => 'test2' )
    assert expense.valid?
  end

  it "should not validate an expense without amount" do
    expense = new_expense( 'amount' => '' )
    assert !expense.valid?

    expense = new_expense( 'amount' => '10' )
    assert expense.valid?
  end

  it "should not validate an expense if the amount is not numeric" do
    expense = new_expense( 'amount' => 'testing' )
    assert !expense.valid?

    expense = new_expense( 'amount' => '10' )
    assert expense.valid?

    expense = new_expense( 'amount' => '10.4' )
    assert expense.valid?
  end
end

def new_expense( new_options = Hash.new )
  options = { 'owner' => 'test1', 'amount' => '10' }
  Expense.new( options.merge( new_options ) )
end
