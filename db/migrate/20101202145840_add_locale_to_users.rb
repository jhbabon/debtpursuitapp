class AddLocaleToUsers < ActiveRecord::Migration
  class User < ActiveRecord::Base
  end

  def self.up
    add_column :users, :locale, :string, :default => "en"
    User.reset_column_information
    User.all.map { |user| user.update_attributes(:locale => "en") }
  end

  def self.down
    remove_column :users, :locale
  end
end
