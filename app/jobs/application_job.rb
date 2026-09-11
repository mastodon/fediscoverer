class ApplicationJob < ActiveJob::Base
  # Spread out retries caused by HTTP 5xx errors
  HTTP_RETRY_DELAY = ->(executions) { executions ** 5 + 30 }

  # Automatically retry jobs that encountered a deadlock
  retry_on ActiveRecord::Deadlocked

  # Retry on HTTP 4xx/5xx errors
  # Only allows 4xx errors to bubble up as these could hint at
  # fediscoverer doing something wrong. 5xx errors mean that
  # something is wrong on the other end, so once all the retries
  # are exhausted, there is no need to raise the exception any
  # more.
  retry_on(HTTPX::HTTPError, wait: HTTP_RETRY_DELAY) do |_job, error|
    raise error if error.status < 500
  end

  # Handle other types of connection errors
  # Again, we cannot do anything about this other than retrying,
  # so once all retry attempts have been exhausted, we do not
  # want the exception to be raised further.
  retry_on(HTTPX::TimeoutError, HTTPX::Connection::HTTP2::Error, wait: HTTP_RETRY_DELAY) do |_job, _error|
    # Do nothing
  end

  # We ignore invalid JSON (which is often just HTML from error pages and/or misconfigured web servers
  discard_on JSON::ParserError

  # Most jobs are safe to ignore if the underlying records are no longer available
  discard_on ActiveJob::DeserializationError
end
