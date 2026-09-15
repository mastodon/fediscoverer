require "test_helper"

class UpdateContentJobTest < ActiveJob::TestCase
  setup do
    @uri = "https://mastodon.example.com/status/4711"
    mock_valid_content_request(uri: @uri)
    @job = UpdateContentJob.new
    @initial_content = ContentObject.find_by(uri: @uri)
  end

  test "runs successfuly when ContentObject is already known" do
    RetrieveContentJob.new.perform(@uri)
    mock_valid_content_request(uri: @uri)

    @job.perform(@uri)
    refute_equal(@initial_content, ContentObject.find_by(uri: @uri))
  end

  test "does not try to update content if domain is not yet known" do
    uri = "https://unknown.example.com/status/1337"

    assert_nil @job.perform(uri)
  end

  test "does not update a content object if actor is not indexable" do
    mock_valid_content_request(uri: @uri, actor: actors(:not_discoverable).uri)

    assert_nil @job.perform(@uri)
  end

  test "does not try to update content from blocked server" do
    assert_nil @job.perform("https://slopstodon.example.com/posts/1")
  end

  test "does not try to update content from blocked actor" do
    uri = "https://mastodon.example.com/posts/2"
    mock_valid_content_request(uri:, actor: actors(:blocked).uri)

    assert_nil @job.perform(uri)
  end
end
