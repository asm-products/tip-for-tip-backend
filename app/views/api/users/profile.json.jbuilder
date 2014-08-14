json.(
  current_user,

  :id,
  :uuid,
  :username,
  :first_name,
  :last_name,
  :email,
  :paypal_email,
  :timezone,
  :locale,

  :created_at,
  :updated_at

)

json.identities current_user.identities do |identity|
  json.(
    identity,
    :uid,
    :provider,
    :token,
    :token_expires_at
  )
end
