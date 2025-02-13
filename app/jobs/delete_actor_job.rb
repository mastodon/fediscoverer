class DeleteActorJob < ApplicationJob
  queue_as :deletion

  def perform(actor)
    actor.destroy
  end
end
