class Perk < ActiveRecord::Base
  include Uuid

  belongs_to :subscription

  validates_presence_of :subscription
  validates_presence_of :title

end
