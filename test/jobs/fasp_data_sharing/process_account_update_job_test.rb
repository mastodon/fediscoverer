require "test_helper"

module FaspDataSharing
  class ProcessAccountUpdateJobTest < ActiveJob::TestCase
    setup do
      @uri = "https://mastodon.example.com/users/10016"
      @job = ProcessAccountUpdateJob.new
    end

    test "a known URI queues a job" do
      RetrieveActorJob.new.perform(@uri)
      mock_valid_actor_request(uri: @uri)

      assert_enqueued_jobs(1, only: ::UpdateActorJob) do
        @job.perform(@uri)
      end
    end
  end
end
