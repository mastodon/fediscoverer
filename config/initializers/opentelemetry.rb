# config/initializers/opentelemetry.rb
require "opentelemetry/sdk"
require "opentelemetry/instrumentation/all"
require "opentelemetry-exporter-otlp"

OpenTelemetry::SDK.configure do |c|
  c.service_name = "fediscoverer"
  c.use_all()
end

FediscovererTracer = OpenTelemetry.tracer_provider.tracer("fediscoverer")
