dgram = require 'dgram'
fs = require 'fs'
PEG = require 'pegjs'

parser = PEG.buildParser fs.readFileSync('protocol.pegjs', 'utf8')
server = dgram.createSocket 'udp4'

server.on "message", (msg, rinfo) ->
    msg = msg.toString 'utf8'
    console.log parser.parse msg

server.bind 8126
