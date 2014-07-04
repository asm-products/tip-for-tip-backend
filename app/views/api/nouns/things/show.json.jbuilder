json.(
  @thing,

  :id,
  :uuid,
  :name,

  :created_at,
  :updated_at

)

json.tips_count @thing.tips.count
json.tips do
  json.partial! 'api/tips/tip', collection: @thing.tips, as: :tip
end
