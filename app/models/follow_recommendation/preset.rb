class FollowRecommendation::Preset
  MAX_RESULTS = 10

  def call(_actor_uri, language)
    base_query = Actor.discoverable.recommended
    base_query = base_query.posts_in_language(language) if language
    base_query.limit(MAX_RESULTS).pluck(:uri)
  end
end
