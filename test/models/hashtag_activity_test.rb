require "test_helper"

class HashtagActivityTest < ActiveSupport::TestCase
  test "::record changes counters and score" do
    activity = hashtag_activities(:activity_en_19_47)
    hashtag = activity.hashtag
    content_object = Minitest::Mock.new
    content_object.expect(:published_at, activity.hour_of_activity)
    content_object.expect(:language, "en")
    content_object.expect(:metric_diffs, {
      shares: 1,
      likes: 2,
      replies: 3,
      trend_signals: 1
    })

    assert_changes -> { activity.score } do
      HashtagActivity.record(content_object, hashtag)
      activity.reload
    end
  end

  test "::distribution_of returns one array per given hashtag" do
    hashtags = (1..4).map { |i| hashtags(:"hashtag_#{i}") }
    distribution = HashtagActivity.distribution_of(hashtags, hours: 3)

    assert distribution.is_a?(Hash)
    assert_equal 4, distribution.size
    assert_equal hashtags.map(&:id).sort, distribution.keys.sort
    distribution.values.each do |value|
      assert value.is_a?(Array)
      assert_equal 3, value.size
    end
  end
end
