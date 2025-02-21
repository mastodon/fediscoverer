class Actor < ApplicationRecord
  include FullTextSearchableConcern

  TYPES = %w[ Application Group Organization Person Service ].freeze

  # Transient attributes to build an indexable description from
  attribute :name, :string
  attribute :username, :string
  attribute :summary, :string

  belongs_to :server
  has_many :content_objects
  has_many :hashtag_usages, through: :content_objects
  has_many :link_usages, through: :content_objects

  validates :uri, presence: true
  validates :actor_type, presence: true, inclusion: TYPES
  validates :full_text,
    presence: { if: :discoverable? },
    absence: { unless: :discoverable? }

  after_save :remove_unindexable_content

  scope :discoverable, -> { where(discoverable: true) }

  def self.json_to_attributes(json_object)
    {
      actor_type: json_object["type"],
      discoverable: json_object["discoverable"],
      indexable: json_object["indexable"],
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

  private

  def set_full_text
    self.full_text = if discoverable?
      [ name, username, stripped_summary ].compact.join(" ")
    else
      nil
    end
  end

  def remove_unindexable_content
    content_objects.destroy_all unless indexable?
  end

  def stripped_summary
    Rails::Html::FullSanitizer.new.sanitize(summary) if summary.present?
  end
end
