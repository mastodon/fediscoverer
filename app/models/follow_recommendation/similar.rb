class FollowRecommendation::Similar
  MAX_RESULTS = 20

  def call(actor_uri)
    actor = Actor.find_by(uri: actor_uri)

    if actor
      Actor.similar(actor).limit(MAX_RESULTS).pluck(:uri)
    else
      RetrieveActorJob.perform_later(actor_uri)
      []
    end
  end
end
