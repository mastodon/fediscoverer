module ExpirableConcern
  extend ActiveSupport::Concern

  included do
    scope :expired, -> { where(hour_of_activity: ..((14.days + 1.hour).ago)) }
  end
end
