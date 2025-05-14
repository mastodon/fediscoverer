class UpdateFollowersCountJob < ApplicationJob
  queue_as :retrieval

  def perform(actor, followers_collection_uri)
    followers_collection = Server.fetch(followers_collection_uri)

    if followers_collection.is_a?(Hash) && followers_collection["totalItems"]
      actor.update!(followers_count: followers_collection["totalItems"])
    end
  end
end
