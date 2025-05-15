module LanguageTaggableConcern
  extend ActiveSupport::Concern

  def self.expand(language)
    subtags = language.split("-")
    subtags.map.with_index { |_, i| subtags[0..i].join("-") }
  end

  included do
    normalizes :language, with: LanguageNormalizer.new

    scope :matching_language, ->(language) {
      where(arel_table[:language].matches("#{language.downcase}%"))
    }
  end
end
