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

    (histogram = []).binsize = 0
    for line in lines
        if histogram.length == 0 or histogram[histogram.length - 1].bin != line
            histogram.push bin: line, count: 1
        else
            histogram[histogram.length - 1].count += 1

    while histogram.length > 32
        (newhistogram = []).binsize =
            if histogram.binsize == 0
                size = Math.min()
                for i in [1...histogram.length]
                    size = Math.min histogram[i].bin - histogram[i - 1].bin, size
                Math.pow 2, Math.floor(Math.log(size) / Math.LN2) + 1
            else
                histogram.binsize * 2
        for item in histogram
            bin = Math.floor(item.bin / newhistogram.binsize) * newhistogram.binsize
            if newhistogram.length == 0 or newhistogram[newhistogram.length - 1].bin != bin
                newhistogram.push bin: bin, count: item.count
            else
                newhistogram[newhistogram.length - 1].count += item.count
        histogram = newhistogram

    histogramoutput = binsize: histogram.binsize
    for bin in histogram
        histogramoutput[bin.bin] = bin.count

    starttime: lines.starttime
    endtime: lines.endtime
    count: lines.length
    mean: total / lines.length
    percentiles: pcts
    histogram: histogramoutput
