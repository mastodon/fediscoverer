class RetrieveActorJob < ApplicationJob
  queue_as :retrieval

  # Idea to stay within Mastodon's default rate-limits. These do not apply
  # if server is behind a caching proxy which most servers should be.
  # It still might be nice to define _some_ limit here as to not
  # overwhelm servers.
  # limits_concurrency to: 300, key: ->(uri) { URI(uri).host }, duration: 5.minutes, group: "retrieval"

  def perform(uri, update = false)
    return if !update && Actor.where(uri:).exists?

    server = Server.from_uri(uri)
    return if server.blocked?

    actor_json = server.fetch(uri)

    actor =
      if Actor.where(uri:).exists? && update
        Actor.where(uri:).first.tap { |a| a.update_from_json(actor_json) }
      else
        Actor.create_from_json!(actor_json)
      end

    if actor_json["followers"].present?
      UpdateFollowersCountJob.perform_later(actor, actor_json["followers"])
    end
  rescue ActiveRecord::RecordInvalid
    # Ignore incomplete or invalid actor data
  rescue HTTPX::HTTPError => e
    raise if e.status >= 500
  end
end
