ActionMailer::Base.smtp_settings = {
  :address => "smtp.sendgrid.net",
  :port => '25',
  :domain => ENV['SENDGRID_DOMAIN'],
  :authentication => :plain,
  :user_name => ENV['SENDGRID_USERNAME'],
  :password => ENV['SENDGRID_PASSWORD']
}

ActionMailer::Base.default_url_options[:host] = 'debtpursuitapp.com'
