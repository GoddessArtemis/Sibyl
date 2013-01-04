should = (require 'chai').should()
hit = require '../../aggregators/hit'

describe 'hit', ->
    describe '#aggregate()', ->
        it 'should give the correct start time for the lines', ->
            lines = [{name: 'OK', type: 'hit', value: 1, time: 15000}]
            lines.starttime = 10000
            lines.endtime = 20000
            result = hit lines
            result.starttime.should.equal 10000

        it 'should give the correct end time for the lines', ->
            lines = [{name: 'OK', type: 'hit', value: 1, time: 15000}]
            lines.starttime = 10000
            lines.endtime = 20000
            result = hit lines
            result.endtime.should.equal 20000

        it 'should give the correct number of hits with no lines', ->
            lines = []
            lines.starttime = 10000
            lines.endtime = 20000
            result = hit lines
            result.count.should.equal 0

        it 'should give the correct number of hits with a single line', ->
            lines = [{name: 'OK', type: 'hit', value: 1, time: 15000}]
            lines.starttime = 10000
            lines.endtime = 20000
            result = hit lines
            result.count.should.equal 1

        it 'should give the correct number of hits with multiple lines', ->
            lines = [{name: 'OK', type: 'hit', value: 1, time: 11000},
                     {name: 'OK', type: 'hit', value: 1, time: 13000},
                     {name: 'OK', type: 'hit', value: 1, time: 15000},
                     {name: 'OK', type: 'hit', value: 1, time: 17000},
                     {name: 'OK', type: 'hit', value: 1, time: 19000}]
            lines.starttime = 10000
            lines.endtime = 20000
            result = hit lines
            result.count.should.equal 5

        it 'should give the correct number of hits for lines with values other than 1', ->
            lines = [{name: 'OK', type: 'hit', value: -9, time: 11000},
                     {name: 'OK', type: 'hit', value: -3, time: 13000},
                     {name: 'OK', type: 'hit', value:  6, time: 15000},
                     {name: 'OK', type: 'hit', value:  2, time: 17000},
                     {name: 'OK', type: 'hit', value: -5, time: 19000}]
            lines.starttime = 10000
            lines.endtime = 20000
            result = hit lines
            result.count.should.equal -9
