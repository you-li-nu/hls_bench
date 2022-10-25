-- set rst permanently to zero.

.I rst  =  0

-- xinput = 67
-- yinput = 3

.I xinput   <=  01000011 
.I yinput   <=  00000011 

-- when rdy is "1", the gcd of xinput and yinput is output. In this
-- case, oup = gcd(67,3) = "1"

.O ``oup  =  00000001, rdy  =  1''

-- xinput = 21
-- yinput = 14

.I xinput   <=  00010101 
.I yinput   <=  00001110 

-- gcd(21,14) = 7

.O ``oup  =  00000111, rdy  =  1''

-- xinput = 36
-- yinput = 8

.I xinput   <=  00100100 
.I yinput   <=  00001000 

-- gcd(36,8) = 4

.O ``oup  =  00000100, rdy  =  1''
