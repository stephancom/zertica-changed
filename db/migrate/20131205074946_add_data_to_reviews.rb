class AddDataToReviews < ActiveRecord::Migration
  def change
  	add_column :reviews, :storefront_id, :integer
  	add_column :reviews, :user_id, :integer
  	add_column :reviews, :title, :string
  	add_column :reviews, :description, :text
  	add_column :reviews, :rating, :integer
  end
end
