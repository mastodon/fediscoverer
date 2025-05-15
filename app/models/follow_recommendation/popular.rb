class FollowRecommendation::Popular
  MAX_RESULTS = 10

  def call(_actor_uri, language)
    base_query = Actor.all
    base_query = base_query.posts_in_language(language) if language
    base_query.most_popular.limit(MAX_RESULTS).map(&:uri)
  end
end
