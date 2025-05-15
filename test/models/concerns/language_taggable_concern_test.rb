require "test_helper"

class LanguageTaggableConcernTest < ActiveSupport::TestCase
  test "::expand returns a list of subtags included in a language tag" do
    assert_equal [ "de" ], LanguageTaggableConcern.expand("de")

    expanded_tags = LanguageTaggableConcern.expand("de-de-bn")

    assert_equal [ "de", "de-de", "de-de-bn" ], expanded_tags
  end
end
