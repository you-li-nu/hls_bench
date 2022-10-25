
-- input stackinp, offset1, offset2 and datainp

.I stackinp <= 00000100
.I offset1  <= 00001000
.I offset2  <= 00000010
.I datainp  <= 00000011

-- output

.O ``maddr = 00001100''

-- input datainp (the others are unchanged)

.I datainp  <= 00000000

-- output

.O ``maddr = 00001010''

-- input datainp (the others are unchanged)

.I datainp  <= 00000001

-- output

.O ``maddr = 00000101''

-- input datainp (the others are unchanged)

.I datainp  <= 00000010

-- output

.O ``maddr = 00000010''
