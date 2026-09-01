# Overwrite this class in your fasp application
module FaspDataSharing
  class ProcessContentUpdateJob < ApplicationJob
    queue_as :ingress

    def perform(uri)
      return if ContentObject.where(uri:).blank?

      ::RetrieveContentJob.perform_later(uri, true)
    end
  end
end
