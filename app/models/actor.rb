class Actor < ApplicationRecord
  include FullTextSearchableConcern

  TYPES = %w[ Application Group Organization Person Service ].freeze

  # Transient attributes to build an indexable description from
  attribute :name, :string
  attribute :username, :string
  attribute :summary, :string

  belongs_to :server
  has_many :actor_languages, dependent: :delete_all
  has_many :content_objects, dependent: :destroy
  has_many :hashtag_usages, through: :content_objects
  has_many :link_usages, through: :content_objects

  validates :uri, presence: true
  validates :actor_type, presence: true, inclusion: TYPES
  validates :full_text,
    presence: { if: :discoverable? },
    absence: { unless: :discoverable? }

  before_validation :set_full_text
  after_save :remove_unindexable_content

  scope :discoverable, -> { where(discoverable: true) }
  scope :most_popular, -> {
    select("actors.*, (2 * actors.followers_count + SUM(content_objects.likes) + SUM(content_objects.shares)) AS popularity")
      .joins(:content_objects)
      .discoverable
      .group("actors.id")
      .order(popularity: :desc)
  }
  scope :posts_in_language, ->(language) { joins(:actor_languages).where(actor_languages: { language: }) }
  scope :recommended, -> { where(recommended: true) }
  scope :similar, ->(actor) {
    discoverable
      .where("actors.full_text % ?", actor.full_text)
      .where.not(id: actor.id)
  }

  def self.json_to_attributes(json_object)
    {
      actor_type: json_object["type"],
      discoverable: !!json_object["discoverable"],
      indexable: !!json_object["indexable"],
      username: json_object["preferredUsername"],
      name: json_object["name"],
      summary: json_object["summary"]
    }
  end

  def self.create_from_json!(json_object)
    server = Server.from_uri(json_object["id"])
    attributes = json_to_attributes(json_object).merge(server:)
    create_with(attributes).find_or_create_by!(uri: json_object["id"])
  end

  def update_from_json(json_object)
    attributes = self.class.json_to_attributes(json_object)
    update(attributes)
  end

  def update_post_languages!
    self.class.transaction do
      actor_languages.delete_all
      languages = content_objects.distinct.pluck(:language)
      languages = languages.flat_map do |l|
        LanguageTaggableConcern.expand(l)
      end
      languages.uniq!
      languages.each { |l| actor_languages.create_or_find_by!(language: l) }
    end
  end

  def block!
    transaction do
      content_objects.destroy_all
      update!(blocked: true)
    end
  end

  def content_indexable?
    discoverable && indexable && !blocked
  end

  private

  def set_full_text
    self.full_text = if discoverable?
     [ name, username, summary ].compact.join(" ").presence || full_text
    else
      nil
    end
  end

  def remove_unindexable_content
    content_objects.destroy_all unless indexable?
  end
end
