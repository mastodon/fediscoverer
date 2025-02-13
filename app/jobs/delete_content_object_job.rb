class DeleteContentObjectJob < ApplicationJob
  queue_as :deletion

  def perform(content_object)
    content_object.destroy
  end
end
