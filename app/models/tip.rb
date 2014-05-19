class Tip < ActiveRecord::Base
  include Uuid

  validates_presence_of :subject
  validates_presence_of :body
  # validates_presense_of :user

  def after_initialize
    self.sent = false if self.sent.blank?
    self.is_annonymous = false if self.is_annonymous.blank?
  end

end
