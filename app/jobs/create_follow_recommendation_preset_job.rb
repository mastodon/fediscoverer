class CreateFollowRecommendationPresetJob < ApplicationJob
  queue_as :default

  def perform(uri)
    actor = Actor.find_by(uri:)
    if actor
      actor.update(recommended: true)
    else
      RetrieveActorJob.perform_later(uri)
    end
  end
end
