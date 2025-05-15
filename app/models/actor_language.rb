class ActorLanguage < ApplicationRecord
  include LanguageTaggableConcern

  belongs_to :actor
end
