require "test_helper"

module FaspDataSharing
  class ProcessAccountUpdateJobTest < ActiveJob::TestCase
    setup do
      @uri = "https://unknown.example.com/users/NewActor"
      @job = ProcessAccountUpdateJob.new
    end

    test "updates successfully when actor is present" do
      mock_valid_actor_request(uri: @uri)
      RetrieveActorJob.new.perform(@uri)

      job = @job.perform(@uri)
      assert(job.perform_now)
    end
  end
end
