json.array!(@bids) do |bid|
  json.extract! bid, 
  json.url bid_url(bid, format: :json)
end
