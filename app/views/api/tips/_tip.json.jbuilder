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
when :username then tip.user.username
end
json.user_name user_name


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
