class Subscription < ActiveRecord::Base

  belongs_to :noun, polymorphic: true
  belongs_to :partner
  has_many :perks

  validates_presence_of :noun
  validates_presence_of :partner

end
