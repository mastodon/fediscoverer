class ContentObject < ApplicationRecord
  include FullTextSearchableConcern
  include LanguageTaggableConcern
  include RankableConcern

  TYPES = %w[ Article Audio Document Event Image Note Page Place Profile Relationship Video].freeze
  PUBLIC_URI = "https://www.w3.org/ns/activitystreams#Public"

  attribute :in_reply_to, :string

  belongs_to :actor
  has_one :server, through: :actor
  has_many :content_activities, dependent: :delete_all
  has_many :hashtag_usages, dependent: :destroy
  has_many :link_usages, dependent: :destroy
  has_many :hashtags, through: :hashtag_usages, dependent: :destroy
  has_many :links, through: :link_usages, dependent: :destroy

  validates :uri, presence: true
  validates :object_type, presence: true, inclusion: TYPES

  validate :permission_to_be_indexed

  after_save :record_activity
  after_save :add_actor_languages
  after_destroy :update_actor_languages

  scope :recent, -> { order(published_at: :desc) }
  scope :from_hour, ->(hour) {
    where(content_objects: { published_at: hour...hour.since(1.hour) })
  }
  scope :trending, TrendsQuery

  class << self
    def json_to_attributes(json_object)
      hashtags = (json_object["tag"] || []).filter_map { |t| t["name"] if t["type"] == "Hashtag" }
      links = LinkExtractor.new(json_object).extracted_urls
      {
        object_type: json_object["type"],
        published_at: json_object["published"],
        in_reply_to: json_object["inReplyTo"],
        last_edited_at: json_object["updated"] || json_object["published"],
        sensitive: !!json_object["sensitive"],
        language: json_object["contentMap"]&.keys&.first || "en",
        full_text: json_object["content"],
        shares: json_object.dig("shares", "totalItems") || 0,
        likes: json_object.dig("likes", "totalItems") || 0,
        hashtags: hashtags.map { |name| Hashtag.find_or_initialize_by(name:) },
        links: links.map { |url| Link.find_or_initialize_by(url:) },
        attached_images: count_attachments(json_object, "image"),
        attached_videos: count_attachments(json_object, "video"),
        attached_audio: count_attachments(json_object, "audio")
      }
    end

    def create_from_json!(json_object)
      # Stop if object is not meant ot be public
      return unless Array(json_object["to"]).include?(PUBLIC_URI)

      # Retrieve actor if unknown
      RetrieveActorJob.perform_now(json_object["attributedTo"])
      actor = Actor.where(uri: json_object["attributedTo"]).take

      # Stop if author not retrievable or has not opted-in to indexing
      # or is blocked altogether
      return unless actor&.content_indexable?

      attributes = json_to_attributes(json_object).merge(actor:)

      create_with(attributes).find_or_create_by!(uri: json_object["id"])
    end

    private

    def count_attachments(json_object, type)
      (json_object["attachments"] || []).count do |attachment|
        attachment["mediaType"].start_with?(type)
      end
    end
  end

  def update_from_json(json_object)
    attributes = self.class.json_to_attributes(json_object)
      .except(:published_at)
    update(attributes)
  end

  def metric_diffs
    {
      shares: metric_diff(:shares),
      likes: metric_diff(:likes),
      replies: metric_diff(:replies),
      trend_signals: metric_diff(:trend_signals)
    }
  end

  private

  # TODO: this should probably return 0 on newly created records
  # so not all values spike when a record is created
  def metric_diff(metric)
    change = previous_changes[metric.to_s]
    if change
      change[1] - change[0]
    else
      0
    end
  end

  def permission_to_be_indexed
    unless actor&.content_indexable?
      errors.add(:base, :indexing_not_permitted)
    end
  end

  def record_activity
    record_reply if in_reply_to.present?
    ContentActivity.record(self)
    hashtags.each { HashtagActivity.record(self, it) }
    links.each { LinkActivity.record(self, it) }
  end

  def record_reply
    parent = self.class.where(uri: in_reply_to).take
    return unless parent

    ContentActivity.record_reply(parent, published_at)
  end

  def add_actor_languages
    LanguageTaggableConcern.expand(language).each do |l|
      actor.actor_languages.find_or_create_by(language: l)
    end
  end

  def update_actor_languages
    actor.update_post_languages!
  end
end
