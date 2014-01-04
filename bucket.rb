require 'em-websocket'
require_relative 'worker'

EM.run {
  EM::WebSocket.run(:host => "0.0.0.0", :port => 9000) do |ws|
    ws.onopen { |handshake|
      puts "WebSocket connection open"

      # Publish message to the client
      ws.send "Hello Client, you connected to #{handshake.path}"
    }

    ws.onclose { puts "Connection closed" }

    ws.onmessage { |msg|
      puts "Recieved message: #{msg}"

      Tails::Worker.new ws, msg
    }
  end
}