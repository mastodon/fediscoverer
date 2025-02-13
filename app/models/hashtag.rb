class Hashtag < ApplicationRecord
  include RankableConcern
  include UsableConcern

  normalizes :name, with: HashtagNormalizer.new

  has_many :hashtag_usages
  has_many :content_objects, through: :hashtag_usages
  has_many :recent_examples, -> { recent.limit(10) },
    through: :hashtag_usages, source: :content_object

  scope :trending, TrendsQuery
end
