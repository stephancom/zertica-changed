class AddAdminToMessages < ActiveRecord::Migration
  def change
    add_reference :messages, :admin, index: true
  end
end
