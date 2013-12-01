class AddSpeakerToMessages < ActiveRecord::Migration
  def change
    add_reference :messages, :speaker, index: true, polymorphic: true
  end
end
