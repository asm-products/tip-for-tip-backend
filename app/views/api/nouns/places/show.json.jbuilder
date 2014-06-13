json.(
  @place,

  :id,
  :uuid,
  :foursquare_id,
  :name,
  :latitude,
  :longitude,

  :created_at,
  :updated_at

)

json.perks_count @place.perks.count
# json.array! @place.perks, partial: 'perks', as: :perk

json.tips_count @place.tips.count
json.tips do
  json.partial! 'api/tips/tip', collection: @place.tips, as: :tip
end
