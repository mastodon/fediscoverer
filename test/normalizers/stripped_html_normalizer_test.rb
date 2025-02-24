require "test_helper"

class StrippedHtmlNormalizerTest < ActiveSupport::TestCase
  setup do
    @normalizer = StrippedHtmlNormalizer.new
  end

  test "#call returns input without HTML tags" do
    result = @normalizer.call("<span>test</span>")

    assert_equal "test", result
  end

  test "#call returns whitespace in place of stripped tags" do
    result = @normalizer.call("<p>Firstname</p><p>Lastname</p>")

    assert_match /Firstname\s+Lastname/, result
  end

  test "#call decodes html entities" do
    result = @normalizer.call("R&amp;D")

    assert_equal "R&D", result
  end
end
