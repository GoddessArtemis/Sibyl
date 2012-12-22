msg
    = m:lines eol? { return m; }

lines
    = h:line eol t:lines { t.unshift(h); return t; }
    / l:line { return [ l ]; }

line
    = chars:[^\r\n]* { return chars.join(''); }

eol
    = '\n\r' / '\r\n' / '\n' / '\r'
