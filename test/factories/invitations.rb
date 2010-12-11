# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :invitation do |f|
  f.association :sender, :factory => :user
  f.association :receiver, :factory => :user
end
