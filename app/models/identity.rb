class Identity < ActiveRecord::Base

  belongs_to :user

  validates_uniqueness_of :user_id, scope: :provider

  def self.find_for_oauth(auth)
    identity = find_by(provider: auth.provider, uid: auth.uid)
    identity ||= create(uid: auth.uid, provider: auth.provider)
    expires_at = DateTime.strptime auth.credentials.expires_at.to_s, '%s' rescue nil
    identity.update_attributes! token: auth.credentials.token,
                                token_expires_at: expires_at,
                                profile_data: (auth.extra.raw_info.to_hash rescue nil)
    identity
  end

end
