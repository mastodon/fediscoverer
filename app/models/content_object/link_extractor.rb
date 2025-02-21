class ContentObject::LinkExtractor
  def initialize(content_json)
    @content_json = content_json
  end

  def extracted_urls
    @extracted_urls ||= extract_urls
  end

  private

  def extract_urls
    parsed_fragment.css("a[href]:not([rel~=tag]):not(.u-url)").filter_map do |a|
      a["href"] unless mention?(a["href"])
    end
  end

  def parsed_fragment
    Nokogiri::HTML5::DocumentFragment.parse(@content_json["content"])
  end

  def mention?(uri)
    @mentions ||= (@content_json["tag"] || []).filter_map do |tag|
      tag["href"] if tag["type"] == "Mention"
    end
    @mentions.include?(uri)
  end
end
