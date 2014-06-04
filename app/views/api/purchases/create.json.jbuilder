json.(
  @purchase,
  :id,
  :created_at,
  :updated_at
)

json.tip do
  json.partial! partial: 'api/tips/tip', locals: { tip: @tip }
end

