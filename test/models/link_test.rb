require "test_helper"

class LinkTest < ActiveSupport::TestCase
  test "::trending returns the given number of records" do
    trending = Link.trending(limit: 11)

    assert_equal 11, trending.size
  end

  test "::trending adds a score to the content objects and orders by it" do
    trending = Link.trending(limit: 5)

    assert trending.all? { |c| c.respond_to?(:score) }

    scores = trending.map(&:score)
    ordered_scores = scores.sort.reverse

    assert_equal ordered_scores, scores
  end

  test "::trending filters by language" do
    trending_english = Link.trending(limit: 30, language: "en")

    assert_equal 30, trending_english.size

    activity_languages = LinkActivity.where(link_id: trending_english.map(&:id)).pluck(:language).sort.uniq

    assert_equal %w[en en-GB], activity_languages
  end
end
