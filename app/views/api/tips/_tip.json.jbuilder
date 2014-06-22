json.(
  tip,
  :id,
  :uuid,
  :subject,
  :body,

  # TODO: noun
  # TODO: user

  :is_annonymous,
  :can_purchase_with_reputation,

  # TODO: MORE TIP DATA

  :send_at,
  :created_at,
  :updated_at
)

json.user do

  json.(
    tip.user,
    :id,
    :uuid,
    :username,
    :first_name,
    :last_name,

    # TODO: more user data

    :created_at,
    :updated_at
  )

end

json.noun do

  json.(
    tip.noun,
    :id,
    :uuid,
    :created_at,
    :updated_at
  )
  json.type tip.noun.class.name.underscore

end
