# frozen_string_literal: true

# collects stats from SolidQueue
module PrometheusExporter::Instrumentation
  class SolidQueue < PeriodicStats
    def self.start(client: nil, frequency: 30)
      solid_queue_collector = new
      client ||= PrometheusExporter::Client.default

      worker_loop { client.send_json(solid_queue_collector.collect) }

      super
    end

    def collect
      queued = ::SolidQueue::ReadyExecution.group(:queue_name).count
      failed = ::SolidQueue::FailedExecution.joins(:job).group(solid_queue_jobs: :queue_name).count
      queues = ::SolidQueue::Queue.all
      latency = {}
      queues.each do |queue|
        queued[queue.name] ||= 0
        failed[queue.name] ||= 0
        latency[queue.name] = queue.latency
      end

      {
        type: "solid_queue",
        queued:,
        failed:,
        latency:
      }
    end
  end
end
