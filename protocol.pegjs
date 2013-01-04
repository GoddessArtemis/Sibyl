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

    / n:name ':'      v:value '|g'  &(eol/!.) { return { name: n, type: 'is',      value: v           }; }
    / n:name ':' !'-' v:value '|ms' &(eol/!.) { return { name: n, type: 'took',    value: v, count: 1 }; }
    / n:name ':'      v:value '|c'  &(eol/!.) { return { name: n, type: 'hit'      value: v           }; }

    / chars:[^\r\n]* { return; }

name
    = chars:[-A-Za-z0-9.]+ { return chars.join(''); }

value
    = neg:'-'? digits:[0-9]+ '.' fraction:[0-9]+ { return +(neg + digits.join('') + '.' + fraction.join('')); }
    / neg:'-'? digits:[0-9]+                     { return +(neg + digits.join('')); }

eol
    = '\n\r' / '\r\n' / '\n' / '\r'
