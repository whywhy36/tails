module Tails
  class LogFormat
    def self.output(source, log_line)
      "#{source} : #{log_line}"
    end
  end
end