module JsonLogging
  class Logger < ::ActiveSupport::Logger
    class_attribute :json_logging_initialized

    def self.initialize_json_logging
      # Suppress some built-in, per-request logging
      ::ActiveSupport.on_load(:action_controller) do
        ::ActionController::LogSubscriber.detach_from :action_controller
      end
      ::ActiveSupport.on_load(:action_view) do
        ::ActionView::LogSubscriber.detach_from :action_view
      end

      # Install JSON-aware request log subscriber
      ActionControllerLogSubscriber.attach_to :action_controller

      self.json_logging_initialized = true
    end

    def initialize(logdev = STDOUT, name: "rails")
      self.class.initialize_json_logging unless json_logging_initialized?
      @formatter = Formatter.new(name)
      super(logdev)
    end

    def formatter=(_)
      # We do not allow using a different formatter here
    end
  end
end
