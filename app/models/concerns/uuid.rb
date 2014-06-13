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

  # Public: generates a uuid for the instance if it doesn't
  # already have one.
  def generate_uuid
    self.uuid ||= SecureRandom.urlsafe_base64(16)
  end

  # Public: generates a uuid on the instance and saves it.
  def generate_uuid!
    generate_uuid
    save!
  end

  # Public: Forces creation of a new uuid on the instance.
  def regenerate_uuid!
    self.uuid = SecureRandom.urlsafe_base64(16)
    save!
  end

end
