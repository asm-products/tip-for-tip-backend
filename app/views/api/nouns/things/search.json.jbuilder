json.array! @things do |thing|
  json.type 'thing'

  json.(
    thing,

    :id,
    :uuid,
    :name,

    :created_at,
    :updated_at
  )

  json.tips_count thing.tips.count
end
