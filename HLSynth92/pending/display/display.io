-- initially set enable to zero. this stops the circuit from counting
-- the clock ticks

.I enable <= 0
.clock

-- note that all the units output "0010000" which is a zero on a seven
-- segment display

.O ``unit3  = 0010000, unit2  = 0010000, unit1  = 0010000, unit0  = 0010000''
.clock
.O ``unit3  = 0010000, unit2  = 0010000, unit1  = 0010000, unit0  = 0010000''

-- set enable to "1". this allows counting to start

.I enable <= 1
.clock

-- after one clock, only unit0 changes to "0010001" which is the 
-- code for "1" on a seven segment display

.O ``unit3  = 0010000, unit2  = 0010000, unit1  = 0010000, unit0  = 0010001''
.clock 7

-- unit0 shows the code for "8" which is (1 + 7)

.O ``unit3  = 0010000, unit2  = 0010000, unit1  = 0010000, unit0  = 0011011''
.clock 3
.O ``unit3  = 0010000, unit2  = 0010000, unit1  = 1011011, unit0  = 0010000''
.clock 50
.O ``unit3  = 0010000, unit2  = 1011011, unit1  = 0010000, unit0  = 0010000''
.clock 60
.O ``unit3  = 0010000, unit2  = 0001100, unit1  = 0010000, unit0  = 0010000''
.clock 480
.O ``unit3  = 1011011, unit2  = 0010000, unit1  = 0010000, unit0  = 0010000''
.clock 600
.O ``unit3  = 0001100, unit2  = 0010000, unit1  = 0010000, unit0  = 0010000''
.clock 2400
.O ``unit3  = 0010000, unit2  = 0010000, unit1  = 0010000, unit0  = 0010000''
