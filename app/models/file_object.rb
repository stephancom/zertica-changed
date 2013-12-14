class FileObject < ActiveRecord::Base
	belongs_to :user
	has_and_belongs_to_many :orders
    has_and_belongs_to_many :shipped_orders, class_name: 'Order', join_table: 'orders_shippable_files'
    alias_attribute :name, :filename
end

