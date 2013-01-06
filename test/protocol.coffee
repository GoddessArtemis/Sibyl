should = (require 'chai').should()
fs = require 'fs'
PEG = require 'pegjs'
parser = PEG.buildParser fs.readFileSync('protocol.pegjs', 'utf8')

describe 'parser', ->
    describe '#parse()', ->
        it 'should parse is lines with integers correctly', ->
            result = parser.parse 'foo is 25'
            result.should.deep.equal [{name: 'foo', type: 'is', value: 25}]

        it 'should parse is lines with negative integers correctly', ->
            result = parser.parse 'foo is -25'
            result.should.deep.equal [{name: 'foo', type: 'is', value: -25}]

        it 'should parse is lines with decimal values correctly', ->
            result = parser.parse 'foo is 0.25'
            result.should.deep.equal [{name: 'foo', type: 'is', value: 0.25}]

        it 'should parse took lines with integers correctly', ->
            result = parser.parse 'foo took 25'
            result.should.deep.equal [{name: 'foo', type: 'took', value: 25, count: 1}]

        it 'should reject took lines with negative integers', ->
            result = parser.parse 'foo took -25'
            result.should.deep.equal [undefined]

        it 'should parse took lines with decimal values correctly', ->
            result = parser.parse 'foo took 0.25'
            result.should.deep.equal [{name: 'foo', type: 'took', value: 0.25, count: 1}]

        it 'should parse hit lines correctly', ->
            result = parser.parse 'foo hit'
            result.should.deep.equal [{name: 'foo', type: 'hit', value: 1}]

        it 'should parse happened lines correctly', ->
            result = parser.parse 'foo happened'
            result.should.deep.equal [{name: 'foo', type: 'happened'}]

        it 'should parse new lines correctly', ->
            result = parser.parse 'a happened\nb happened\rc happened\n\rd happened\r\ne happened'
            result.should.deep.equal [{name: 'a', type: 'happened'}
                                      {name: 'b', type: 'happened'}
                                      {name: 'c', type: 'happened'}
                                      {name: 'd', type: 'happened'}
                                      {name: 'e', type: 'happened'}]

        it 'should reject bad lines', ->
            result = parser.parse 'wasd'
            result.should.deep.equal [undefined]

        it 'should parse a valid line surrounded by garbage', ->
            result = parser.parse 'garbage\nfoo hit\ngarbage'
            result.should.deep.equal [undefined, {name: 'foo', type: 'hit', value: 1}, undefined]

        it 'should parse StatsD style counters as hit lines', ->
            result = parser.parse 'gorets:1|c'
            result.should.deep.equal [{name: 'gorets', type: 'hit', value: 1}]

        it 'should parse StatsD style counters with values other than 1', ->
            result = parser.parse 'gorets:3|c\nnorets:-4|c'
            result.should.deep.equal [{name: 'gorets', type: 'hit', value:  3}
                                      {name: 'norets', type: 'hit', value: -4}]

        it 'should parse StatsD style counters with rates', ->
            result = parser.parse 'gorets:1|c|@0.1\nnorets:2|c|@0.5'
            result.should.deep.equal [{name: 'gorets', type: 'hit', value: 10}
                                      {name: 'norets', type: 'hit', value: 4}]

        it 'should parse StatsD style gauges as is lines', ->
            result = parser.parse 'gaugor:333|g'
            result.should.deep.equal [{name: 'gaugor', type: 'is', value: 333}]

        it 'should ignore the rate for StatsD style gauges', ->
            result = parser.parse 'gaugor:333|g|@0.1'
            result.should.deep.equal [{name: 'gaugor', type: 'is', value: 333}]

        it 'should parse StatsD style timings as took lines', ->
            result = parser.parse 'glork:320|ms'
            result.should.deep.equal [{name: 'glork', type: 'took', value: 320, count: 1}]

        it 'should parse StatsD style timings with rates', ->
            result = parser.parse 'glork:320|ms|@0.1'
            result.should.deep.equal [{name: 'glork', type: 'took', value: 320, count: 10}]

        it 'should parse StatsD style names correctly', ->
            result = parser.parse 'gorets%glork   gaugor/foo:1|c'
            result[0].name.should.equal 'goretsglork_gaugor-foo'
