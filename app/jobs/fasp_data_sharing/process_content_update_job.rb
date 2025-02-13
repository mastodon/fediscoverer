# Overwrite this class in your fasp application
module FaspDataSharing
  class ProcessContentUpdateJob < ApplicationJob
    queue_as :ingress

    def perform(uri)
      ::RetrieveContentJob.perform_later(uri, true)
    end
  end
end
