should = (require 'chai').should()
aggregators =
    is: require '../../aggregators/is'

describe 'is', ->
    describe '#aggregate()', ->
        it 'should give the correct start time for the lines', ->
            lines = [{name: 'OK', type: 'is', value : 50, time: 15000}]
            lines.starttime = 10000
            lines.endtime = 20000
            result = aggregators.is lines, 'is:OK', {}
            result.starttime.should.equal 10000

        it 'should give the correct end time for the lines', ->
            lines = [{name: 'OK', type: 'is', value : 50, time: 15000}]
            lines.starttime = 10000
            lines.endtime = 20000
            result = aggregators.is lines, 'is:OK', {}
            result.endtime.should.equal 20000

        it 'should give the correct count of lines', ->
            lines = [{name: 'OK', type: 'is', value: 10, time: 11000},
                     {name: 'OK', type: 'is', value: 30, time: 13000},
                     {name: 'OK', type: 'is', value: 50, time: 15000},
                     {name: 'OK', type: 'is', value: 70, time: 17000},
                     {name: 'OK', type: 'is', value: 90, time: 19000}]
            lines.starttime = 10000
            lines.endtime = 20000
            result = aggregators.is lines, 'is:OK', {}
            result.count.should.equal 5

        it 'should give the correct total', ->
            lines = [{name: 'OK', type: 'is', value: 10, time: 11000},
                     {name: 'OK', type: 'is', value: 30, time: 13000},
                     {name: 'OK', type: 'is', value: 50, time: 15000},
                     {name: 'OK', type: 'is', value: 70, time: 17000},
                     {name: 'OK', type: 'is', value: 90, time: 19000}]
            lines.starttime = 10000
            lines.endtime = 20000
            result = aggregators.is lines, 'is:OK', {}
            result.total.should.equal 410000

        it 'should give the correct total when there are negative values', ->
            lines = [{name: 'OK', type: 'is', value:  10, time: 11000},
                     {name: 'OK', type: 'is', value: -30, time: 13000},
                     {name: 'OK', type: 'is', value: -50, time: 15000},
                     {name: 'OK', type: 'is', value:  70, time: 17000},
                     {name: 'OK', type: 'is', value:  90, time: 19000}]
            lines.starttime = 10000
            lines.endtime = 20000
            result = aggregators.is lines, 'is:OK', {}
            result.total.should.equal 90000

        it 'should give the correct total when there is a starting value', ->
            lines = [{name: 'OK', type: 'is', value: 10, time: 11000},
                     {name: 'OK', type: 'is', value: 30, time: 13000},
                     {name: 'OK', type: 'is', value: 50, time: 15000},
                     {name: 'OK', type: 'is', value: 70, time: 17000},
                     {name: 'OK', type: 'is', value: 90, time: 19000}]
            lines.starttime = 10000
            lines.endtime = 20000
            lines.startvalue = 80
            result = aggregators.is lines, 'is:OK', {}
            result.total.should.equal 490000

        it 'should give the correct minimum value', ->
            lines = [{name: 'OK', type: 'is', value: 10, time: 11000},
                     {name: 'OK', type: 'is', value: 30, time: 13000},
                     {name: 'OK', type: 'is', value: 50, time: 15000},
                     {name: 'OK', type: 'is', value: 70, time: 17000},
                     {name: 'OK', type: 'is', value: 90, time: 19000}]
            lines.starttime = 10000
            lines.endtime = 20000
            result = aggregators.is lines, 'is:OK', {}
            result.min.should.equal 10

        it 'should give the correct minimum value when there is a starting value', ->
            lines = [{name: 'OK', type: 'is', value: 10, time: 11000},
                     {name: 'OK', type: 'is', value: 30, time: 13000},
                     {name: 'OK', type: 'is', value: 50, time: 15000},
                     {name: 'OK', type: 'is', value: 70, time: 17000},
                     {name: 'OK', type: 'is', value: 90, time: 19000}]
            lines.starttime = 10000
            lines.endtime = 20000
            lines.startvalue = 5
            result = aggregators.is lines, 'is:OK', {}
            result.min.should.equal 5

        it 'should give the correct minimum value when there are negative values', ->
            lines = [{name: 'OK', type: 'is', value: -10, time: 11000},
                     {name: 'OK', type: 'is', value:  30, time: 13000},
                     {name: 'OK', type: 'is', value:  50, time: 15000},
                     {name: 'OK', type: 'is', value: -70, time: 17000},
                     {name: 'OK', type: 'is', value:  90, time: 19000}]
            lines.starttime = 10000
            lines.endtime = 20000
            result = aggregators.is lines, 'is:OK', {}
            result.min.should.equal -70

        it 'should give the correct maximum value', ->
            lines = [{name: 'OK', type: 'is', value: 10, time: 11000},
                     {name: 'OK', type: 'is', value: 30, time: 13000},
                     {name: 'OK', type: 'is', value: 50, time: 15000},
                     {name: 'OK', type: 'is', value: 70, time: 17000},
                     {name: 'OK', type: 'is', value: 90, time: 19000}]
            lines.starttime = 10000
            lines.endtime = 20000
            result = aggregators.is lines, 'is:OK', {}
            result.max.should.equal 90

        it 'should give the correct maximum value when there is a starting value', ->
            lines = [{name: 'OK', type: 'is', value: 10, time: 11000},
                     {name: 'OK', type: 'is', value: 30, time: 13000},
                     {name: 'OK', type: 'is', value: 50, time: 15000},
                     {name: 'OK', type: 'is', value: 70, time: 17000},
                     {name: 'OK', type: 'is', value: 90, time: 19000}]
            lines.starttime = 10000
            lines.endtime = 20000
            lines.startvalue = 95
            result = aggregators.is lines, 'is:OK', {}
            result.max.should.equal 95

        it 'should give the correct maximum value when all the values are negative', ->
            lines = [{name: 'OK', type: 'is', value: -10, time: 11000}]
            lines.starttime = 10000
            lines.endtime = 20000
            result = aggregators.is lines, 'is:OK', {}
            result.max.should.equal -10

        it 'should give the correct first time when there is no starting value', ->
            lines = [{name: 'OK', type: 'is', value: 10, time: 11000},
                     {name: 'OK', type: 'is', value: 30, time: 13000},
                     {name: 'OK', type: 'is', value: 50, time: 15000},
                     {name: 'OK', type: 'is', value: 70, time: 17000},
                     {name: 'OK', type: 'is', value: 90, time: 19000}]
            lines.starttime = 10000
            lines.endtime = 20000
            result = aggregators.is lines, 'is:OK', {}
            result.firsttime.should.equal 11000

        it 'should give the correct first time when there is a starting value', ->
            lines = [{name: 'OK', type: 'is', value: 10, time: 11000},
                     {name: 'OK', type: 'is', value: 30, time: 13000},
                     {name: 'OK', type: 'is', value: 50, time: 15000},
                     {name: 'OK', type: 'is', value: 70, time: 17000},
                     {name: 'OK', type: 'is', value: 90, time: 19000}]
            lines.starttime = 10000
            lines.endtime = 20000
            lines.startvalue = 80
            result = aggregators.is lines, 'is:OK', {}
            result.firsttime.should.equal 10000

        it 'should give the correct first value when there is no starting value', ->
            lines = [{name: 'OK', type: 'is', value: 10, time: 11000},
                     {name: 'OK', type: 'is', value: 30, time: 13000},
                     {name: 'OK', type: 'is', value: 50, time: 15000},
                     {name: 'OK', type: 'is', value: 70, time: 17000},
                     {name: 'OK', type: 'is', value: 90, time: 19000}]
            lines.starttime = 10000
            lines.endtime = 20000
            result = aggregators.is lines, 'is:OK', {}
            result.firstvalue.should.equal 10

        it 'should give the correct first value when there is a starting value', ->
            lines = [{name: 'OK', type: 'is', value: 10, time: 11000},
                     {name: 'OK', type: 'is', value: 30, time: 13000},
                     {name: 'OK', type: 'is', value: 50, time: 15000},
                     {name: 'OK', type: 'is', value: 70, time: 17000},
                     {name: 'OK', type: 'is', value: 90, time: 19000}]
            lines.starttime = 10000
            lines.endtime = 20000
            lines.startvalue = 80
            result = aggregators.is lines, 'is:OK', {}
            result.firstvalue.should.equal 80

        it 'should give the correct last value', ->
            lines = [{name: 'OK', type: 'is', value: 10, time: 11000},
                     {name: 'OK', type: 'is', value: 30, time: 13000},
                     {name: 'OK', type: 'is', value: 50, time: 15000},
                     {name: 'OK', type: 'is', value: 70, time: 17000},
                     {name: 'OK', type: 'is', value: 90, time: 19000}]
            lines.starttime = 10000
            lines.endtime = 20000
            result = aggregators.is lines, 'is:OK', {}
            result.lastvalue.should.equal 90

        it 'should carry the last value over to the next bucket', ->
            lines = [{name: 'OK', type: 'is', value: 10, time: 11000},
                     {name: 'OK', type: 'is', value: 30, time: 13000},
                     {name: 'OK', type: 'is', value: 50, time: 15000},
                     {name: 'OK', type: 'is', value: 70, time: 17000},
                     {name: 'OK', type: 'is', value: 90, time: 19000}]
            lines.starttime = 10000
            lines.endtime = 20000
            buckets = {}
            result = aggregators.is lines, 'is:OK', buckets
            buckets['is:OK'].startvalue.should.equal 90
