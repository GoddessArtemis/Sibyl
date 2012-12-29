module.exports = (lines) ->
    for line, i in lines
        lines[i] = line.time - lines.starttime
    lines
