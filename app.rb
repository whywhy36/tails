require 'sinatra/base'
require 'em-websocket'
require 'thin'

require_relative 'worker'


pid = Process.pid

SIGNALS = ['TERM', 'INT']
SIGNALS.each do |sig|
  Signal.trap sig do
    Process.kill sig, pid
  end
end

EM.run do
  class App < Sinatra::Base
    get '/' do
      send_file File.join('public', 'index.html')
    end
  end

  EM::WebSocket.start(:host => '0.0.0.0', :port => 9001 ) do |ws|
    ws.onopen { |handshake|
      puts "Websocket connection open ..."
      ws.send "Hello client, you connected to #{handshake.path}"
    }

    ws.onclose {
      puts "Connection closed"
    }

    ws.onmessage { |file_path|
      puts "File Path: #{file_path}"
      Tails::Worker.new ws, file_path
    }
  end

  App.run!({:port => 9000})
end
