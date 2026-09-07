class UpdateContentJob < ApplicationJob
  queue_as :retrieval

  # Idea to stay within Mastodon's default rate-limits. These do not apply
  # if server is behind a caching proxy which most servers should be.
  # It still might be nice to define _some_ limit here as to not
  # overwhelm servers.
  # limits_concurrency to: 300, key: ->(uri) { URI(uri).host }, duration: 5.minutes, group: "retrieval"

  # Only allow a single job per URI at the same time
  limits_concurrency key: ->(uri) { uri }, on_conflict: :discard

  def perform(uri)
    content = ContentObject.where(uri:)
    return if content.blank?

    server = Server.from_uri(uri)
    return if server.blocked?

    content_json = server.fetch(uri)
    return if content_json.blank?

    # Handle reblogs
    if content_json.dig("type") == "Announce"
      content_json = content_json["object"]
      uri = content_json["id"]
    end

    content.take.update_from_json(content_json)
  rescue HTTPX::HTTPError => e
    raise if e.status >= 500
  end
end
