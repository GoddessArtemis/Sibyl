maphistogram = (collection, binsize, map = (i) -> i) ->
    histogram = []
    for item in collection
        item = map item
        bin = if binsize == 0 then item.bin else Math.floor(item.bin / binsize) * binsize
        if histogram.length == 0 or histogram[histogram.length - 1].bin != bin
            histogram.push bin: bin, count: item.count
        else
            histogram[histogram.length - 1].count += item.count
    histogram.binsize = binsize
    histogram

reducehistogram = (histogram) ->
    while histogram.length > 32
        newbinsize =
            if histogram.binsize == 0
                size = Math.min()
                for i in [1...histogram.length]
                    size = Math.min histogram[i].bin - histogram[i - 1].bin, size
                Math.pow 2, Math.floor(Math.log(size) / Math.LN2) + 1
            else
                histogram.binsize * 2

        histogram = maphistogram histogram, newbinsize
    histogram

module.exports = (lines) ->
    total = 0
    min = Math.min()
    max = Math.max()
    for line in lines
        total += line.value
        min = Math.min line.value, min
        max = Math.max line.value, max
    lines.sort (a, b) -> a.value - b.value

    histogram = maphistogram lines, 0, (line) -> bin: line.value, count: 1
    histogram = reducehistogram histogram

    histogramoutput = binsize: histogram.binsize
    for bin in histogram
        histogramoutput[bin.bin] = bin.count

    starttime: lines.starttime
    endtime: lines.endtime
    count: lines.length
    mean: total / lines.length
    min: min
    max: max
    histogram: histogramoutput
