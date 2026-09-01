require "test_helper"

module FaspDataSharing
  class ProcessContentUpdateJobTest < ActiveJob::TestCase
    setup do
      @uri = "https://mastodon.example.com/status/4711"
      mock_valid_content_request(uri: @uri)
      @job = ProcessContentUpdateJob.new
      @actor_uri = "https://unknown.example.com/users/NewActor"
    end

    test "does not enqueue job when content object is deleted before enqueing update" do
      mock_valid_actor_request(uri: @actor_uri)
      mock_valid_content_request(uri: @uri, actor: @actor_uri)
      RetrieveContentJob.new.perform(@uri)
      ContentObject.where(uri: @uri).first.destroy

      assert_enqueued_jobs(0) do
        @job.perform(@uri)
      end
    end

    test "does not create a new object, and returns from job when content object cannot be found on update" do
      mock_valid_actor_request(uri: @actor_uri)
      mock_valid_content_request(uri: @uri, actor: @actor_uri)
      RetrieveContentJob.new.perform(@uri)
      queue = @job.perform(@uri)
      ContentObject.where(uri: @uri).first.destroy

      assert_nil queue.perform_now
      assert ContentObject.where(uri: @uri).blank?
    end
  end
end
