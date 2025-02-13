# Overwrite this class in your fasp application
module FaspDataSharing
  class ProcessAccountBackfillJob < ApplicationJob
    queue_as :ingress

    def perform(uri)
      ::RetrieveActorJob.perform_later(uri) unless ::Actor.where(uri:).exists?
    end
  end
end
