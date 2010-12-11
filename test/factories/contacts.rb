# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :contact do |f|
  f.association :user, :factory => :user
  f.sequence(:email) { |n| "contact_test#{n}@example.com" }
  f.first_name "Doe"
  f.last_name "Joe"
end
