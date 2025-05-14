module MockObjects
  def mock_actor(
    uri: "https://mastodon.example.com/users/23.json",
    discoverable: true,
    indexable: true
  )
    {
      "@context": [
        "https://www.w3.org/ns/activitystreams",
        "https://w3id.org/security/v1",
        {
          featuredTags: {
            "@id": "toot:featuredTags",
            "@type": "@id"
          },
          alsoKnownAs: {
            "@id": "as:alsoKnownAs",
            "@type": "@id"
          },
          schema: "http://schema.org#",
          discoverable: "toot:discoverable",
          suspended: "toot:suspended",
          indexable: "toot:indexable"
        }
      ],
      id: uri,
      type: "Person",
      following: "#{uri}/following",
      followers: "#{uri}/followers",
      inbox: "#{uri}/inbox",
      outbox: "#{uri}/outbox",
      featured: "#{uri}/featured",
      featuredTags: "#{uri}/tags",
      preferredUsername: Faker::Internet.unique.username,
      name: Faker::Name.unique.name,
      summary: Faker::HTML.paragraph,
      url: uri,
      discoverable:,
      indexable:
    }.with_indifferent_access
  end

  def mock_content_object(
    uri: "https://mastodon.example.com/status/99",
    actor: actors(:discoverable).uri,
    to: [ "https://www.w3.org/ns/activitystreams#Public" ],
    content: Faker::HTML.paragraph,
    hashtags: [],
    images: 0,
    videos: 0,
    audio: 0
  )
    tag = hashtags.map do |hashtag|
      {
        type: "Hashtag",
        name: hashtag
      }
    end
    attachments = []
    images.times { attachments << mock_attachment }
    videos.times { attachments << mock_attachment(media_type: "video/mp4") }
    audio.times { attachments << mock_attachment(media_type: "audio/mp3") }
    {
      "@context": [
        "https://www.w3.org/ns/activitystreams",
        {
          sensitive: "as:sensitive",
          toot: "http://joinmastodon.org/ns#"
        }
      ],
      id: uri,
      type: "Note",
      summary: Faker::HTML.paragraph,
      published: 5.minutes.ago.utc.iso8601,
      url: uri,
      attributedTo: actor,
      to:,
      sensitive: false,
      content:,
      contentMap: {
        en: content
      },
      replies: {
        id: "#{uri}/replies",
        type: "Collection",
        first: {
          type: "CollectionPage",
          next: "#{uri}/replies?page=2",
          partOf: "#{uri}/replies",
          item: []
        }
      },
      likes: {
        id: "#{uri}/likes",
        type: "Collection",
        totatlItems: 3
      },
      shares: {
        id: "#{uri}/shares",
        type: "Collection",
        totalItems: 2
      },
      tag:,
      attachments:
    }.with_indifferent_access
  end

  def mock_followers_collection(uri: "#{actors(:discoverable).uri}/followers")
    {
      "@context": "https://www.w3.org/ns/activitystreams",
      id: uri,
      type: "OrderedCollection",
      totalItems: 345,
      first: "#{uri}?page=1"
    }.with_indifferent_access
  end

  private

  def mock_attachment(media_type: "image/jpeg", type: "Document")
    {
      type:,
      mediaType: media_type,
      url: Faker::Internet.url
    }
  end
end
