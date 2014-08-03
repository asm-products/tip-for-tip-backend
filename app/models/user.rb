class User < ActiveRecord::Base
  include Uuid

  has_many :identities
  belongs_to :partner
  has_many :tips
  has_many :purchases
  has_many :iap_receipt_verifications
  has_many :purchased_tips, through: :purchases, source: :tip, inverse_of: :purchasers

  # Accounting associations
  belongs_to :customer_account

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :omniauthable, :trackable, :rememberable

  validates_presence_of :email
  validates_presence_of :username
  validates_uniqueness_of :email
  validates_uniqueness_of :username

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  after_create do
    unless self.customer_account
      self.update_attributes! customer_account: CustomerAccount.create!(user: self)
    end
  end

end
