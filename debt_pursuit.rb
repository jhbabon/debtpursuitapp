require 'sinatra'
require File.dirname( __FILE__ ) + '/lib/account'

# setup
# ---------------------------------------------------------------------------/
set :haml, { :format => :html5 }
set :sass, {
  :style => settings.environment == :development ? :nested : :compressed
}
enable :sessions unless test?

# helpers
# ---------------------------------------------------------------------------/
helpers do
  def partial( page )
    haml :"_#{ page.to_s }", :layout => false
  end

  def link_to( text = 'link', url = '#', options = {} )
    title = options.delete( :title ) || text

    content_tag( :a, text, options.merge( :title => title, :href => url ) )
  end

  def content_tag( tag_name, content, options = {} )
    tag = "<#{ tag_name.to_s }"
    options.each { |attr, v| tag += " #{ tag_attribute( attr, v ) }" }
    tag += ">#{ content }</#{ tag_name.to_s }>"

    tag
  end

  def tag_attribute( attribute, value )
    "#{ attribute.to_s }=\"#{ value }\""
  end
end

# routes
# ---------------------------------------------------------------------------/
get '/stylesheets/style.css' do
  sass :'stylesheets/style'
end

get '/' do
  haml :index
end

post '/magic' do
  redirect to( '/' ) unless params.has_key?( 'expenses' )

  expenses = params[ 'expenses' ].map { |expense| Expense.new( expense ) }
  valid_expenses = expenses.select { |expense| expense.valid? }

  session[ :debts ] = Account.calculate( valid_expenses )
  redirect to( '/debts' )
end

get '/debts' do
  redirect to( '/' ) unless session.has_key?( :debts ) && !session[ :debts ].empty?
  haml :index, :locals => { :data => session.delete( :debts ) }
end
