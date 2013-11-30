class RemoveNotifyOnNextMessageFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :notify_on_next_message
  end
end
