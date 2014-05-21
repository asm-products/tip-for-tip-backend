class Identity < ActiveRecord::Base

  # Associations
  belongs_to :user

  # Validations
  validates_uniqueness_of :user_id, scope: :provider

  # Callbacks
  after_find :clear_expired_token

  # Scopes
  scope :with_expired_token, -> { where("token_expires_at <= Now() OR token_expires_at IS NULL") }
  scope :with_unexpired_token, -> { where("token_expires_at >= Now()") }



  # TODO: move this out of this model.
  def self.find_for_oauth(auth)
    identity = find_by(provider: auth.provider, uid: auth.uid)
    identity ||= create(uid: auth.uid, provider: auth.provider)
    expires_at = DateTime.strptime auth.credentials.expires_at.to_s, '%s' rescue nil
    identity.update_attributes! token: auth.credentials.token,
                                token_expires_at: expires_at,
                                profile_data: (auth.extra.raw_info.to_hash rescue nil)
    identity
  end



  private

  # Internal: Clears out the token value if it has expired so
  # that it is not passed around and assumed to be valid.
  def clear_expired_token
    if self.token.present? &&
      (Time.zone.now > self.token_expires_at || self.token_expires_at.blank?)
      update_attributes token: nil
    end
  end

end
