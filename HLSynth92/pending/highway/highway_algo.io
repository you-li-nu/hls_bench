
-- set cars to "0"
-- set reset to "0"

.I cars <= 0 
.I reset <= 0

-- iterate till the outputs frl, fyl, fgl, hyrl, hyyl, hygl 
-- have the following values...

.O ``frl = 1, fyl = 0, fgl = 0, hyrl = 0, hyyl = 0, hygl = 1''

-- iterate till the outputs frl, fyl, fgl, hyrl, hyyl, hygl 
-- have the following values...

.O ``frl = 1, fyl = 0, fgl = 0, hyrl = 0, hyyl = 0, hygl = 1''

-- set cars to "1"

.I cars <= 1

-- iterate till the outputs frl, fyl, fgl, hyrl, hyyl, hygl 
-- have the following values...

.O ``frl = 1, fyl = 0, fgl = 0, hyrl = 0, hyyl = 1, hygl = 0''

-- iterate till the outputs frl, fyl, fgl, hyrl, hyyl, hygl 
-- have the following values...

.O ``frl = 0, fyl = 0, fgl = 1, hyrl = 1, hyyl = 0, hygl = 0''

-- iterate till the outputs frl, fyl, fgl, hyrl, hyyl, hygl 
-- have the following values...

.O ``frl = 0, fyl = 1, fgl = 0, hyrl = 1, hyyl = 0, hygl = 0''

-- iterate till the outputs frl, fyl, fgl, hyrl, hyyl, hygl 
-- have the following values...

.O ``frl = 0, fyl = 1, fgl = 0, hyrl = 1, hyyl = 0, hygl = 0''

-- iterate till the outputs frl, fyl, fgl, hyrl, hyyl, hygl 
-- have the following values...

.O ``frl = 1, fyl = 0, fgl = 0, hyrl = 0, hyyl = 0, hygl = 1''
