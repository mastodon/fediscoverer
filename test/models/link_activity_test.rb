require "test_helper"

class LinkActivityTest < ActiveSupport::TestCase
  test "::distribution_of returns one array per given link" do
    links = (1..4).map { |i| links(:"link_#{i}") }
    distribution = LinkActivity.distribution_of(links, hours: 3)

    assert distribution.is_a?(Hash)
    assert_equal 4, distribution.size
    assert_equal links.map(&:id).sort, distribution.keys.sort
    distribution.values.each do |value|
      assert value.is_a?(Array)
      assert_equal 3, value.size
    end
  end
end
