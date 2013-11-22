class DestroyAllMessages < ActiveRecord::Migration
  def up
  	Message.destroy_all
  end
  def down
  	# do nothing
  end
end
