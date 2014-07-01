class Tip < ActiveRecord::Base
  include Uuid
  DISPLAY_AS_OPTIONS = %w{first_name full_name anonymous}

  belongs_to :user
  belongs_to :noun, polymorphic: true
  has_many :purchases
  has_many :purchasers, through: :purchases, source: :user, inverse_of: :purchased_tips

  validates_presence_of :subject
  validates_presence_of :body
  validates_presence_of :user
  validates_presence_of :noun
  validates_inclusion_of :display_as, in: DISPLAY_AS_OPTIONS

  before_validation do
    self.sent = false if self.sent.blank?
    self.send_at ||= Time.zone.now
    self.display_as = :full_name if self.display_as.blank?
    self.display_as = self.display_as.to_s.downcase.strip
    self.is_free = false if self.is_free.blank?
    self.is_compliment = false if self.is_compliment.blank?
    true
  end

end
