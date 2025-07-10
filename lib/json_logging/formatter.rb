module JsonLogging
  class Formatter
    def initialize(name)
      @name = name
      @hostname = Socket.gethostname
    end

    def call(severity, time, _progname, payload)
      pid = Process.pid

      log = {
        level: severity.downcase,
        time: time.to_i,
        pid:,
        hostname: @hostname,
        name: @name
      }

      case payload
      when Hash
        log.merge!(payload)
      else
        log.merge!(msg: payload)
      end

      log.to_json + "\n"
    end
  end
end
