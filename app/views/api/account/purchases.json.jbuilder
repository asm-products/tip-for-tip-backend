json.array! @purchases do |purchase|
  json.(purchase, :id, :transaction_id, :service, :updated_at, :created_at)
  json.tip do
    json.partial! 'api/tips/tip', tip: purchase.tip
  end
end
