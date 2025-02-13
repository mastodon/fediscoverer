class LinkUsage < ApplicationRecord
  belongs_to :content_object
  belongs_to :link
end
