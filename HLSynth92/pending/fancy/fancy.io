
-- initial inputs

.I start <= 1
.I ainp <= 00001101
.I binp <= 00000100
.I cinp <= 00100000

-- iterate till the outputs temp1a and eoc have the
-- following values...

.O ``temp1a = 01000000, eoc = 1''

-- a new set of inputs

.I start <= 0
.I ainp <= 00001101
.I binp <= 00000100
.I cinp <= 00100000

-- iterate till the outputs temp1a and eoc have the
-- following values...

.O ``temp1a = 00010001, eoc = 1''

-- a new set of inputs

.I start <= 0
.I ainp <= 00001101
.I binp <= 00100001
.I cinp <= 00100000

-- iterate till the outputs temp1a and eoc have the
-- following values...

.O ``temp1a = 01000001, eoc = 1''

-- a new set of inputs

.I start <= 0
.I ainp <= 00001101
.I binp <= 00100000
.I cinp <= 01000000

-- iterate till the outputs temp1a and eoc have the
-- following values...

.O ``temp1a = 01100000, eoc = 1''
