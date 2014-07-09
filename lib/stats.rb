# An interface for all the stats we'll want to track. This provides an
# abstraction from the actual stat collection infrastructure we'll use.
module Stats

  # include Stats::Api

  def self.api_user_signin id, provider, meta={}
    meta.symbolize_keys!
    meta.merge! id: id
    increment 'api.users.signin', meta
  end

  private

  def self.increment metric_name, meta={}
    meta.transform_keys{ |key| key.to_s.downcase.to_sym rescue key }
    StatsMix.track metric_name, 1, { meta: meta }
  end

  # def self.guage
  # def self.time

end
