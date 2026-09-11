require "test_helper"

module FaspDataSharing
  class ProcessContentUpdateJobTest < ActiveJob::TestCase
    setup do
      @uri = "https://mastodon.example.com/status/4711"
      @job = ProcessContentUpdateJob.new
    end

    test "updates successfully when content object is present" do
      mock_valid_content_request(uri: @uri)
      RetrieveContentJob.new.perform(@uri)

      assert_enqueued_with(job: ::UpdateContentJob, args: [ @uri ]) do
        @job.perform(@uri)
      end
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
