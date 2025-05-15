class FollowRecommendation::Popular
  MAX_RESULTS = 10

  def call(_actor_uri)
    Actor.most_popular.limit(MAX_RESULTS).map(&:uri)
  end
end
