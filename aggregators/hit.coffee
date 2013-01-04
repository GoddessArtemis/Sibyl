module.exports = (lines) ->
    total = 0
    for line in lines
        total += line.value
    count: total
    starttime: lines.starttime
    endtime: lines.endtime
