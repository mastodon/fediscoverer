require "test_helper"

class FollowRecommendationTest < ActiveSupport::TestCase
  setup do
    @recipient = actors(:discoverable)
  end

  test "::for returns follow recommendations for the given account" do
    results = FollowRecommendation.for(@recipient.uri)

    assert_kind_of Array, results
    assert_kind_of String, results.first
  end

  test "::for only returns actors posting in the given language" do
    german_recommended = actors(:german_recommended).uri

    all_results = FollowRecommendation.for(@recipient.uri)

    assert_includes all_results, german_recommended

    english_results = FollowRecommendation.for(@recipient.uri, language: "en")

    refute_includes english_results, german_recommended
  end

  test "#recommended_account_uris_for returns results from the given sources" do
    sources = [
      ->(uri, language) { [ "https://fedi.example.com/users/1" ] },
      ->(uri, language) { [ "https://fedi.example.com/users/23" ] }
    ]
    follow_recommendation = FollowRecommendation.new(sources)
    results = follow_recommendation.recommended_account_uris_for(@recipient.uri)

    assert_equal 2, results.size
    assert_includes results, "https://fedi.example.com/users/1"
    assert_includes results, "https://fedi.example.com/users/23"
  end

  test "#recommended_account_uris_for never returns more than the maximum number of records" do
    sources = [
      ->(uri, language) { (1..100).map { |i| "https://fedi.example.com/users/#{i}" } },
      ->(uri, language) { (101..200).map { |i| "https://fedi.example.com/users/#{i}" } }
    ]
    follow_recommendation = FollowRecommendation.new(sources)
    results = follow_recommendation.recommended_account_uris_for(@recipient.uri)

    assert_equal 50, results.size
  end

  test "#recommended_account_uris_for does not return duplicates" do
    sources = [
      ->(uri, language) { (1..10).map { |i| "https://fedi.example.com/users/#{i}" } },
      ->(uri, language) { (1..10).map { |i| "https://fedi.example.com/users/#{i}" } }
    ]
    follow_recommendation = FollowRecommendation.new(sources)
    results = follow_recommendation.recommended_account_uris_for(@recipient.uri)

    assert_equal results.uniq.size, results.size
  end
end
