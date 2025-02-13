class RetrieveActorJob < ApplicationJob
  queue_as :retrieval

  # Idea to stay within Mastodon's default rate-limits. These do not apply
  # if server is behind a caching proxy which most servers should be.
  # It still might be nice to define _some_ limit here as to not
  # overwhelm servers.
  # limits_concurrency to: 300, key: ->(uri) { URI(uri).host }, duration: 5.minutes, group: "retrieval"

  def perform(uri, update = false)
    return if !update && Actor.where(uri:).exists?

    actor_json = Server.fetch(uri)

    if Actor.where(uri:).exists? && update
      Actor.where(uri:).first.update_from_json(actor_json)
    else
      Actor.create_from_json!(actor_json)
    end
  end
end
