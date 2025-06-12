# Set `PROMETHEUS_EXPORTER_ENABLED` to `true` to turn on
# metrics exporting via the `prometheus_exporter` gem

if ENV.fetch("PROMETHEUS_EXPORTER_ENABLED", nil) == "true"
  require "prometheus_exporter"
  require "prometheus_exporter/middleware"

  # This reports stats per request like HTTP status and timings
  Rails.application.middleware.unshift PrometheusExporter::Middleware

  # Get simple SolidQueue metrics
  require "prometheus_exporter/instrumentation"
  require "prometheus_exporter/instrumentation/solid_queue"

  Rails.application.config.after_initialize do
    PrometheusExporter::Instrumentation::SolidQueue.start
  end
end
