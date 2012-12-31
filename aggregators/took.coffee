percentiles = [0, 1, 5, 10, 25, 50, 75, 90, 95, 99, 100]

module.exports = (lines) ->
    total = 0
    for line, i in lines
        total += line.value
        lines[i] = line.value
    lines.sort (a, b) -> a - b

    pcts = {}
    i = j = 0
    while i < lines.length
        value = lines[i]
        while lines[i] <= value
            i++ 
        while percentiles[j] * lines.length <= i * 100
            pcts[percentiles[j]] = value
            j++

    size = (pcts[100] - pcts[0]) / 16
    histogram = binsize: Math.pow(2, Math.floor(Math.log(size) / Math.LN2))
    for value in lines
        bin = Math.floor(value / histogram.binsize) * histogram.binsize
        histogram[bin] ?= 0
        histogram[bin] += 1

    starttime: lines.starttime
    endtime: lines.endtime
    count: lines.length
    mean: total / lines.length
    percentiles: pcts
    histogram: histogram
