json.(
  tip,
  :id,
  :uuid,
  :subject,
  :body,

  :is_free,
  :is_compliment,
  :display_as,

  :created_at,
  :updated_at
)

user_name = case tip.display_as.to_sym
when :anonymous then 'anonymous'
when :full_name then tip.user.full_name
when :first_name then tip.user.first_name
end
json.user_name user_name


unless tip.display_as_anonymous?
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
