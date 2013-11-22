class AddMessageNotificationFieldsToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :last_notified_message # seems to be no need for an index here
    add_column :users, :last_saw_messages_at, :datetime
  end
end
