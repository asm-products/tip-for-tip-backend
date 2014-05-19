class Partner < ActiveRecord::Base

  belongs_to :primary_user, class_name: 'User'
  has_many :users

  validates_presence_of :primary_user

end
