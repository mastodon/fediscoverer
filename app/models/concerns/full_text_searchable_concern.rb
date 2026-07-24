module FullTextSearchableConcern
  extend ActiveSupport::Concern

  included do
    normalizes :full_text, with: StrippedHtmlNormalizer.new

    scope :search, ->(term) {
      where("to_tsvector(#{table_name}.pg_text_search_configuration, #{table_name}.full_text) @@ to_tsquery(?)", string_to_query(term))
    }
  end

  class_methods do
    def string_to_query(string)
      string
        .gsub(/[^[[:alnum:]]_-]+/, " ")
        .gsub(/\s+&\s+/, " ")
        .split(/\s+/)
        .join(" & ")
    end
  end
end
