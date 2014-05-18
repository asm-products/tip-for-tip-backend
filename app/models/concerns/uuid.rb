# require 'secure_random'

module Uuid
  extend ActiveSupport::Concern

  included do

    before_validation do
      generate_uuid
    end

  end

  def generate_uuid
    self.uuid = SecureRandom.hex(16)
  end

end
