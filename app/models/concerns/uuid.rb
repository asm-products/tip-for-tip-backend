module Uuid
  extend ActiveSupport::Concern

  included do

    before_validation do
      generate_uuid
    end

    validates_uniqueness_of :uuid
    validates_presence_of   :uuid

    # TODO: validate format of uuid

  end

  def generate_uuid
    self.uuid = SecureRandom.hex(16)
  end

end
