json.(
  subscription,
  :id
)

json.noun do
  json.type subscription.noun_type.demodulize.underscore
  json.(
    subscription.noun,
    :id,
    :uuid,
    :name,
    :created_at,
    :updated_at
  )
end

json.perks subscription.perks do |perk|
  json.(
    perk,
    :id,
    :uuid,
    :title,
    :created_at,
    :updated_at
  )
end

json.(subscription, :created_at, :updated_at)
