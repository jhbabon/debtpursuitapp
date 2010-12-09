# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :contact do |f|
  f.association :user, :factory => :user
  f.association :budget, :factory => :budget
  f.sequence(:email) { |n| "test#{n}@example.com" }
  f.first_name "Joe"
  f.last_name "Doe"
end
