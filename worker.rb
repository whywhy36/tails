require 'eventmachine'
require 'eventmachine-tail'

require_relative 'log_format'

module Tails
  class Worker < EventMachine::FileTail
    attr_reader :ws
    def initialize(ws, path, startpos = -1)
      super path, startpos
      @ws = ws
      puts "tailing content from #{path}"
      @buffer = BufferedTokenizer.new
    rescue => e
      ws.send "Error tailing file #{path}"
      ws.send "Exception info: #{e.inspect}"
    end

    def receive_data(data)
      @buffer.extract(data).each do |line|
        ws.send LogFormat.output(path, line)
      end
    end 
  end
end