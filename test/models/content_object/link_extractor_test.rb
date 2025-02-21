require "test_helper"

class ContentObject::LinkExtractorTest < ActiveSupport::TestCase
  test "#extracted_urls returns an array of links ignoring hashtags and mentions" do
    content_object = mock_content_object(content:)
    content_object["tag"] << mention

    extracted_urls = ContentObject::LinkExtractor.new(content_object).extracted_urls

    assert_equal 1, extracted_urls.size
    assert_equal "https://example.com/home", extracted_urls.first
  end

  private

  def content
    <<~HTML
      <p>Test</p><p><a href="https://fedi.example.com/tags/testtag" class="mention hashtag" rel="tag">#<span>testtag</span></a> test <span class="h-card" translate="no"><a href="https://fedi.example.com/@user1" class="u-url mention">@<span>user1</span></a></span><a href="https://example.com/home" target="_blank" rel="nofollow noopener" translate="no"><span class="invisible">https://</span><span class="">example.com/home</span><span class="invisible"></span></a> test <a href="https://fedi.example.com/@user2">@user2</a>
    HTML
  end

  def mention
    {
      "type" => "Mention",
      "href" => "https://fedi.example.com/@user2",
      "name" => "@user2@fedi.example.com"
    }
  end
end
