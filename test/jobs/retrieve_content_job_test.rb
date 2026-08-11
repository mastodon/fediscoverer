require "test_helper"

class RetrieveContentJobTest < ActiveJob::TestCase
  setup do
    @uri = "https://mastodon.example.com/status/4711"
    mock_valid_content_request(uri: @uri)
    @job = RetrieveContentJob.new
  end

  test "can handle peertube requests" do
    content = "https://mastodon.example.com/videos/watch/04af977f-4201-4697-be67-a8d8cae6fa7a"
    mock_valid_actor_request
    request = mock_valid_peertube_request(uri: content)
    job = RetrieveContentJob.new

    assert_difference -> { ContentObject.count }, 1 do
      job.perform(content)
    end
  end

  test "creates a server if domain is not yet known" do
    actor_uri = "https://unknown.example.com/users/NewActor"
    mock_valid_actor_request(uri: actor_uri)
    mock_valid_content_request(uri: @uri, actor: actor_uri)

    assert_difference -> { Server.count }, 1 do
      @job.perform(@uri)
    end
  end

  test "can handle actor creation when a URI that includes non-ascii characters" do
    actor_uri = "https://other.example.com/users/\u4F11\u65E5\u8AB2\u9577"
    mock_valid_actor_request(uri: actor_uri)
    mock_valid_content_request(uri: @uri, actor: actor_uri)

    assert_difference -> { Server.count }, 1 do
      @job.perform(@uri)
    end
  end

  test "can handle server creation when a URI that includes non-ascii characters" do
    actor_uri = "https://other.example.com/users/\u4F11\u65E5\u8AB2\u9577"
    mock_valid_actor_request(uri: actor_uri)
    mock_valid_content_request(uri: @uri, actor: actor_uri)

    assert_difference -> { Server.count }, 1 do
      @job.perform(@uri)
    end
  end

  test "can handle server creation when a URI can not be parsed to punycode" do
    actor_uri = "http://www.詹姆斯.com/"
    mock_valid_actor_request(uri: actor_uri)
    mock_valid_content_request(uri: @uri, actor: actor_uri)

    assert_difference -> { Server.count }, 1 do
      @job.perform(@uri)
    end
  end

  test "does not create a server if domain is known" do
    assert_no_difference -> { Server.count } do
      @job.perform(@uri)
    end
  end

  test "creates an actor if the actor is not yet known" do
    actor_uri = "https://unknown.example.com/users/NewActor"
    mock_valid_actor_request(uri: actor_uri)
    mock_valid_content_request(uri: @uri, actor: actor_uri)

    assert_difference -> { Actor.count }, 1 do
      @job.perform(@uri)
    end
  end

  test "does not create an actor if actor is known" do
    assert_no_difference -> { Actor.count } do
      @job.perform(@uri)
    end
  end

  test "creates new content object if actor is indexable" do
    assert_difference -> { ContentObject.count }, 1 do
      @job.perform(@uri)
    end
  end

  test "does not create a new content object if actor is not indexable" do
    mock_valid_content_request(uri: @uri, actor: actors(:not_discoverable).uri)

    assert_no_difference -> { ContentObject.count } do
      @job.perform(@uri)
    end
  end

  test "does not create a new content object if the object is already known" do
    assert_no_difference -> { ContentObject.count } do
      @job.perform(content_objects(:one).uri)
    end
  end

  test "does not create a new content object if the object is not public" do
    mock_valid_content_request(uri: @uri, to: [ "#{actors(:discoverable).uri}/followers" ])

    assert_no_difference -> { ContentObject.count } do
      @job.perform(@uri)
    end
  end

  test "does not try to retrieve content from blocked server" do
    assert_no_difference -> { ContentObject.count } do
      @job.perform("https://slopstodon.example.com/posts/1")
    end
  end

  test "does not try to retrieve content from blocked actor" do
    uri = "https://mastodon.example.com/posts/2"
    mock_valid_content_request(uri:, actor: actors(:blocked).uri)

    assert_no_difference -> { ContentObject.count } do
      @job.perform(uri)
    end
  end
end
