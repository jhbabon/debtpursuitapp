# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :budget do |f|
  f.association :user, :factory => :user
  f.association :contact, :factory => :contact
end
