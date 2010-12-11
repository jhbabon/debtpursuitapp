class DeleteBudgets < ActiveRecord::Migration
  class Contact < ActiveRecord::Base
  end
  class Debt < ActiveRecord::Base
  end
  class Budget < ActiveRecord::Base
  end

  def self.up
    add_column :debts, :debtor_id, :integer
    add_column :debts, :debtor_type, :string
    add_column :debts, :lender_id, :integer
    add_column :debts, :lender_type, :string
    Debt.reset_column_information
    Contact.reset_column_information

    Debt.all.each do |debt|
      contact = Contact.where("budget_id = ?", debt.budget_id).first
      if contact.nil?
        debt.destroy
      else
        contact_id = contact.id
        user_id = contact.user_id
        if debt.kind == 'debt'
          debt.update_attributes({ :debtor_id => user_id,
                                   :debtor_type => "User",
                                   :lender_id => contact_id,
                                   :lender_type => "Contact" })
        else
          debt.update_attributes({ :lender_id => user_id,
                                   :lender_type => "User",
                                   :debtor_id => contact_id,
                                   :debtor_type => "Contact" })
        end
      end
    end

    remove_column :debts, :kind
    remove_column :debts, :budget_id
    remove_column :contacts, :budget_id
    drop_table :budgets
  end

  def self.down
    create_table :budgets do |t|
      t.timestamps
    end
    add_column :debts, :kind, :string, :default => 'debt'
    add_column :debts, :budget_id, :integer
    add_column :contacts, :budget_id, :integer
    Debt.reset_column_information
    Contact.reset_column_information
    Budget.reset_column_information

    Contact.all.each do |contact|
      budget_id = Budget.create.id
      contact.update_attributes({ :budget_id => budget_id })
      Debt.where("lender_id = ? AND lender_type = 'Contact'", contact.id).each do |debt|
        debt.update_attributes({ :kind => 'debt', :budget_id => budget_id })
      end
      Debt.where("debtor_id = ? AND debtor_type = 'Contact'", contact.id).each do |debt|
        debt.update_attributes({ :kind => 'loan', :budget_id => budget_id })
      end
    end

    remove_column :debts, :debtor_id
    remove_column :debts, :debtor_type
    remove_column :debts, :lender_id
    remove_column :debts, :lender_type
  end
end
