class HashtagActivity < ApplicationRecord
  include ExpirableConcern
  include LanguageTaggableConcern
  include ScorableConcern

  belongs_to :hashtag

  def self.record(content_object, hashtag)
    hour = content_object.published_at.utc.beginning_of_hour
    language = content_object.language
    metric_diffs = content_object.metric_diffs
    activity = find_or_create_by!(hashtag:, hour_of_activity: hour, language:)
    activity.with_lock do
      activity.total_uses += 1
      activity.distinct_users = hashtag.distinct_users_in(hour, language:)
      activity.shares += metric_diffs[:shares]
      activity.likes += metric_diffs[:likes]
      activity.replies += metric_diffs[:replies]
      activity.trend_signals += metric_diffs[:trend_signals]
      activity.save!
    end
  rescue ActiveRecord::RecordNotFound
    # It is possible that the activity has been deleted between
    # ::find_or_create_by and #with_lock
  end

  def self.distribution_of(hashtags, hours: 24, language: nil)
    timerange_end = Time.zone.now.beginning_of_hour
    timerange_start = timerange_end.ago((hours.to_i - 1).hours)
    query = select("hashtag_activities.hashtag_id, SUM(hashtag_activities.score) AS score")
      .where(hashtag_id: hashtags.map(&:id), hour_of_activity: timerange_start..timerange_end)
      .order(hour_of_activity: :asc)
      .group(:hashtag_id, :hour_of_activity)
    query = query.where([ "hashtag_activities.language LIKE ?", "#{HashtagActivity.sanitize_sql_like(language.downcase)}%" ]) if language
    query
      .to_a
      .group_by(&:hashtag_id)
      .transform_values do |hashtag_activities|
        hashtag_activities.map(&:score)
      end
  end

  private

  def calculate_score
    self.score = distinct_users + trend_signals + trimmed_likes + trimmed_shares + 0.3 * replies
  end
end
