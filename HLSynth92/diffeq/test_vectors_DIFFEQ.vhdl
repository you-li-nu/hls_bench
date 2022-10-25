--------------------------------------------------------------------------
--
--  BENCHMARK       : Differential Equation Solver
--
--  Model Source    : P. G. Paulin, J. P. Knight, E. F. Girczyc:
--                    "HAL: A multi-paradigm approach to automatic data path synthesis"
--                    in Proc. 23rd IEEE Design Automation Conf, Las Vegas, NV, pp. 263-270,
--                    July 1986.
--
--  Testpattern Source : Rajesh Gupta, Stanford University , July 10 1990
--
--  Developed on Aug 17 1992 by : Champaka Ramachandran
--                                Univ. of Calif. , Irvine.
--                                champaka@balboa.eng.uci.edu
--
--------------------------------------------------------------------------

Entity E is
end;

architecture A of E is
       Component diffeq
       port (
                       Xinport   : in   integer;
                       Xoutport  : out  integer;
                       Yinport   : in   integer;
                       Youtport  : out  integer;
                       Uinport   : in   integer;
                       Uoutport  : out  integer;
                       DXport    : in   integer;
                       Aport     : in   integer
       );
       end component ;

                       signal Xinport  : integer;
                       signal Xoutport : integer;
                       signal Yinport  : integer;
                       signal Youtport : integer;
                       signal Uinport  : integer;
                       signal Uoutport : integer;
                       signal DXport   : integer;
                       signal Aport    : integer;

for all : diffeq use entity work.diffeq(diffeq) ;

begin

INST1 : diffeq port map (
                       Xinport,
                       Xoutport,
                       Yinport,
                       Youtport,
                       Uinport,
                       Uoutport,
                       DXport,
                       Aport
                    );

process

begin

-- ****************************************** 
-- *                                        * 
-- *           TEST VECTORS                 * 
-- *                                        * 
-- ****************************************** 
--
-- Pattern #0
Xinport <= 0;
Yinport <= 0;
Uinport <= 0;
DXport <= 0;
Aport <= 0;
wait for 50 ns;

assert (Xoutport = 0)
report
"Assert 0 : < Xoutport /= 0 >"
severity warning;

assert (Youtport = 0)
report
"Assert 0 : < Youtport /= 0 >"
severity warning;

assert (Uoutport = 0)
report
"Assert 0 : < Uoutport /= 0 >"
severity warning;

-- Pattern #1

Xinport <= 2;
Yinport <= 2;
Uinport <= 1;
DXport <= 1;
Aport <= 5;
wait for 50 ns;

assert (Xoutport = 5)
report
"Assert 1 : < Xoutport /= 5 >"
severity warning;

assert (Youtport = -1477)
report
"Assert 1 : < Youtport /= -1477 >"
severity warning;

assert (Uoutport = -1583)
report
"Assert 1 : < Uoutport /= -1583 >"
severity warning;
--

-- Pattern #2
Xinport <= 2;
Yinport <= 12;
Uinport <= 2;
DXport <= 1;
Aport <= 5;
wait for 50 ns;

assert (Xoutport = 5)
report
"Assert 2 : < Xoutport /= 5 >"
severity warning;

assert (Youtport = -6042)
report
"Assert 2 : < Youtport /= -6042 >"
severity warning;

assert (Uoutport = -6478)
report
"Assert 2 : < Uoutport /= -6478 >"
severity warning;
--

-- Pattern # 3

Xinport <= 0;
Yinport <= 0;
Uinport <= 1;
DXport <= 1;
Aport <= 4;


wait for 50 ns;


assert (Xoutport = 4)
report
"Assert 3 : < Xoutport /= 4 >"
severity warning;

assert (Youtport = -362)
report
"Assert 3 : < Youtport /= -362 >"
severity warning;

assert (Uoutport = -395)
report
"Assert 3 : < Uoutport /= -395 >"
severity warning;
--


-- Pattern # 4

Xinport <= 0;
Yinport <= 0;
Uinport <= 1;
DXport <= 2;
Aport <= 4;

wait for 50 ns;


assert (Xoutport = 4)
report
"Assert 4 : < Xoutport /= 4 >"
severity warning;

assert (Youtport = -44)
report
"Assert 4 : < Youtport /= -44 >"
severity warning;

assert (Uoutport = -23)
report
"Assert 4 : < Uoutport /= -23 >"
severity warning;
--




-- Pattern # 5

Xinport <= 0;
Yinport <= 0;
Uinport <= 1;
DXport <= 2;
Aport <= 8;

wait for 50 ns;


assert (Xoutport = 8)
report
"Assert 5 : < Xoutport /= 8 >"
severity warning;

assert (Youtport = -72472)
report
"Assert 5 : < Youtport /= -72472 >"
severity warning;

assert (Uoutport = -37007)
report
"Assert 5 : < Uoutport /= -37007 >"
severity warning;
--





-- Pattern # 6

Xinport <= 20;
Yinport <= 0;
Uinport <= 1;
DXport <= -2;
Aport <= 8;

wait for 50 ns;


assert (Xoutport = 20)
report
"Assert 6 : < Xoutport /= 20 >"
severity warning;

assert (Youtport = 0)
report
"Assert 6 : < Youtport /= 0 >"
severity warning;

assert (Uoutport = 1)
report
"Assert 6 : < Uoutport /= 1 >"
severity warning;
--





-- Pattern # 7

Xinport <= 1;
Yinport <= 32;
Uinport <= 10;
DXport <= 1;
Aport <= 4;

wait for 50 ns;


assert (Xoutport = 4)
report
"Assert 7 : < Xoutport /= 4 >"
severity warning;

assert (Youtport = -8152)
report
"Assert 7 : < Youtport /= -8152 >"
severity warning;

assert (Uoutport = -8900)
report
"Assert 7 : < Uoutport /= -8900 >"
severity warning;
--





-- Pattern # 8

Xinport <= 1;
Yinport <= 1;
Uinport <= 0;
DXport <= 1;
Aport <= 4;

wait for 50 ns;


assert (Xoutport = 4)
report
"Assert 8 : < Xoutport /= 4 >"
severity warning;

assert (Youtport = -206)
report
"Assert 8 : < Youtport /= -206 >"
severity warning;

assert (Uoutport = -225)
report
"Assert 8 : < Uoutport /= -225 >"
severity warning;
--





-- Pattern # 9

Xinport <= 0;
Yinport <= 1;
Uinport <= 0;
DXport <= 1;
Aport <= 4;

wait for 50 ns;


assert (Xoutport = 4)
report
"Assert 9 : < Xoutport /= 4 >"
severity warning;

assert (Youtport = 880)
report
"Assert 9 : < Youtport /= 880 >"
severity warning;

assert (Uoutport = 960)
report
"Assert 9 : < Uoutport /= 960 >"
severity warning;
--





-- Pattern # 10

Xinport <= 0;
Yinport <= 1;
Uinport <= -2;
DXport <= 1;
Aport <= 4;

wait for 50 ns;


assert (Xoutport = 4)
report
"Assert 10 : < Xoutport /= 4 >"
severity warning;

assert (Youtport = 1604)
report
"Assert 10 : < Youtport /= 1604 >"
severity warning;

assert (Uoutport = 1750)
report
"Assert 10 : < Uoutport /= 1750 >"
severity warning;
--





-- Pattern # 11

Xinport <= 0;
Yinport <= 0;
Uinport <= -2;
DXport <= 1;
Aport <= 4;

wait for 50 ns;


assert (Xoutport = 4)
report
"Assert 11 : < Xoutport /= 4 >"
severity warning;

assert (Youtport = 724)
report
"Assert 11 : < Youtport /= 724 >"
severity warning;

assert (Uoutport = 790)
report
"Assert 11 : < Uoutport /= 790 >"
severity warning;
--


-- Pattern # 12

Xinport <= -4;
Yinport <= -1;
Uinport <= -2;
DXport <= 1;
Aport <= 0;

wait for 50 ns;


assert (Xoutport = 0)
report
"Assert 12 : < Xoutport /= 0 >"
severity warning;

assert (Youtport = -756)
report
"Assert 12 : < Youtport /= -756 >"
severity warning;

assert (Uoutport = -14)
report
"Assert 12 : < Uoutport /= -14 >"
severity warning;
--


-- Pattern # 13

Xinport <= 1;
Yinport <= 0;
Uinport <= -2;
DXport <= 1;
Aport <= 0;

wait for 50 ns;


assert (Xoutport = 1)
report
"Assert 13 : < Xoutport /= 1 >"
severity warning;

assert (Youtport = 0)
report
"Assert 13 : < Youtport /= 0 >"
severity warning;

assert (Uoutport = -2)
report
"Assert 13 : < Uoutport /= -2 >"
severity warning;
--



-- Pattern # 14

Xinport <= 2;
Yinport <= 0;
Uinport <= -2;
DXport <= 1;
Aport <= 0;

wait for 50 ns;


assert (Xoutport = 2)
report
"Assert 14 : < Xoutport /= 2 >"
severity warning;

assert (Youtport = 0)
report
"Assert 14 : < Youtport /= 0 >"
severity warning;

assert (Uoutport = -2)
report
"Assert 14 : < Uoutport /= -2 >"
severity warning;
--


-- Pattern # 15

Xinport <= 3;
Yinport <= 0;
Uinport <= -2;
DXport <= 1;
Aport <= 0;

wait for 50 ns;


assert (Xoutport = 3)
report
"Assert 15 : < Xoutport /= 3 >"
severity warning;

assert (Youtport = 0)
report
"Assert 15 : < Youtport /= 0 >"
severity warning;

assert (Uoutport = -2)
report
"Assert 15 : < Uoutport /= -2 >"
severity warning;
--



-- Pattern # 16

Xinport <= 1;
Yinport <= 1;
Uinport <= -2;
DXport <= 1;
Aport <= 0;

wait for 50 ns;


assert (Xoutport = 1)
report
"Assert 16 : < Xoutport /= 1 >"
severity warning;

assert (Youtport = 1)
report
"Assert 16 : < Youtport /= 1 >"
severity warning;

assert (Uoutport = -2)
report
"Assert 16 : < Uoutport /= -2 >"
severity warning;
--



-- Pattern # 17

Xinport <= 2;
Yinport <= 1;
Uinport <= -2;
DXport <= 1;
Aport <= 0;

wait for 50 ns;


assert (Xoutport = 2)
report
"Assert 17 : < Xoutport /= 2 >"
severity warning;

assert (Youtport = 1)
report
"Assert 17 : < Youtport /= 1 >"
severity warning;

assert (Uoutport = -2)
report
"Assert 17 : < Uoutport /= -2 >"
severity warning;
--


-- Pattern # 18

Xinport <= 3;
Yinport <= 1;
Uinport <= -2;
DXport <= 1;
Aport <= 0;

wait for 50 ns;


assert (Xoutport = 3)
report
"Assert 18 : < Xoutport /= 3 >"
severity warning;

assert (Youtport = 1)
report
"Assert 18 : < Youtport /= 1 >"
severity warning;

assert (Uoutport = -2)
report
"Assert 18 : < Uoutport /= -2 >"
severity warning;
--


-- Pattern # 19

Xinport <= 1;
Yinport <= 2;
Uinport <= -2;
DXport <= 1;
Aport <= 0;

wait for 50 ns;


assert (Xoutport = 1)
report
"Assert 19 : < Xoutport /= 1 >"
severity warning;

assert (Youtport = 2)
report
"Assert 19 : < Youtport /= 2 >"
severity warning;

assert (Uoutport = -2)
report
"Assert 19 : < Uoutport /= -2 >"
severity warning;
--



-- Pattern # 20

Xinport <= 2;
Yinport <= 2;
Uinport <= -2;
DXport <= 1;
Aport <= 0;

wait for 50 ns;


assert (Xoutport = 2)
report
"Assert 20 : < Xoutport /= 2 >"
severity warning;

assert (Youtport = 2)
report
"Assert 20 : < Youtport /= 2 >"
severity warning;

assert (Uoutport = -2)
report
"Assert 20 : < Uoutport /= -2 >"
severity warning;
--


-- Pattern # 21

Xinport <= 3;
Yinport <= 2;
Uinport <= -2;
DXport <= 1;
Aport <= 0;

wait for 50 ns;


assert (Xoutport = 3)
report
"Assert 21 : < Xoutport /= 3 >"
severity warning;

assert (Youtport = 2)
report
"Assert 21 : < Youtport /= 2 >"
severity warning;

assert (Uoutport = -2)
report
"Assert 21 : < Uoutport /= -2 >"
severity warning;
--


-- Pattern # 22

Xinport <= 1;
Yinport <= 0;
Uinport <= -2;
DXport <= 1;
Aport <= 2;

wait for 50 ns;


assert (Xoutport = 2)
report
"Assert 22 : < Xoutport /= 2 >"
severity warning;

assert (Youtport = 4)
report
"Assert 22 : < Youtport /= 4 >"
severity warning;

assert (Uoutport = 4)
report
"Assert 22 : < Uoutport /= 4 >"
severity warning;
--



-- Pattern # 23

Xinport <= 2;
Yinport <= 0;
Uinport <= -2;
DXport <= 1;
Aport <= 2;

wait for 50 ns;


assert (Xoutport = 2)
report
"Assert 23 : < Xoutport /= 2 >"
severity warning;

assert (Youtport = 0)
report
"Assert 23 : < Youtport /= 0 >"
severity warning;

assert (Uoutport = -2)
report
"Assert 23 : < Uoutport /= -2 >"
severity warning;
--


-- Pattern # 24

Xinport <= 3;
Yinport <= 0;
Uinport <= -2;
DXport <= 1;
Aport <= 2;

wait for 50 ns;


assert (Xoutport = 3)
report
"Assert 24 : < Xoutport /= 3 >"
severity warning;

assert (Youtport = 0)
report
"Assert 24 : < Youtport /= 0 >"
severity warning;

assert (Uoutport = -2)
report
"Assert 24 : < Uoutport /= -2 >"
severity warning;
--



-- Pattern # 25

Xinport <= 1;
Yinport <= 1;
Uinport <= -2;
DXport <= 1;
Aport <= 2;

wait for 50 ns;


assert (Xoutport = 2)
report
"Assert 25 : < Xoutport /= 2 >"
severity warning;

assert (Youtport = 2)
report
"Assert 25 : < Youtport /= 2 >"
severity warning;

assert (Uoutport = 1)
report
"Assert 25 : < Uoutport /= 1 >"
severity warning;
--



-- Pattern # 26

Xinport <= 2;
Yinport <= 1;
Uinport <= -2;
DXport <= 1;
Aport <= 2;

wait for 50 ns;


assert (Xoutport = 2)
report
"Assert 26 : < Xoutport /= 2 >"
severity warning;

assert (Youtport = 1)
report
"Assert 26 : < Youtport /= 1 >"
severity warning;

assert (Uoutport = -2)
report
"Assert 26 : < Uoutport /= -2 >"
severity warning;
--


-- Pattern # 27

Xinport <= 3;
Yinport <= 1;
Uinport <= -2;
DXport <= 1;
Aport <= 2;

wait for 50 ns;


assert (Xoutport = 3)
report
"Assert 27 : < Xoutport /= 3 >"
severity warning;

assert (Youtport = 1)
report
"Assert 27 : < Youtport /= 1 >"
severity warning;

assert (Uoutport = -2)
report
"Assert 27 : < Uoutport /= -2 >"
severity warning;
--


-- Pattern # 28

Xinport <= 1;
Yinport <= 2;
Uinport <= -2;
DXport <= 1;
Aport <= 2;

wait for 50 ns;


assert (Xoutport = 2)
report
"Assert 28 : < Xoutport /= 2 >"
severity warning;

assert (Youtport = 0)
report
"Assert 28 : < Youtport /= 0>"
severity warning;

assert (Uoutport = -2)
report
"Assert 28 : < Uoutport /= -2 >"
severity warning;
--



-- Pattern # 29

Xinport <= 2;
Yinport <= 2;
Uinport <= -2;
DXport <= 1;
Aport <= 2;

wait for 50 ns;


assert (Xoutport = 2)
report
"Assert 29 : < Xoutport /= 2 >"
severity warning;

assert (Youtport = 2)
report
"Assert 29 : < Youtport /= 2 >"
severity warning;

assert (Uoutport = -2)
report
"Assert 29 : < Uoutport /= -2 >"
severity warning;
--


-- Pattern # 30

Xinport <= 3;
Yinport <= 2;
Uinport <= -2;
DXport <= 1;
Aport <= 2;

wait for 50 ns;


assert (Xoutport = 3)
report
"Assert 30 : < Xoutport /= 3 >"
severity warning;

assert (Youtport = 2)
report
"Assert 30 : < Youtport /= 2 >"
severity warning;

assert (Uoutport = -2)
report
"Assert 30 : < Uoutport /= -2 >"
severity warning;
--

-- Pattern # 31

Xinport <= 1;
Yinport <= 0;
Uinport <= -2;
DXport <= 1;
Aport <= 3;

wait for 50 ns;


assert (Xoutport = 3)
report
"Assert 31 : < Xoutport /= 3 >"
severity warning;

assert (Youtport = -28)
report
"Assert 31 : < Youtport /= -28 >"
severity warning;

assert (Uoutport = -32)
report
"Assert 31 : < Uoutport /= -32 >"
severity warning;
--



-- Pattern # 32

Xinport <= 2;
Yinport <= 0;
Uinport <= -2;
DXport <= 1;
Aport <= 3;

wait for 50 ns;


assert (Xoutport = 3)
report
"Assert 32 : < Xoutport /= 3 >"
severity warning;

assert (Youtport = 10)
report
"Assert 32 : < Youtport /= 10 >"
severity warning;

assert (Uoutport = 10)
report
"Assert 32 : < Uoutport /= 10 >"
severity warning;
--


-- Pattern # 33

Xinport <= 3;
Yinport <= 0;
Uinport <= -2;
DXport <= 1;
Aport <= 3;

wait for 50 ns;


assert (Xoutport = 3)
report
"Assert 33 : < Xoutport /= 3 >"
severity warning;

assert (Youtport = 0)
report
"Assert 33 : < Youtport /= 0 >"
severity warning;

assert (Uoutport = -2)
report
"Assert 33 : < Uoutport /= -2 >"
severity warning;
--



-- Pattern # 34

Xinport <= 1;
Yinport <= 1;
Uinport <= -2;
DXport <= 1;
Aport <= 3;

wait for 50 ns;


assert (Xoutport = 3)
report
"Assert 34 : < Xoutport /= 3 >"
severity warning;

assert (Youtport = -9)
report
"Assert 34 : < Youtport /= -9 >"
severity warning;

assert (Uoutport = -11)
report
"Assert 34 : < Uoutport /= -11 >"
severity warning;
--



-- Pattern # 35

Xinport <= 2;
Yinport <= 1;
Uinport <= -2;
DXport <= 1;
Aport <= 3;

wait for 50 ns;


assert (Xoutport = 3)
report
"Assert 35 : < Xoutport /= 3 >"
severity warning;

assert (Youtport = 8)
report
"Assert 35 : < Youtport /= 8 >"
severity warning;

assert (Uoutport = 7)
report
"Assert 35 : < Uoutport /= 7 >"
severity warning;
--


-- Pattern # 36

Xinport <= 3;
Yinport <= 1;
Uinport <= -2;
DXport <= 1;
Aport <= 3;

wait for 50 ns;


assert (Xoutport = 3)
report
"Assert 36 : < Xoutport /= 3 >"
severity warning;

assert (Youtport = 1)
report
"Assert 36 : < Youtport /= 1 >"
severity warning;

assert (Uoutport = -2)
report
"Assert 36 : < Uoutport /= -2 >"
severity warning;
--


-- Pattern # 37

Xinport <= 1;
Yinport <= 2;
Uinport <= -2;
DXport <= 1;
Aport <= 3;

wait for 50 ns;


assert (Xoutport = 3)
report
"Assert 37 : < Xoutport /= 3 >"
severity warning;

assert (Youtport = 10)
report
"Assert 37 : < Youtport /= 10 >"
severity warning;

assert (Uoutport = 10)
report
"Assert 37 : < Uoutport /= 10 >"
severity warning;
--



-- Pattern # 38

Xinport <= 2;
Yinport <= 2;
Uinport <= -2;
DXport <= 1;
Aport <= 3;

wait for 50 ns;


assert (Xoutport = 3)
report
"Assert 38 : < Xoutport /= 3 >"
severity warning;

assert (Youtport = 6)
report
"Assert 38 : < Youtport /= 6 >"
severity warning;

assert (Uoutport = 4)
report
"Assert 38 : < Uoutport /= 4 >"
severity warning;
--


-- Pattern # 39

Xinport <= 3;
Yinport <= 2;
Uinport <= -2;
DXport <= 1;
Aport <= 3;

wait for 50 ns;


assert (Xoutport = 3)
report
"Assert 39 : < Xoutport /= 3 >"
severity warning;

assert (Youtport = 2)
report
"Assert 39 : < Youtport /= 2 >"
severity warning;

assert (Uoutport = -2)
report
"Assert 39 : < Uoutport /= -2 >"
severity warning;
--

-- Pattern # 40

Xinport <= 1;
Yinport <= 0;
Uinport <= -1;
DXport <= 1;
Aport <= 3;

wait for 50 ns;


assert (Xoutport = 3)
report
"Assert 40 : < Xoutport /= 3 >"
severity warning;

assert (Youtport = -14)
report
"Assert 40 : < Youtport /= -14 >"
severity warning;

assert (Uoutport = -16)
report
"Assert 40 : < Uoutport /= -16 >"
severity warning;
--



-- Pattern # 41

Xinport <= 2;
Yinport <= 0;
Uinport <= -1;
DXport <= 1;
Aport <= 3;

wait for 50 ns;


assert (Xoutport = 3)
report
"Assert 41 : < Xoutport /= 3 >"
severity warning;

assert (Youtport = 5)
report
"Assert 41 : < Youtport /= 5 >"
severity warning;

assert (Uoutport = 5)
report
"Assert 41 : < Uoutport /= 5 >"
severity warning;
--


-- Pattern # 42

Xinport <= 3;
Yinport <= 0;
Uinport <= -1;
DXport <= 1;
Aport <= 3;

wait for 50 ns;


assert (Xoutport = 3)
report
"Assert 42 : < Xoutport /= 3 >"
severity warning;

assert (Youtport = 0)
report
"Assert 42 : < Youtport /= 0 >"
severity warning;

assert (Uoutport = -1)
report
"Assert 42 : < Uoutport /= -1 >"
severity warning;
--



-- Pattern # 43

Xinport <= 1;
Yinport <= 1;
Uinport <= -1;
DXport <= 1;
Aport <= 3;

wait for 50 ns;


assert (Xoutport = 3)
report
"Assert 43 : < Xoutport /= 3 >"
severity warning;

assert (Youtport = 5)
report
"Assert 43 : < Youtport /= 5 >"
severity warning;

assert (Uoutport = 5)
report
"Assert 43 : < Uoutport /= 5 >"
severity warning;
--



-- Pattern # 44

Xinport <= 2;
Yinport <= 1;
Uinport <= -1;
DXport <= 1;
Aport <= 3;

wait for 50 ns;


assert (Xoutport = 3)
report
"Assert 44 : < Xoutport /= 3 >"
severity warning;

assert (Youtport = 3)
report
"Assert 44 : < Youtport /= 3 >"
severity warning;

assert (Uoutport = 2)
report
"Assert 44 : < Uoutport /= 2 >"
severity warning;
--


-- Pattern # 45

Xinport <= 3;
Yinport <= 1;
Uinport <= -1;
DXport <= 1;
Aport <= 3;

wait for 50 ns;


assert (Xoutport = 3)
report
"Assert 45 : < Xoutport /= 3 >"
severity warning;

assert (Youtport = 1)
report
"Assert 45 : < Youtport /= 1 >"
severity warning;

assert (Uoutport = -1)
report
"Assert 45 : < Uoutport /= -1 >"
severity warning;
--


-- Pattern # 46

Xinport <= 1;
Yinport <= 2;
Uinport <= -1;
DXport <= 1;
Aport <= 3;

wait for 50 ns;


assert (Xoutport = 3)
report
"Assert 46 : < Xoutport /= 3 >"
severity warning;

assert (Youtport = 24)
report
"Assert 46 : < Youtport /= 24 >"
severity warning;

assert (Uoutport = 26)
report
"Assert 46 : < Uoutport /= 26 >"
severity warning;
--



-- Pattern # 47

Xinport <= 2;
Yinport <= 2;
Uinport <= -1;
DXport <= 1;
Aport <= 3;

wait for 50 ns;


assert (Xoutport = 3)
report
"Assert 47 : < Xoutport /= 3 >"
severity warning;

assert (Youtport = 1)
report
"Assert 47 : < Youtport /= 1 >"
severity warning;

assert (Uoutport = -1)
report
"Assert 47 : < Uoutport /= -1 >"
severity warning;
--


-- Pattern # 48

Xinport <= 3;
Yinport <= 2;
Uinport <= -1;
DXport <= 1;
Aport <= 3;

wait for 50 ns;


assert (Xoutport = 3)
report
"Assert 48 : < Xoutport /= 3 >"
severity warning;

assert (Youtport = 2)
report
"Assert 48 : < Youtport /= 2 >"
severity warning;

assert (Uoutport = -1)
report
"Assert 48 : < Uoutport /= -1 >"
severity warning;
--



-- Pattern # 49

Xinport <= 1;
Yinport <= 0;
Uinport <= -1;
DXport <= 1;
Aport <= 6;

wait for 50 ns;


assert (Xoutport = 6)
report
"Assert 49 : < Xoutport /= 6 >"
severity warning;

assert (Youtport = 37096)
report
"Assert 49 : < Youtport /= 37096 >"
severity warning;

assert (Uoutport = 39278)
report
"Assert 49 : < Uoutport /= 39278 >"
severity warning;
--



-- Pattern # 50

Xinport <= 2;
Yinport <= 0;
Uinport <= -1;
DXport <= 2;
Aport <= 6;

wait for 50 ns;


assert (Xoutport = 6)
report
"Assert 50 : < Xoutport /= 6 >"
severity warning;

assert (Youtport = -748)
report
"Assert 50 : < Youtport /= -748 >"
severity warning;

assert (Uoutport = -385)
report
"Assert 50 : < Uoutport /= -385 >"
severity warning;
--


-- Pattern # 51

Xinport <= 3;
Yinport <= 0;
Uinport <= -1;
DXport <= 2;
Aport <= 6;

wait for 50 ns;


assert (Xoutport = 7)
report
"Assert 51 : < Xoutport /= 7 >"
severity warning;

assert (Youtport = -1360)
report
"Assert 51 : < Youtport /= -1360 >"
severity warning;

assert (Uoutport = -697)
report
"Assert 51 : < Uoutport /= -697 >"
severity warning;
--



-- Pattern # 52

Xinport <= 1;
Yinport <= 1;
Uinport <= -1;
DXport <= 2;
Aport <= 6;

wait for 50 ns;


assert (Xoutport = 7)
report
"Assert 52 : < Xoutport /= 7 >"
severity warning;

assert (Youtport = -1829)
report
"Assert 52 : < Youtport /= -1829 >"
severity warning;

assert (Uoutport = -937)
report
"Assert 52 : < Uoutport /= -937 >"
severity warning;
--



-- Pattern # 53

Xinport <= 2;
Yinport <= 1;
Uinport <= -1;
DXport <= 2;
Aport <= 6;

wait for 50 ns;


assert (Xoutport = 6)
report
"Assert 53 : < Xoutport /= 6 >"
severity warning;

assert (Youtport = -351)
report
"Assert 53 : < Youtport /= -351 >"
severity warning;

assert (Uoutport = -181)
report
"Assert 53 : < Uoutport /= -181 >"
severity warning;
--


-- Pattern # 54

Xinport <= 3;
Yinport <= 1;
Uinport <= -1;
DXport <= 2;
Aport <= 6;

wait for 50 ns;


assert (Xoutport = 7)
report
"Assert 54 : < Xoutport /= 7 >"
severity warning;

assert (Youtport = -891)
report
"Assert 54 : < Youtport /= -891 >"
severity warning;

assert (Uoutport = -457)
report
"Assert 54 : < Uoutport /= -457 >"
severity warning;
--


-- Pattern # 55

Xinport <= 1;
Yinport <= 2;
Uinport <= -1;
DXport <= 2;
Aport <= 6;

wait for 50 ns;


assert (Xoutport = 7)
report
"Assert 55 : < Xoutport /= 7 >"
severity warning;

assert (Youtport = -15148)
report
"Assert 55 : < Youtport /= -15148 >"
severity warning;

assert (Uoutport = -7759)
report
"Assert 55 : < Uoutport /= -7759 >"
severity warning;
--



-- Pattern # 56

Xinport <= 2;
Yinport <= 2;
Uinport <= -1;
DXport <= 2;
Aport <= 6;

wait for 50 ns;


assert (Xoutport = 6)
report
"Assert 56 : < Xoutport /= 6 >"
severity warning;

assert (Youtport = 46)
report
"Assert 56 : < Youtport /= 46 >"
severity warning;

assert (Uoutport = 23)
report
"Assert 56 : < Uoutport /= 23 >"
severity warning;
--


-- Pattern # 57

Xinport <= 3;
Yinport <= 2;
Uinport <= -1;
DXport <= 2;
Aport <= 6; 

wait for 50 ns;


assert (Xoutport = 7)
report
"Assert 57 : < Xoutport /= 7 >"
severity warning;

assert (Youtport = -422)
report
"Assert 57 : < Youtport /= -422 >"
severity warning;

assert (Uoutport = -217)
report
"Assert 57 : < Uoutport /= -217 >"
severity warning;
--


end process;

end A;
