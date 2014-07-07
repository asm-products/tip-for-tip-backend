# A join class of sorts between nouns and user. Tracks references
# to which user created specific nouns.
class NounCreator < ActiveRecord::Base

  belongs_to :noun, polymorphic: true
  belongs_to :user

  validates_presence_of :user
  validates_presence_of :noun

end
