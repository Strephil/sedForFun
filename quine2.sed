#!/bin/sed -f
s%^%;H;x;s,;,;s/$/,9;s,q,q/,3;G;s,^,#!/bin/sed -f,;%;s/$/s,;,s%^%;,;s,;,;%;,9;q/
;H;x;s,;,;s/$/,9;s,q,q/,3;G;s,^,#!/bin/sed -f,;s,;,s%^%;,;s,;,;%;,9;q

