# Overwrite this class in your fasp application
module FaspDataSharing
  class ProcessContentUpdateJob < ApplicationJob
    queue_as :ingress

    def perform(uri)
      return if ContentObject.where(uri:).blank?

      ::UpdateContentJob.perform_later(uri)
    end
  end
end
