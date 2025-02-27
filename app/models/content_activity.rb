class ContentActivity < ApplicationRecord
  include ExpirableConcern
  include ScorableConcern

  belongs_to :content_object

  before_save :calculate_score

  def self.record(content_object)
    # TODO use current time for updates
    hour = content_object.published_at.utc.beginning_of_hour
    metric_diffs = content_object.metric_diffs
    activity = find_or_create_by!(content_object:, hour_of_activity: hour)
    activity.with_lock do
      activity.shares += metric_diffs[:shares]
      activity.likes += metric_diffs[:likes]
      activity.replies += metric_diffs[:replies]
      activity.trend_signals += metric_diffs[:trend_signals]
      activity.save!
    end
  end

  def self.record_reply(content_object, replied_at)
    hour = replied_at.utc.beginning_of_hour
    find_or_create_by!(content_object:, hour_of_activity: hour)
    where(content_object_id: content_object.id, hour_of_activity: hour)
      .update_counters(replies: 1)
  end

  def self.distribution_of(content_objects, hours: 24)
    timerange_end = Time.zone.now.beginning_of_hour
    timerange_start = timerange_end.ago((hours.to_i - 1).hours)
    where(content_object_id: content_objects.map(&:id), hour_of_activity: timerange_start..timerange_end)
      .order(hour_of_activity: :asc)
      .group_by(&:content_object_id)
      .transform_values do |content_activities|
        content_activities.map(&:score)
      end
  end

  private

  def calculate_score
    self.score = trend_signals + trimmed_likes + trimmed_shares + 0.3 * replies
  end
end
