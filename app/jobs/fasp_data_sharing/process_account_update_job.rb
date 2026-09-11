# Overwrite this class in your fasp application
module FaspDataSharing
  class ProcessAccountUpdateJob < ApplicationJob
    queue_as :ingress

    def perform(uri)
      return if uri.blank?

      ::UpdateActorJob.perform_later(uri)
    end
  end
end
