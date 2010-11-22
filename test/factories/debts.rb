# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :debt do |f|
  f.association :budget, :factory => :budget
  f.amount 9.99
  f.kind "debt"
end
