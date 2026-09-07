require "test_helper"

module FaspDataSharing
  class ProcessNewAccountJobTest < ActiveJob::TestCase
    setup do
      @uri = "https://unknown.example.com/users/NewActor"
      @job = ProcessNewAccountJob.new
    end

    test "responds successfully when actor is present" do
      mock_valid_actor_request(uri: @uri)

      job = @job.perform(@uri)
      assert(job.perform_now)
    end

    test "an unknown URI queues an actor retrieval job" do
      uri = "https://new.example.com/actor/22"
      assert_enqueued_with(job: ::RetrieveActorJob, args: [ uri ]) do
        ProcessAccountBackfillJob.new.perform(uri)
      end
    end

    test "a known URI does not queue a job" do
      assert_enqueued_jobs(0, only: ::RetrieveActorJob) do
        ProcessAccountBackfillJob.new.perform(actors(:discoverable).uri)
      end
    end
  end
end
