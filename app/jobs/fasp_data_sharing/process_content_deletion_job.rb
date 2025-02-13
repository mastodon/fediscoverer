# Overwrite this class in your fasp application
module FaspDataSharing
  class ProcessContentDeletionJob < ApplicationJob
    queue_as :ingress

    def perform(uri)
      content_object = ::ContentObject.where(uri:).first
      ::DeleteContentObjectJob.perform_later(content_object) if content_object
    end
  end
end
