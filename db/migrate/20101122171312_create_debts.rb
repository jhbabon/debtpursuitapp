class CreateDebts < ActiveRecord::Migration
  def self.up
    create_table :debts do |t|
      t.integer :budget_id
      t.decimal :amount, :precision => 8, :scale => 2
      t.string :kind, :default => 'debt'
      t.boolean :paid, :default => false
      t.date :date
      t.text :note

      t.timestamps
    end
  end

  def self.down
    drop_table :debts
  end
end
