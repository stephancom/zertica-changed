class AddSendShapesUrLtoFileObjects < ActiveRecord::Migration
  def change
  	add_column :file_objects, :sendshapes_url, :string
  end
end
