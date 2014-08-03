json.array! @sales do |sale|
  json.(sale, :id, :transaction_id, :service, :updated_at, :created_at)
  json.tip do
    json.partial! 'api/tips/tip', tip: sale.tip
  end
end
