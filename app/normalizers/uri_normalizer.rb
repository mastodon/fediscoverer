require "addressable"

class UriNormalizer
  def call(uri)
    Addressable::URI.parse(uri).normalize.to_s
  end
end
