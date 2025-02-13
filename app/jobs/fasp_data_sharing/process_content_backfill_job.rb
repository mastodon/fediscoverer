# Overwrite this class in your fasp application
module FaspDataSharing
  class ProcessContentBackfillJob < ApplicationJob
    queue_as :ingress

    def perform(uri)
      ::RetrieveContentJob.perform_later(uri) unless ContentObject.where(uri:).exists?
    end
  end
end
