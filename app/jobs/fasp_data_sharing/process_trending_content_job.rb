# Overwrite this class in your fasp application
module FaspDataSharing
  class ProcessTrendingContentJob < ApplicationJob
    queue_as :ingress

    def perform(uri)
      content_object = ::ContentObject.where(uri:).take

      if content_object
        content_object.increment(:trend_signals)
        content_object.save
      else
        ::RetrieveContentJob.perform_later(uri)
      end
    end
  end
end
