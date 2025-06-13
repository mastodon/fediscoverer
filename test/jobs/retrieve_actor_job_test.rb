require "test_helper"

class RetrieveActorJobTest < ActiveJob::TestCase
  setup do
    @uri = "https://mastodon.example.com/users/NewActor"
    mock_valid_actor_request(uri: @uri)
    @job = RetrieveActorJob.new
  end

  test "creates a server if domain is not yet known" do
    uri = "https://unknown.example.com/users/NewActor"
    mock_valid_actor_request(uri:)

    assert_difference -> { Server.count }, 1 do
      @job.perform(uri)
    end
  end

  test "does not create a server if domain is known" do
    assert_no_difference -> { Server.count } do
      @job.perform(@uri)
    end
  end

  test "creates a new actor when receiving valid actor JSON" do
    assert_difference -> { Actor.count }, 1 do
      @job.perform(@uri)
    end
  end

  test "queues a job to update the followers count" do
    assert_enqueued_with(job: UpdateFollowersCountJob) do
      @job.perform(@uri)
    end
  end

  test "does not try to retrieve actor from blocked server" do
    assert_no_difference -> { Actor.count } do
      @job.perform("https://slopstodon.example.com/actors/1")
    end
  end
end
