# frozen_string_literal: true

module PrometheusExporter
  module Server
    class SolidQueueCollector < TypeCollector
      MAX_METRIC_AGE = 30
      SOLID_QUEUE_GAUGES = {
        queued: "Number of queued SolidQueue jobs.",
        failed: "Number of failed SolidQueue jobs.",
        latency: "SolidQueue queue latency in seconds"
      }

      def initialize
        @solid_queue_metrics = MetricsContainer.new(ttl: MAX_METRIC_AGE)
        @gauges = {}
      end

      def type
        "solid_queue"
      end

      def metrics
        return [] if solid_queue_metrics.length == 0

        solid_queue_metrics.each do |metric|
          SOLID_QUEUE_GAUGES.map do |name, help|
            values_by_queue = metric[name.to_s]
            next unless values_by_queue

            gauge = gauges[name] ||= PrometheusExporter::Metric::Gauge.new("solid_queue_#{name}", help)
            values_by_queue.each do |queue_name, value|
              gauge.observe(value, { queue_name: })
            end
          end
        end

        gauges.values
      end

      def collect(object)
        @solid_queue_metrics << object
      end

      private

      attr_reader :solid_queue_metrics, :gauges
    end
  end
end
