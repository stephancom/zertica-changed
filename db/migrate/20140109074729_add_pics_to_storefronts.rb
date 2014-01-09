class AddPicsToStorefronts < ActiveRecord::Migration
  def change
  	add_column :storefronts, :image1, :text
  	add_column :storefronts, :image2, :text
  	add_column :storefronts, :image3, :text
  	add_column :storefronts, :image4, :text
  end
end
