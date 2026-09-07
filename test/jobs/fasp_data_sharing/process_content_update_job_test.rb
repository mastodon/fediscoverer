require "test_helper"

module FaspDataSharing
  class ProcessContentUpdateJobTest < ActiveJob::TestCase
    setup do
      @uri = "https://mastodon.example.com/status/4711"
      @job = ProcessContentUpdateJob.new
      @actor_uri = "https://unknown.example.com/users/NewActor"
    end

    test "updates successfully when content object is present" do
      mock_valid_actor_request(uri: @actor_uri)
      mock_valid_content_request(uri: @uri, actor: @actor_uri)
      RetrieveContentJob.new.perform(@uri)

      job = @job.perform(@uri)
      assert(job.perform_now)
    end

    test "does not enqueue job when content object is not existent" do
      assert_enqueued_jobs(0) do
        @job.perform(@uri)
      end
      queue = @job.perform(@uri)

      assert_nil queue
      assert ContentObject.where(uri: @uri).blank?
    end
  end
end
