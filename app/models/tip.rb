class Tip < ActiveRecord::Base
  include Uuid

  belongs_to :user
  belongs_to :noun, polymorphic: true
  has_many :purchases
  has_many :purchasers, through: :purchases, source: :user, inverse_of: :purchased_tips

  validates_presence_of :subject
  validates_presence_of :body
  validates_presence_of :user
  validates_presence_of :noun

  before_validation do
    self.sent = false if self.sent.blank?
    self.send_at ||= Time.zone.now
    self.is_anonymous = false if self.is_anonymous.blank?
    self.can_purchase_with_reputation = false if self.can_purchase_with_reputation.blank?
    true
  end

end
