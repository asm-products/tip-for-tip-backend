class User < ActiveRecord::Base

  validates_presense_of :uuid
  validates_presense_of :email
  validates_presense_of :username
  validates_uniqueness_of :uuid
  validates_uniqueness_of :email
  validates_uniqueness_of :username

end
