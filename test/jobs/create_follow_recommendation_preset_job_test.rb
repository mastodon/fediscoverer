require "test_helper"

class CreateFollowRecommendationPresetJobTest < ActiveJob::TestCase
  setup do
    @job = CreateFollowRecommendationPresetJob.new
  end

  test "with URI of existing actor sets `recommended` to `true`" do
    actor = actors(:discoverable)

    @job.perform(actor.uri)

    assert actor.reload.recommended?
  end

  test "with unknown URI enqueues a retrieval job" do
    assert_enqueued_with job: RetrieveActorJob do
      @job.perform("https://fedi.example.com/users/new_and_unknown")
    end
  end
end
