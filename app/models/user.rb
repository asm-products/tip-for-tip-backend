class User < ActiveRecord::Base
  include Uuid

  has_many :identities
  belongs_to :partner
  has_many :tips
  has_many :purchases
  has_many :purchased_tips, through: :purchases, source: :tip, inverse_of: :purchasers

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :omniauthable, :trackable, :rememberable

  validates_presence_of :email
  validates_presence_of :username
  validates_uniqueness_of :email
  validates_uniqueness_of :username

end
