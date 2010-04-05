#!/bin/sed -f
sQ^Q#!/bin/gawk -fQ;x;sQ^QBEGIN{c="#!/bin/sed -f%cs%c^%c#!/bin/gawk -f%c;x;s%c^%cBEGIN{c=%c%s%c;printf c,10,81,81,81,81,81,34,c,34,81,10}%c;H;g;%c";printf c,10,81,81,81,81,81,34,c,34,81,10}Q;H;g;
