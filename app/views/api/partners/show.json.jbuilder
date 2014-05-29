json.(
  @partner,

  :id,
  :primary_user_id,
)

json.user_ids @partner.users.pluck(:id)
json.subscriptions @partner.subscriptions, partial: 'subscription', as: :subscription

json.(@partner, :created_at, :updated_at)

