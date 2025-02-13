module LanguageTaggableConcern
  extend ActiveSupport::Concern

  included do
    normalizes :language, with: LanguageNormalizer.new

    scope :matching_language, ->(language) {
      where(arel_table[:language].matches("#{language.downcase}%"))
    }
  end
end
