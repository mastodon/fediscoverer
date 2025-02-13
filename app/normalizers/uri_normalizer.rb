class UriNormalizer
  def call(uri)
    URI(uri).normalize.to_s
  end
end
