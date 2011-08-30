require 'sinatra'

# setup
# ---------------------------------------------------------------------------/
set :haml, { :format => :html5 }
set :sass_style, Proc.new {
  settings.environment == :development ? :nested : :compressed
}

# helpers
# ---------------------------------------------------------------------------/
helpers do
  def partial( page )
    haml :"_#{ page.to_s }", :layout => false
  end
end

# routes
# ---------------------------------------------------------------------------/
get '/stylesheets/style.css' do
  sass :'stylesheets/style', :style => settings.sass_style
end

get '/' do
  haml :index
end
