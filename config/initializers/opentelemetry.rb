# config/initializers/opentelemetry.rb
require "opentelemetry/sdk"
require "opentelemetry/instrumentation/all"
require "opentelemetry-exporter-otlp"

OpenTelemetry::SDK.configure do |c|
  c.service_name = "fediscoverer"
  # c.use_all() is not being used to exclude OpenTelemetry::Instrumentation::ActiveJob since this is already covered by sidekiq logging
  c.use "OpenTelemetry::Instrumentation::ActiveSupport"
  c.use "OpenTelemetry::Instrumentation::Rack"
  c.use "OpenTelemetry::Instrumentation::ActionPack"
  c.use "OpenTelemetry::Instrumentation::ActiveRecord"
  c.use "OpenTelemetry::Instrumentation::ActionView"
  c.use "OpenTelemetry::Instrumentation::ActionMailer"
  c.use "OpenTelemetry::Instrumentation::HTTPX"
  c.use "OpenTelemetry::Instrumentation::ConcurrentRuby"
  c.use "OpenTelemetry::Instrumentation::Net::HTTP"
  c.use "OpenTelemetry::Instrumentation::PG"
  c.use "OpenTelemetry::Instrumentation::Rails"
end

FediscovererTracer = OpenTelemetry.tracer_provider.tracer("fediscoverer")
