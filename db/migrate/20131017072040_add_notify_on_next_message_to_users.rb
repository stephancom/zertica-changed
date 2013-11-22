class AddNotifyOnNextMessageToUsers < ActiveRecord::Migration
  def change
    add_column :users, :notify_on_next_message, :boolean, null: false, default: true
  end
end
