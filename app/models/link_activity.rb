class LinkActivity < ApplicationRecord
  include ExpirableConcern
  include LanguageTaggableConcern
  include ScorableConcern

  belongs_to :link

  def self.record(content_object, link)
    hour = content_object.published_at.utc.beginning_of_hour
    language = content_object.language
    metric_diffs = content_object.metric_diffs
    activity = find_or_create_by!(link:, hour_of_activity: hour, language:)
    activity.with_lock do
      activity.distinct_users = link.distinct_users_in(hour, language:)
      activity.total_uses += 1
      activity.shares +=  metric_diffs[:shares]
      activity.likes += metric_diffs[:likes]
      activity.replies += metric_diffs[:replies]
      activity.trend_signals += metric_diffs[:trend_signals]
      activity.save!
    end
  end

  def self.distribution_of(links, hours: 24, language: nil)
    timerange_end = Time.zone.now.beginning_of_hour
    timerange_start = timerange_end.ago((hours.to_i - 1).hours)
    query = select("link_activities.link_id, SUM(link_activities.score) AS score")
      .where(link_id: links.map(&:id), hour_of_activity: timerange_start..timerange_end)
      .order(hour_of_activity: :asc)
      .group(:link_id, :hour_of_activity)
    query = query.where([ "link_activities.language LIKE ?", "#{LinkActivity.sanitize_sql_like(language.downcase)}%" ]) if language
    query
      .to_a
      .group_by(&:link_id)
      .transform_values do |link_activities|
        link_activities.map(&:score)
      end
  end

  private

  def calculate_score
    self.score = distinct_users + trimmed_likes + trimmed_shares + 0.3 * replies
  end
end
