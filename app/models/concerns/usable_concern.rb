module UsableConcern
  extend ActiveSupport::Concern

  def distinct_users_in(hour, language: nil)
    base_query = content_objects
      .select(:actor_id)
      .from_hour(hour)
    base_query = base_query.matching_language(language) if language
    base_query
      .distinct
      .count
  end
end
