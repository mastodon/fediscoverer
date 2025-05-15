class FollowRecommendation
  MAX_RESULTS = 50

  def self.for(account_uri, language: nil)
    new([
      Similar.new,
      Preset.new,
      Popular.new
    ]).recommended_account_uris_for(account_uri, language:)
  end

  def initialize(sources)
    @sources = sources
  end

  def recommended_account_uris_for(account_uri, language: nil)
    full_results = @sources.map { |source| source.call(account_uri, language) }
    result_set = Set.new(full_results.flatten)
    result_set.take(MAX_RESULTS)
  end
end
