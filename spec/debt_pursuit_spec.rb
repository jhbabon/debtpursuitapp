require File.dirname( __FILE__ ) + '/spec_helper'

describe "debt pursuit app behaviours" do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def expenses
    { :expenses => [ { 'owner' => 'test1', 'amount' => '30' },
                     { 'owner' => 'test2', 'amount' => '10' } ] }
  end

  it "should get index" do
    get '/'

    assert last_response.ok?
    last_response.body.must_match /DebtPursuit/
  end

  it "should post debts on session" do
    session = Hash.new

    post '/magic', expenses, 'rack.session' => session

    session[ :debts ].wont_be_nil
    session[ :debts ].must_be_instance_of Array
  end

  it "should redirect to debts after post to magic" do
    session = Hash.new

    post '/magic', expenses, 'rack.session' => session
    follow_redirect!

    last_request.path.must_equal '/debts'
  end

  it "should redirect to index after post to magic without expenses" do
    session = Hash.new

    post '/magic', Hash.new, 'rack.session' => session
    follow_redirect!

    last_request.path.must_equal '/'
  end

  it "should redirect to index if there is no debts on session before calling debts" do
    session = Hash.new

    get '/debts', Hash.new, 'rack.session' => session
    follow_redirect!

    last_request.path.must_equal '/'
  end

  it "should show debts" do
    debts = [
      { :lender => 'test1', :debtor => 'test2', :quantity => BigDecimal.new( '5' ) },
      { :lender => 'test1', :debtor => 'test3', :quantity => BigDecimal.new( '5' ) },
      { :lender => 'test1', :debtor => 'test4', :quantity => BigDecimal.new( '5' ) },
    ]
    session = { :debts => debts }

    get '/debts', Hash.new, 'rack.session' => session

    assert !last_response.redirect?
  end
end
