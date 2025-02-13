require "test_helper"

class ContentActivityTest < ActiveSupport::TestCase
  test "::distribution_of returns one array per given content object" do
    content_objects = (1..4).map { |i| content_objects(:"note#{i}") }
    distribution = ContentActivity.distribution_of(content_objects, hours: 3)

    assert distribution.is_a?(Hash)
    assert_equal 4, distribution.size
    assert_equal content_objects.map(&:id).sort, distribution.keys.sort
    distribution.values.each do |value|
      assert value.is_a?(Array)
      assert_equal 3, value.size
    end

    assert_equal content_objects.last.content_activities.order(hour_of_activity: :asc).last.score, distribution[content_objects.last.id].last
  end
end
