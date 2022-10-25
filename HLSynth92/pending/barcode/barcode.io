
-- some initialization done

.I scan   <=  1
.I video  <=  0
.I start  <=  1
.I num   <=   00000100

-- iterate till the outputs data, addr, memw and eoc have the 
-- following values...

.O ``data  = 00000011, addr  = 00000001, memw  = 1, eoc  = 0''

-- set video to 1

.I video <= 1

-- iterate till the outputs data, addr, memw and eoc have the 
-- following values...

.O ``data  = 00000111, addr  = 00000010, memw  = 1, eoc  = 0''

-- set video to 1

.I video <= 0

-- iterate till the outputs data, addr, memw and eoc have the 
-- following values...

.O ``data  = 00010001, addr  = 00000011, memw  = 1, eoc  = 0''

-- set video to 1

.I video <= 1

-- iterate till the outputs data, addr, memw and eoc have the 
-- following values...

.O ``data  = 11111111, addr  = 00000100, memw  = 1, eoc  = 0''

-- iterate till the outputs data, addr, memw and eoc have the 
-- following values...

.O ``data  = 11111111, addr  = 00000100, memw  = 0, eoc  = 1''

-- iterate till the outputs data, addr, memw and eoc have the 
-- following values...

.O ``data  = 11111111, addr  = 00000100, memw  = 0, eoc  = 1''

-- set start to 0 (begin a new cycle)

.I start <= 0

-- iterate till the outputs data, addr, memw and eoc have the 
-- following values...

.O ``data  = 00000000, addr  = 00000000, memw  = 0, eoc  = 0''
