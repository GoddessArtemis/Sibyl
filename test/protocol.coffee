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
