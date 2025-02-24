class StrippedHtmlNormalizer
  def call(html)
    return "" unless html

    coder = HTMLEntities.new
    html = coder.decode(html)

    Loofah.fragment(html).to_text(encode_special_chars: false)
  end
end
