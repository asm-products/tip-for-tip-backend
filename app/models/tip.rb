class Tip < ActiveRecord::Base
  include Uuid

  belongs_to :user
  belongs_to :noun, polymorphic: true

  validates_presence_of :subject
  validates_presence_of :body
  validates_presence_of :user
  validates_presence_of :noun

  def after_initialize
    self.sent = false if self.sent.blank?
    self.is_annonymous = false if self.is_annonymous.blank?
  end

end
