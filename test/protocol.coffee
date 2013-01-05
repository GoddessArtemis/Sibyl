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
