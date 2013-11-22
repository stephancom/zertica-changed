json.array!(@active_chats) do |active_chat|
  json.extract! active_chat, :user_id, :admin_id
  json.url active_chat_url(active_chat, format: :json)
end
