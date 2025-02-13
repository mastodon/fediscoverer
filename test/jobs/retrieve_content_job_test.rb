require "test_helper"

class RetrieveContentJobTest < ActiveJob::TestCase
  setup do
    @uri = "https://mastodon.example.com/status/4711"
    mock_valid_content_request(uri: @uri)
    @job = RetrieveContentJob.new
  end

  test "creates a server if domain is not yet known" do
    actor_uri = "https://unknown.example.com/users/NewActor"
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
end
