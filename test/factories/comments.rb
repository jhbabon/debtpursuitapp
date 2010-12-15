# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :comment do |f|
  f.association :debt, :factory => :debt
  f.association :user, :factory => :user
  f.text "A comment"
end
