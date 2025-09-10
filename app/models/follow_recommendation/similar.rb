class FollowRecommendation::Similar
  MAX_RESULTS = 20

  def call(actor_uri, language)
    actor = Actor.find_by(uri: actor_uri)

    if actor
      base_query = Actor.all
      base_query = base_query.posts_in_language(language) if language
      base_query.similar(actor).limit(MAX_RESULTS).pluck(:uri)
    else
      RetrieveActorJob.perform_later(actor_uri) if actor_uri.present?
      []
    end
  end
end
