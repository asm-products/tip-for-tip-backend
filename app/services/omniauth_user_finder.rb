# Finds or creates a user for omniauth authentication. Assumes that if this
# service object is called, the user has already been authenticated with the
# provider and must now be added or found locally.
#
# Data is synchronized between provider and local data during this process
# as well.
#
# TODO: sync is not currently happening.
class OmniauthUserFinder

  def call(auth, signed_in_resource=nil)
    User.transaction do
      # Get the identity and user if they exist
      identity = find_identity(auth)
      signed_in_resource = identity.user || create_user(auth, identity)
    end
    signed_in_resource
  end

  private

  def find_identity(auth)
    identity = Identity.find_by(provider: auth.provider, uid: auth.uid)
    identity ||= Identity.create(uid: auth.uid, provider: auth.provider)
    expires_at = DateTime.strptime auth.credentials.expires_at.to_s, '%s' rescue nil
    identity.update_attributes! token: auth.credentials.token,
                                token_expires_at: expires_at,
                                profile_data: (auth.extra.raw_info.to_hash rescue nil)
    identity
  end

  def create_user(auth, identity)
    # Presume an email is provided.
    raise "No email in auth info returned" unless auth.info.email
    user = User.find_by(email: auth.info.email)

    # Create the user if it is a new registration
    if user.nil?
      user = User.new(
        first_name: auth.extra.raw_info.first_name,
        last_name: auth.extra.raw_info.last_name,
        email: auth.info.email,
        timezone: auth.extra.raw_info.timezone,
        locale: auth.extra.raw_info.locale,
        # password: Devise.friendly_token[0,20]
      )
      user.username = auth.info.nickname if auth.info.nickname
      # user.skip_confirmation!
      user.save!
      UserLifecycleMailer.welcome(user).deliver
    end

    # Associate the identity with the user if not already
    identity.user = user
    identity.save!

    user
  end

end
