dgram = require 'dgram'
fs = require 'fs'
PEG = require 'pegjs'
aggregators =
    is: require './aggregators/is'
    took: require './aggregators/took'
    hit: require './aggregators/hit'
    happened: require './aggregators/happened'

parser = PEG.buildParser fs.readFileSync('protocol.pegjs', 'utf8')
server = dgram.createSocket 'udp4'
buckets = {}

server.on "message", (msg, rinfo) ->
    ts = Date.now() / 1000;
    msg = msg.toString 'utf8'
    lines = parser.parse msg
    for line in lines
        if not line
            # skip badlines for now
        else
            (buckets[line.type + ':' + line.name] ?= []).push line

update = ->
    chunk = buckets
    buckets = {}
    aggregates = {}
    for key, lines of chunk
        aggregates[key] = aggregators[lines[0].type] lines
    console.log aggregates

setInterval update, 10000
server.bind 8126
