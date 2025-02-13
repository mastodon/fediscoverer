class ContentObject::TrendsQuery
  def self.call(...)
    new(...).call
  end

  def initialize(hours: 24, limit: 20, language: nil)
    @hours = hours
    @limit = limit
    @language = language
  end

  def call
    base_query = ContentObject
      .with(
        previous_average:,
        current_average:
      )
      .select(select_with_score)
      .joins(current_average_join)
      .joins(previous_average_join)
      .where(minimal_score_condition)
      .order(score: :desc)
      .limit(@limit)
    base_query = base_query.matching_language(@language) if @language
    base_query
  end

  private

  def previous_average
    term_end = @hours.hours.ago.beginning_of_hour
    term_start = term_end.ago(@hours.hours)
    score_average(term_start, term_end)
  end

  def current_average
    term_start = @hours.hours.ago.beginning_of_hour
    term_end = term_start.since(@hours.hours)
    score_average(term_start, term_end)
  end

  def score_average(term_start, term_end)
    ContentActivity
      .select(average_select)
      .where({ hour_of_activity: term_start..term_end })
      .group(:content_object_id)
  end

  def average_select
    ContentActivity
      .sanitize_sql([
        "content_object_id, (SUM(score) / ?) AS score_average", @hours
      ])
  end

  def select_with_score
    "content_objects.*, (current_average.score_average - COALESCE(previous_average.score_average, 0)) AS score"
  end

  def current_average_join
    "JOIN current_average ON current_average.content_object_id = content_objects.id"
  end

  def previous_average_join
    "LEFT OUTER JOIN previous_average ON previous_average.content_object_id = content_objects.id"
  end

  def minimal_score_condition
    "(current_average.score_average - COALESCE(previous_average.score_average, 0)) > 0"
  end
end
