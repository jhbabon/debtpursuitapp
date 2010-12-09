class ChangeUsersContactsBudgetsRelations < ActiveRecord::Migration
  class User < ActiveRecord::Base
  end
  class Contact < ActiveRecord::Base
  end
  class Budget < ActiveRecord::Base
  end

  def self.up
    add_column :contacts, :budget_id, :integer
    Contact.reset_column_information
    Budget.reset_column_information
    Budget.all.map { |budget| Contact.find(budget.contact_id).update_attributes(:budget_id => budget.id) }

    remove_column :budgets, :user_id
    remove_column :budgets, :contact_id
  end

  def self.down
    add_column :budgets, :contact_id, :integer
    add_column :budgets, :user_id, :integer
    Contact.reset_column_information
    Budget.reset_column_information
    Contact.all.map { |contact| Budget.find(contact.budget_id).update_attributes({ :contact_id => contact.id, :user_id => contact.user_id }) }

    remove_column :contacts, :budget_id
  end
end
