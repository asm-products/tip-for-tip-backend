class Identity < ActiveRecord::Base

  # Associations
  belongs_to :user

  # Validations
  validates_uniqueness_of :user_id, scope: :provider
  validates_uniqueness_of :token

  # Callbacks
  after_find :clear_expired_token

  # Scopes
  scope :with_expired_token, -> { where("token_expires_at <= ? OR token_expires_at IS NULL", Time.zone.now) }
  scope :with_unexpired_token, -> { where("token_expires_at >= ?", Time.zone.now) }

  private

  # Internal: Clears out the token value if it has expired so
  # that it is not passed around and assumed to be valid.
  def clear_expired_token
    if self.token.present? &&
      (Time.zone.now > self.token_expires_at || self.token_expires_at.blank?)
      update_attributes! token: nil
    end
  end

end
