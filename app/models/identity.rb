class Identity < ActiveRecord::Base

  validates_uniqueness_of :user_id, scope: :provider

  belongs_to :user

  def self.find_for_oauth(auth)
    puts "IDENTITY MODEL"
    p auth.inspect

    identity = find_by(provider: auth.provider, uid: auth.uid)
    identity ||= create(uid: auth.uid, provider: auth.provider)
  end

end
