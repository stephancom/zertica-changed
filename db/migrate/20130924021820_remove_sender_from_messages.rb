class RemoveSenderFromMessages < ActiveRecord::Migration
  def change
    remove_reference :messages, :sender, index: true
  end
end
