class Comment < ActiveRecord::Base
  belongs_to :debt
  belongs_to :user
end
