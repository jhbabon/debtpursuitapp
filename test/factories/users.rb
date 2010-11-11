# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :user do |f|
  f.email "test@example.com"
  f.first_name "Joe"
  f.last_name "Doe"
  f.password "123456"
  f.password_confirmation "123456"
end
