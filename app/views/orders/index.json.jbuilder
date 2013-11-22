json.array!(@orders) do |order|
  json.extract! order, :type, :project_id, :state, :title, :description, :price, :tracking_number
  json.url order_url(order, format: :json)
end
