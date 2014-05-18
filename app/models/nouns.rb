module Nouns

  def self.table_name_prefix
    'nouns_'
  end

  class Noun < ActiveRecord::Base
    include Uuid
  end

end
