
# Set OTEL_* environment variables according to OTel docs:
# https://opentelemetry.io/docs/concepts/sdk-configuration/

require "opentelemetry/sdk"
require "opentelemetry-exporter-otlp"

if ENV.keys.any? { |name| name.match?(/OTEL_.*_ENDPOINT/) }
  require "opentelemetry/instrumentation/active_support"
  require "opentelemetry/instrumentation/rack"
  require "opentelemetry/instrumentation/action_pack"
  require "opentelemetry/instrumentation/active_record"
  require "opentelemetry/instrumentation/action_view"
  require "opentelemetry/instrumentation/action_mailer"
  require "opentelemetry/instrumentation/concurrent_ruby"
  require "opentelemetry/instrumentation/pg"
  require "opentelemetry/instrumentation/rails"

  ENV['OTEL_TRACES_EXPORTER']  ||= 'console'
  OpenTelemetry::SDK.configure do |c|
    c.service_name = "fediscoverer"

    # excludes OpenTelemetry::Instrumentation::ActiveJob since this is already covered by sidekiq logging
    c.use "OpenTelemetry::Instrumentation::ActionView"
    c.use "OpenTelemetry::Instrumentation::ActionMailer"
    c.use "OpenTelemetry::Instrumentation::ActionPack"
    c.use "OpenTelemetry::Instrumentation::ActiveRecord"
    c.use "OpenTelemetry::Instrumentation::ActiveSupport"
    c.use "OpenTelemetry::Instrumentation::ConcurrentRuby"
    c.use "OpenTelemetry::Instrumentation::PG"
    c.use "OpenTelemetry::Instrumentation::Rack"
    c.use "OpenTelemetry::Instrumentation::Rails"
  end
end

FediscovererTracer = OpenTelemetry.tracer_provider.tracer("fediscoverer")
