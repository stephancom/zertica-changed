class RemoveBookmarkFromMessages < ActiveRecord::Migration
	def up
		remove_column :messages, :bookmark
	end
	def down
		add_column :bookmark, :boolean, null: false, default: false
	end
end
