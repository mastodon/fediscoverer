# Overwrite this class in your fasp application
module FaspDataSharing
  class ProcessAccountUpdateJob < ApplicationJob
    queue_as :ingress

    def perform(uri)
      ::RetrieveActorJob.perform_later(uri, true)
    end
  end
end
