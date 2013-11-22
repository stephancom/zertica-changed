class AddMailPreferencesToUser < ActiveRecord::Migration
  def change
    add_column :users, :email_messages, :boolean, null: false, default: false
    add_column :users, :email_estimate, :boolean, null: false, default: true
    add_column :users, :email_complete, :boolean, null: false, default: true
    add_column :users, :email_shipped, :boolean, null: false, default: true
  end
end
