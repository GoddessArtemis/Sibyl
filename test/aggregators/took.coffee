should = (require 'chai').should()
took = require '../../aggregators/took'

describe 'took', ->
    describe '#aggregate()', ->
        it 'should give the correct start time for the lines', ->
            lines = [{name: 'OK', type: 'took', value: 50, time: 15000}]
            lines.starttime = 10000
            lines.endtime = 20000
            result = took lines
            result.starttime.should.equal 10000

        it 'should give the correct end time for the lines', ->
            lines = [{name: 'OK', type: 'took', value: 50, time: 15000}]
            lines.starttime = 10000
            lines.endtime = 20000
            result = took lines
            result.endtime.should.equal 20000

        it 'should give the correct count', ->
            lines = [{name: 'OK', type: 'took', value: 10, time: 11000},
                     {name: 'OK', type: 'took', value: 30, time: 13000},
                     {name: 'OK', type: 'took', value: 50, time: 15000},
                     {name: 'OK', type: 'took', value: 70, time: 17000},
                     {name: 'OK', type: 'took', value: 90, time: 19000}]
            lines.starttime = 10000
            lines.endtime = 20000
            result = took lines
            result.count.should.equal 5

        it 'should give the correct count when there are duplicate values', ->
            lines = [{name: 'OK', type: 'took', value: 30, time: 11000},
                     {name: 'OK', type: 'took', value: 30, time: 13000},
                     {name: 'OK', type: 'took', value: 50, time: 15000},
                     {name: 'OK', type: 'took', value: 70, time: 17000},
                     {name: 'OK', type: 'took', value: 70, time: 19000}]
            lines.starttime = 10000
            lines.endtime = 20000
            result = took lines
            result.count.should.equal 5

        it 'should give the correct minimum value', ->
            lines = [{name: 'OK', type: 'took', value: 10, time: 11000},
                     {name: 'OK', type: 'took', value: 30, time: 13000},
                     {name: 'OK', type: 'took', value: 50, time: 15000},
                     {name: 'OK', type: 'took', value: 70, time: 17000},
                     {name: 'OK', type: 'took', value: 90, time: 19000}]
            lines.starttime = 10000
            lines.endtime = 20000
            result = took lines
            result.min.should.equal 10

        it 'should give the correct maximum value', ->
            lines = [{name: 'OK', type: 'took', value: 10, time: 11000},
                     {name: 'OK', type: 'took', value: 30, time: 13000},
                     {name: 'OK', type: 'took', value: 50, time: 15000},
                     {name: 'OK', type: 'took', value: 70, time: 17000},
                     {name: 'OK', type: 'took', value: 90, time: 19000}]
            lines.starttime = 10000
            lines.endtime = 20000
            result = took lines
            result.max.should.equal 90

        it 'should give the correct mean', ->
            lines = [{name: 'OK', type: 'took', value: 10, time: 11000},
                     {name: 'OK', type: 'took', value: 30, time: 13000},
                     {name: 'OK', type: 'took', value: 50, time: 15000},
                     {name: 'OK', type: 'took', value: 80, time: 17000},
                     {name: 'OK', type: 'took', value: 100, time: 19000}]
            lines.starttime = 10000
            lines.endtime = 20000
            result = took lines
            result.mean.should.equal 54

        it 'should give the correct result with 1 item', ->
            lines = [{name: 'OK', type: 'took', value: 50, time: 15000}]
            lines.starttime = 10000
            lines.endtime = 20000
            result = took lines
            result.should.deep.equal
                starttime: 10000
                endtime: 20000
                count: 1
                mean: 50
                min: 50
                max: 50
                histogram:
                    '50': 1
                    binsize: 0

        it 'should give the correct result with 32 unique items but more than 32 total', ->
            lines = ({name: 'OK', type: 'took', value: Math.floor(i / 2), time: 15000} for i in [0..63])
            lines.starttime = 10000
            lines.endtime = 20000
            result = took lines
            result.should.deep.equal
                starttime: 10000
                endtime: 20000
                count: 64
                mean: 15.5
                min: 0
                max: 31
                histogram:
                    '0': 2
                    '1': 2
                    '2': 2
                    '3': 2
                    '4': 2
                    '5': 2
                    '6': 2
                    '7': 2
                    '8': 2
                    '9': 2
                    '10': 2
                    '11': 2
                    '12': 2
                    '13': 2
                    '14': 2
                    '15': 2
                    '16': 2
                    '17': 2
                    '18': 2
                    '19': 2
                    '20': 2
                    '21': 2
                    '22': 2
                    '23': 2
                    '24': 2
                    '25': 2
                    '26': 2
                    '27': 2
                    '28': 2
                    '29': 2
                    '30': 2
                    '31': 2
                    binsize: 0

        it 'should give the correct result with 33 unique items where 32 bins is correct', ->
            lines = ({name: 'OK', type: 'took', value: i, time: 15000} for i in [1..32])
            lines.push {name: 'OK', type: 'took', value: 1.5, time: 15000}
            lines.starttime = 10000
            lines.endtime = 20000
            result = took lines
            result.should.deep.equal
                starttime: 10000
                endtime: 20000
                count: 33
                mean: 16.045454545454547
                min: 1
                max: 32
                histogram:
                    '1': 2
                    '2': 1
                    '3': 1
                    '4': 1
                    '5': 1
                    '6': 1
                    '7': 1
                    '8': 1
                    '9': 1
                    '10': 1
                    '11': 1
                    '12': 1
                    '13': 1
                    '14': 1
                    '15': 1
                    '16': 1
                    '17': 1
                    '18': 1
                    '19': 1
                    '20': 1
                    '21': 1
                    '22': 1
                    '23': 1
                    '24': 1
                    '25': 1
                    '26': 1
                    '27': 1
                    '28': 1
                    '29': 1
                    '30': 1
                    '31': 1
                    '32': 1
                    binsize: 1

        it 'should give the correct result with 33 unique items where 32 bins is correct', ->
            lines = ({name: 'OK', type: 'took', value: i, time: 15000} for i in [1..32])
            lines.push {name: 'OK', type: 'took', value: 1000000, time: 15000}
            lines.starttime = 10000
            lines.endtime = 20000
            result = took lines
            result.should.deep.equal
                starttime: 10000
                endtime: 20000
                count: 33
                mean: 30319.030303030304
                min: 1
                max: 1000000
                histogram:
                    '0': 1
                    '2': 2
                    '4': 2
                    '6': 2
                    '8': 2
                    '10': 2
                    '12': 2
                    '14': 2
                    '16': 2
                    '18': 2
                    '20': 2
                    '22': 2
                    '24': 2
                    '26': 2
                    '28': 2
                    '30': 2
                    '32': 1
                    '1000000': 1
                    binsize: 2

        it 'should give the correct result with more than 32 unique items where 16 bins is correct', ->
            lines = ({name: 'OK', type: 'took', value: i, time: 15000} for i in [0..64])
            lines.starttime = 10000
            lines.endtime = 20000
            result = took lines
            result.should.deep.equal
                starttime: 10000
                endtime: 20000
                count: 65
                mean: 32
                min: 0
                max: 64
                histogram:
                    '0': 4
                    '4': 4
                    '8': 4
                    '12': 4
                    '16': 4
                    '20': 4
                    '24': 4
                    '28': 4
                    '32': 4
                    '36': 4
                    '40': 4
                    '44': 4
                    '48': 4
                    '52': 4
                    '56': 4
                    '60': 4
                    '64': 1
                    binsize: 4

        it 'should give the correct result with many items spaced with gaps', ->
            lines = []
            for n in [1..100000]
                for i in [0..31]
                    lines.push {name: 'OK', type: 'took', value: i + ((n - 1) / (100000 - 1) / 64), time: 15000}
            lines.starttime = 10000
            lines.endtime = 20000
            lines.log = true
            result = took lines
            result.should.deep.equal
                starttime: 10000
                endtime: 20000
                count: 3200000
                mean: 15.507812499999998
                min: 0
                max: 31.015625
                histogram:
                    '0': 100000
                    '1': 100000
                    '2': 100000
                    '3': 100000
                    '4': 100000
                    '5': 100000
                    '6': 100000
                    '7': 100000
                    '8': 100000
                    '9': 100000
                    '10': 100000
                    '11': 100000
                    '12': 100000
                    '13': 100000
                    '14': 100000
                    '15': 100000
                    '16': 100000
                    '17': 100000
                    '18': 100000
                    '19': 100000
                    '20': 100000
                    '21': 100000
                    '22': 100000
                    '23': 100000
                    '24': 100000
                    '25': 100000
                    '26': 100000
                    '27': 100000
                    '28': 100000
                    '29': 100000
                    '30': 100000
                    '31': 100000
                    binsize: 0.03125

        it 'should give the correct result with many items evenly spaced', ->
            lines = []
            for n in [0...100000]
                for i in [0..31]
                    lines.push {name: 'OK', type: 'took', value: i + n / 100000, time: 15000}
            lines.starttime = 10000
            lines.endtime = 20000
            lines.log = true
            result = took lines
            result.should.deep.equal
                starttime: 10000
                endtime: 20000
                count: 3200000
                mean: 15.999994999999931
                min: 0
                max: 31.99999
                histogram:
                    '0': 100000
                    '1': 100000
                    '2': 100000
                    '3': 100000
                    '4': 100000
                    '5': 100000
                    '6': 100000
                    '7': 100000
                    '8': 100000
                    '9': 100000
                    '10': 100000
                    '11': 100000
                    '12': 100000
                    '13': 100000
                    '14': 100000
                    '15': 100000
                    '16': 100000
                    '17': 100000
                    '18': 100000
                    '19': 100000
                    '20': 100000
                    '21': 100000
                    '22': 100000
                    '23': 100000
                    '24': 100000
                    '25': 100000
                    '26': 100000
                    '27': 100000
                    '28': 100000
                    '29': 100000
                    '30': 100000
                    '31': 100000
                    binsize: 1
