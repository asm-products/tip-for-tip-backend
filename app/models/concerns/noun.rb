# Abstract characteristics of a noun.
module Noun
  extend ActiveSupport::Concern

  included do
    include Uuid
    has_many :tips, as: :noun
    has_many :subscriptions, as: :noun
    has_many :perks, through: :subscriptions
  end

end
