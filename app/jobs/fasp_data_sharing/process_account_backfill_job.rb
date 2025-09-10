# Overwrite this class in your fasp application
module FaspDataSharing
  class ProcessAccountBackfillJob < ApplicationJob
    queue_as :ingress

    def perform(uri)
      return if uri.blank?
      return if ::Actor.where(uri:).exists?

      ::RetrieveActorJob.perform_later(uri)
    end
  end
end
