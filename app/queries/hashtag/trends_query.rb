class Hashtag::TrendsQuery
  def self.call(...)
    new(...).call
  end

  def initialize(hours: 24, limit: 20, language: nil)
    @hours = hours.to_i
    @limit = limit.to_i
    @language = language
  end

  def call
    Hashtag
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
    base_query = HashtagActivity
      .select(average_select)
      .where({ hour_of_activity: term_start..term_end })
      .group(:hashtag_id)
    base_query = base_query.matching_language(@language) if @language.present?
    base_query
  end

  def average_select
    HashtagActivity
      .sanitize_sql([
        "hashtag_id, (SUM(score) / ?) AS score_average", @hours
      ])
  end

  def select_with_score
    "hashtags.*, (current_average.score_average - COALESCE(previous_average.score_average, 0)) AS score"
  end

  def current_average_join
    "JOIN current_average ON current_average.hashtag_id = hashtags.id"
  end

  def previous_average_join
    "LEFT OUTER JOIN previous_average ON previous_average.hashtag_id = hashtags.id"
  end

  def minimal_score_condition
    "(current_average.score_average - COALESCE(previous_average.score_average, 0)) > 0"
  end
end
