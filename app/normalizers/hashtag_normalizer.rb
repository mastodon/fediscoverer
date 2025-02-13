class HashtagNormalizer
  def call(name)
    name.sub(/^#/, "").downcase
  end
end
