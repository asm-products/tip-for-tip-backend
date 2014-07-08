module SearchConstraint
  extend self

  def matches?(request)
    request.query_parameters.has_key? :q
  end
end
