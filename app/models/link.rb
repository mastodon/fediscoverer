class Link < ApplicationRecord
  include RankableConcern
  include UsableConcern

  normalizes :url, with: UriNormalizer.new

  has_many :link_usages
  has_many :content_objects, through: :link_usages
  has_many :recent_examples, -> { recent.limit(10) },
    through: :link_usages, source: :content_object

  scope :trending, TrendsQuery
end
