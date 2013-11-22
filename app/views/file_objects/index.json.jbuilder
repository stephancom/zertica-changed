json.array!(@file_objects) do |file_object|
  json.extract! file_object, :url, :data
  json.url file_object_url(file_object, format: :json)
end
