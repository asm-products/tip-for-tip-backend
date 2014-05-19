class Subscription < ActiveRecord::Base

  belongs_to :noun, polymorphic: true
  belongs_to :partner

  validates_presence_of :noun
  validates_presence_of :partner

end
