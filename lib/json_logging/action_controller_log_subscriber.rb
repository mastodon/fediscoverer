module JsonLogging
  class ActionControllerLogSubscriber < ActiveSupport::LogSubscriber
    def process_action(event)
      # return if event.payload[:exception].present?

      payload = event.payload
      request = payload[:request]
      response = payload[:response]
      error = payload[:exception]

      params = request.filtered_parameters
      controller = params.delete(:controller)
      action = params.delete(:action)

      info do
        req = {
          id: request.request_id,
          method: request.request_method,
          url: request.filtered_path,
          format: payload[:format] || "*/*",
          remoteAddress: request.remote_ip
        }
        req[:params] = params if params.present?
        req[:controller] = controller if controller.present?
        req[:action] = action if action.present?

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
