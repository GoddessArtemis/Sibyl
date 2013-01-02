makehistogram = (binsize = 0) ->
    binsize: binsize
    length: 0

pushhistogram = (histogram, value, count) ->
    bin = if histogram.binsize is 0 then value else Math.floor(value / histogram.binsize) * histogram.binsize
    if not histogram[bin]?
        histogram.length += 1
        histogram[bin] = count
        if histogram.length > 32
            newbinsize =
                if histogram.binsize == 0
                    bins = (k for k, v of histogram when k not in ['binsize', 'length'])
                    bins.sort (a, b) -> a - b
                    size = Math.min()
                    for i in [1...bins.length]
                        size = Math.min bins[i] - bins[i - 1], size
                    Math.pow 2, Math.max Math.floor(Math.log(size) / Math.LN2) + 1, -19 # Smallest power of 2 that can be precisely represented by IEEE floating point.
                else
                    histogram.binsize * 2
            newhistogram = makehistogram newbinsize
            for newbin, newcount of histogram when newbin not in ['binsize', 'length']
                newhistogram = pushhistogram newhistogram, newbin, newcount
            newhistogram
        else
            histogram
    else
        histogram[bin] += count
        histogram

module.exports = (lines) ->
    total = 0
    min = Math.min()
    max = Math.max()
    histogram = makehistogram()
    for line in lines
        total += line.value
        min = Math.min line.value, min
        max = Math.max line.value, max
        histogram = pushhistogram histogram, line.value, 1

    delete histogram.length

    starttime: lines.starttime
    endtime: lines.endtime
    count: lines.length
    mean: total / lines.length
    min: min
    max: max
    histogram: histogram
