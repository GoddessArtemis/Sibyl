module.exports = (lines) ->
    lastindex = lines.length - 1

    total = 0
    min = Math.min()
    max = Math.max()
    for line, i in lines
        nexttime = if i is lastindex then lines.endtime else lines[i + 1].time
        total += line.value * (nexttime - line.time)
        min = Math.min line.value, min
        max = Math.max line.value, max

    starttime: lines.starttime
    endtime: lines.endtime
    firsttime: lines[0].time
    firstvalue: lines[0].value
    lastvalue: lines[lastindex].value
    count: lines.length
    total: total
    min: min
    max: max
