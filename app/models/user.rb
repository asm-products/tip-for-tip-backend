class User < ActiveRecord::Base
  include Uuid

  has_many :identities
  has_many :tips
  has_one  :partner

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :omniauthable, :trackable, :rememberable

  validates_presence_of :uuid
  validates_presence_of :email
  validates_presence_of :username
  validates_uniqueness_of :uuid
  validates_uniqueness_of :email
  validates_uniqueness_of :username

  # Public: Finds or creates the user for omniauth authentication.
  # Syncs data.
  # TODO: move to a class external from the model?
  def self.find_for_oauth(auth, signed_in_resource = nil)
    transaction do
      # Get the identity and user if they exist
      identity = Identity.find_for_oauth(auth)
      user = identity.user
      if user.nil?
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
        end

        # Associate the identity with the user if not already
        if identity.user != user
          identity.user = user
          identity.save!
        end
      end

      user
    end
  end

end
