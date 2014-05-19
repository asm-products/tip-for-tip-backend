class Nouns::Thing < ActiveRecord::Base
  include Noun

  validates_presence_of :name

end
