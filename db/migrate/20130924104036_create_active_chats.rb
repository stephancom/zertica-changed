class CreateActiveChats < ActiveRecord::Migration
  def change
    create_table :active_chats do |t|
      t.references :user, index: true, null: false
      t.references :admin, index: true, null: false

      t.timestamps
    end

    add_index :active_chats, [:user_id, :admin_id], unique: true
  end
end
