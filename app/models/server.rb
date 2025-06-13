class Server < ApplicationRecord
  has_many :actors, dependent: :delete_all
  has_many :content_objects, through: :actors

  normalizes :domain_name, with: ->(domain) { domain.strip.downcase }

  validates :domain_name, presence: true

  def self.from_uri(uri)
    parsed_uri = URI(uri)
    server = find_or_create_by!(domain_name: parsed_uri.host)
  end

  def self.fetch(uri)
    from_uri(uri).fetch(uri)
  end

  def fetch(uri)
    FaspDataSharing::ActivityPubObject.new(uri:).fetch
    # TODO: Catch and record exceptions, use information to skip
    # or retry jobs at a later time
  end

  def block!
    transaction do
      actors.destroy_all
      update!(blocked: true)
    end
  end
end
