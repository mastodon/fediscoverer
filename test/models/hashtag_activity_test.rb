require "test_helper"

class HashtagActivityTest < ActiveSupport::TestCase
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
