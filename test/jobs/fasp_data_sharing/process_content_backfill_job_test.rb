require "test_helper"

module FaspDataSharing
  class ProcessContentBackfillJobTest < ActiveJob::TestCase
    test "an unknown URI queues a content retrieval job" do
      uri = "https://new.example.com/post/22"
      assert_enqueued_with(job: ::RetrieveContentJob, args: [ uri ]) do
        ProcessContentBackfillJob.new.perform(uri)
      end
    end

    test "a known URI does not queue a job" do
      assert_enqueued_jobs(0, only: ::RetrieveContentJob) do
        ProcessContentBackfillJob.new.perform(content_objects(:one).uri)
      end
    end
  end
end
