json.(
  tip,
  :id,
  :uuid,
  :subject,
  :body,

  :is_free,
  :is_compliment,
  :display_as,

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
