class RetrieveContentJob < ApplicationJob
  queue_as :retrieval

  # Idea to stay within Mastodon's default rate-limits. These do not apply
  # if server is behind a caching proxy which most servers should be.
  # It still might be nice to define _some_ limit here as to not
  # overwhelm servers.
  # limits_concurrency to: 300, key: ->(uri) { URI(uri).host }, duration: 5.minutes, group: "retrieval"

  def perform(uri, update = false)
    return if !update && ContentObject.where(uri:).exists?

    content_json = Server.fetch(uri)

    # Handle reblogs
    if content_json.dig("type") == "Announce"
      content_json = content_json["object"]
      uri = content_object["id"]
    end

    if ContentObject.where(uri:).exists? && update
      ContentObject.where(uri:).take.update_from_json(content_json)
    else
      ContentObject.create_from_json!(content_json)
    end
  end
end
