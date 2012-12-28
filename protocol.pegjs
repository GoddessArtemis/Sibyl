msg
    = m:lines eol? { return m; }

lines
    = h:line eol t:lines { t.unshift(h); return t; }
    / l:line { return [ l ]; }

line
    = n:name ' is '   v:value &(eol/!.) { return { name: n, type: 'is',      value: v }; }
    / n:name ' took ' v:value &(eol/!.) { return { name: n, type: 'took',    value: v }; }
    / n:name ' hit'           &(eol/!.) { return { name: n, type: 'hit'               }; }
    / n:name ' happened'      &(eol/!.) { return { name: n, type: 'happened'          }; }
    / chars:[^\r\n]*                    { return; }

name
    = chars:[-A-Za-z0-9.]+ { return chars.join(''); }

value
    = digits:[0-9]+ '.' fraction:[0-9]+ { return +(digits.join('') + '.' + fraction.join('')); }
    / digits:[0-9]+                     { return +digits.join(''); }

eol
    = '\n\r' / '\r\n' / '\n' / '\r'
