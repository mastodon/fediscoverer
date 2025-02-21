class DeleteExpiredActivityJob < ApplicationJob
  queue_as :deletion

  def perform(*args)
    ContentActivity.expired.delete_all
    HashtagActivity.expired.delete_all
    LinkActivity.expired.delete_all
  end
end
