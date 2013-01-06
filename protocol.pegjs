msg
    = m:lines eol? { return m; }

lines
    = h:line eol t:lines { t.unshift(h); return t; }
    / l:line { return [ l ]; }

line
    = n:name ' is '        v:value &(eol/!.) { return { name: n, type: 'is',      value: v           }; }
    / n:name ' took ' !'-' v:value &(eol/!.) { return { name: n, type: 'took',    value: v, count: 1 }; }
    / n:name ' hit'                &(eol/!.) { return { name: n, type: 'hit',     value: 1           }; }
    / n:name ' happened'           &(eol/!.) { return { name: n, type: 'happened'                    }; }

    / n:statsdname ':'      v:value '|g'  r:statsdrate? &(eol/!.) { return { name: n, type: 'is',   value: v               }; }
    / n:statsdname ':' !'-' v:value '|ms' r:statsdrate? &(eol/!.) { return { name: n, type: 'took', value: v, count: 1 / r }; }
    / n:statsdname ':'      v:value '|c'  r:statsdrate? &(eol/!.) { return { name: n, type: 'hit',  value: v / r           }; }

    / chars:[^\r\n]* { return; }

name
    = chars:[-_A-Za-z0-9.]+ { return chars.join(''); }

statsdname
    = chars:[^:\r\n]+ { return chars.join('').replace(/\s+/g, '_').replace(/[\/]/g, '-').replace(/[^-_A-Za-z0-9.]/g, ''); }

statsdrate
    = '|@' !'-' v:value { return v; }
    / (!eol .)*         { return 1; }

value
    = neg:'-'? digits:[0-9]+ '.' fraction:[0-9]+ { return +(neg + digits.join('') + '.' + fraction.join('')); }
    / neg:'-'? digits:[0-9]+                     { return +(neg + digits.join('')); }

eol
    = '\n\r' / '\r\n' / '\n' / '\r'
