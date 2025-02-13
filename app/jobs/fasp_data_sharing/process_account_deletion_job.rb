# Overwrite this class in your fasp application
module FaspDataSharing
  class ProcessAccountDeletionJob < ApplicationJob
    queue_as :ingress

    def perform(uri)
      actor = ::Actor.where(uri:).first
      ::DeleteActorJob.perform_later(actor) if actor
    end
  end
end
