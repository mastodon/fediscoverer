require "test_helper"

class ContentObjectTest < ActiveSupport::TestCase
  test "::create_from_json! creates an actor if the actor is not yet known" do
    actor_uri = "https://unknown.example.com/users/NewActor"
    mock_valid_actor_request(uri: actor_uri)
    object = mock_content_object(actor: actor_uri)

    assert_difference -> { Actor.count }, 1 do
      ContentObject.create_from_json!(object)
    end
  end

  test "::create_from_json! does not create an actor if actor is known" do
    assert_no_difference -> { Actor.count } do
      ContentObject.create_from_json!(mock_content_object)
    end
  end

  test "::create_from_json! does not create a new content object if actor is not indexable" do
    object = mock_content_object(actor: actors(:not_discoverable).uri)

    assert_no_difference -> { ContentObject.count } do
      ContentObject.create_from_json!(object)
    end
  end

  test "::create_from_json! does not create a new content object if the object is already known" do
    object = mock_content_object(uri: content_objects(:one).uri)

    assert_no_difference -> { ContentObject.count } do
      ContentObject.create_from_json!(object)
    end
  end

  test "::create_from_json! does not create a new content object if the object is not public" do
    object = mock_content_object(to: [ "#{actors(:discoverable).uri}/followers" ])

    assert_no_difference -> { ContentObject.count } do
      ContentObject.create_from_json!(object)
    end
  end

  test "::create_from_json! does not create a new content object if the `type` is not supported" do
    object = mock_content_object(type: "Question")

    assert_no_difference -> { ContentObject.count } do
      ContentObject.create_from_json!(object)
    end
  end

  test "::create_from_json! creates new content object if actor is indexable" do
    assert_difference -> { ContentObject.count }, 1 do
      ContentObject.create_from_json!(mock_content_object)
    end
  end

  test "::create_from_json! extracts hashtags, reuses existing ones and creates new ones" do
    hashtags = %w[ #fediverse #fediscovery ]
    object = mock_content_object(hashtags:)
    new_content_object = nil

    assert_difference -> { Hashtag.count }, 1 do
      new_content_object = ContentObject.create_from_json!(object)
    end

    assert_equal 2, new_content_object.hashtags.count
  end

  test "::create_from_json! extracts links, reuses existing ones and creates new ones" do
    links = %w[ https://example.com/a https://example.com/b ]
    content = "<p><a href=\"#{links[0]}\">a</a><a href=\"#{links[1]}\">b</a></p>"
    object = mock_content_object(content:)
    new_content_object = nil

    assert_difference -> { Link.count }, 1 do
      new_content_object = ContentObject.create_from_json!(object)
    end

    assert_equal 2, new_content_object.links.count
  end

  test "::create_from_json! counts image and video attachments" do
    object = mock_content_object(images: 2, videos: 1, audio: 3)
    new_content_object = ContentObject.create_from_json!(object)

    assert_equal 2, new_content_object.attached_images
    assert_equal 1, new_content_object.attached_videos
    assert_equal 3, new_content_object.attached_audio
  end

  test "::create_from_json! records activity data" do
    hashtags = [ "#fediverse" ]
    link = links(:a).url
    content = "<p><a href=\"#{link}\">a</a></p>"
    object = mock_content_object(hashtags:, content:)

    assert_difference -> { ContentActivity.count }, 1 do
      assert_difference -> { HashtagActivity.count }, 1 do
        assert_difference -> { LinkActivity.count }, 1 do
          ContentObject.create_from_json!(object)
        end
      end
    end
  end

  test "::create_from_json! creates a record when `sensitive` is missing from JSON" do
    object = mock_content_object(sensitive: nil)

    assert_difference -> { ContentObject.count }, 1 do
      ContentObject.create_from_json!(object)
    end
  end

  test "::create_from_json! creates a record when `tag` is missing from JSON" do
    object = mock_content_object(hashtags: nil)

    assert_difference -> { ContentObject.count }, 1 do
      ContentObject.create_from_json!(object)
    end
  end

  test "::trending returns the given number of records" do
    trending = ContentObject.trending(limit: 11)

    assert_equal 11, trending.size
  end

  test "::trending adds a score to the content objects and orders by it" do
    trending = ContentObject.trending(limit: 5)

    assert trending.all? { |c| c.respond_to?(:score) }

    scores = trending.map(&:score)
    ordered_scores = scores.sort.reverse

    assert_equal ordered_scores, scores
  end

  test "#destroy updates the actor's languages" do
    content_objects(:french_post).destroy

    languages = actors(:discoverable).actor_languages.map(&:language).sort

    assert_equal [ "de", "de-de", "de-de-bn", "en" ], languages
  end

  test "#save updates the actor's languages" do
    note = content_objects(:complex_language_tag)

    assert_difference -> { ActorLanguage.count }, 1 do
      note.language = "de"
      note.save
    end

    languages = actors(:discoverable).actor_languages.map(&:language).sort
    assert_includes languages, "de"
  end
end
