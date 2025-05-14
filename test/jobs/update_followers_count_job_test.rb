require "test_helper"

class UpdateFollowersCountJobTest < ActiveJob::TestCase
  setup do
    @actor = actors(:discoverable)
    @uri = "#{@actor.uri}/followers"
    mock_valid_followers_collection_request(uri: @uri)
    @job = UpdateFollowersCountJob.new
  end

  test "updates the actor's follower count with the data retrieved" do
    assert_difference -> { @actor.followers_count }, 345 do
      @job.perform(@actor, @uri)
      @actor.reload
    end
  end
end
