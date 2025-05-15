class FollowRecommendation::Preset
  MAX_RESULTS = 10

  def call(_actor_uri)
    Actor.discoverable.recommended.limit(MAX_RESULTS).pluck(:uri)
  end
end
