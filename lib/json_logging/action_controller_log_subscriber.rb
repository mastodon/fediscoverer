module JsonLogging
  class ActionControllerLogSubscriber < ActiveSupport::LogSubscriber
    def process_action(event)
      # return if event.payload[:exception].present?

      request = event.payload[:request]
      response = event.payload[:response]
      error = event.payload[:exception]

      params = request.filtered_parameters

      info do
        req = {
          id: request.request_id,
          method: request.request_method,
          url: request.filtered_path,
          remoteAddress: request.remote_ip
        }
        req[:params] = params if params.present?

        {
          req:,
          res: {
            statusCode: error ? 500 : response.status
          },
          responseTime: event.duration.to_i
        }
      end
    end
  end
end
