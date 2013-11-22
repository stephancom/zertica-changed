json.array!(@messages) do |message|
  json.extract! message, :body, :user_id, :admin_id, :bookmark
  json.url message_url(message, format: :json)
end
