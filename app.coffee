dgram = require 'dgram'
server = dgram.createSocket 'udp4'

server.on "message", (msg, rinfo) ->
    msg = msg.toString 'utf8'
    console.log msg.split /\n\r?|\r\n?/

server.bind 8126
