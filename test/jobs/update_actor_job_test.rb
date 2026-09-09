require "test_helper"

class UpdateActorJobTest < ActiveJob::TestCase
  setup do
    @uri = "https://mastodon.example.com/users/10016"
    mock_valid_actor_request(uri: @uri)
    @job = UpdateActorJob.new
  end

  test "creates no Actor if domain is not yet known" do
    uri = "https://unknown.example.com/users/NewActor"
    mock_valid_actor_request(uri:)

    assert_difference -> { Actor.count }, 0 do
      @job.perform(uri)
    end
  end

  test "runs job successfully when actor is already existent" do
    RetrieveActorJob.new.perform(@uri)

    stub_request(:get, "#{@uri}/followers").
      with(
        headers: {
           "Accept"=>"application/activity+json"
        }).
      to_return(status: 200, body: "", headers: {})

    job = @job.perform(@uri)
    assert(job.perform_now)
  end

  test "does not try to retrieve actor from blocked server" do
    assert_nil(@job.perform("https://slopstodon.example.com/actors/1"))
  end
end
