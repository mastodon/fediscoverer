class ApplicationJob < ActiveJob::Base
  # Spread out retries caused by HTTP 5xx errors
  HTTP_5XX_RETRY_DELAY = ->(executions) { executions ** 5 + 30 }

  # Automatically retry jobs that encountered a deadlock
  retry_on ActiveRecord::Deadlocked

  # Retry on HTTP errors
  retry_on(HTTPX::HTTPError, wait: HTTP_5XX_RETRY_DELAY) do |job, error|
    # Do not raise the error on the final retry
  end

  # Most jobs are safe to ignore if the underlying records are no longer available
  discard_on ActiveJob::DeserializationError
end
