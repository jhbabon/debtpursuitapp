# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :debt do |f|
  f.association :debtor, :factory => :user
  f.association :lender, :factory => :contact
  f.amount 9.99
end
