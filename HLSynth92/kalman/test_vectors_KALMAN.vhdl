--------------------------------------------------------------------------------
--
-- Kalman Filter Benchmark
--
-- Source: Adapted from the paper
--        "A Synthesis Process applied to the Kalman Filter BEnchmark"
--         by Cleland.O.Newton, DRA Malvern, UK
--         HLSW-92
--
-- VHDL Benchmark author: Champaka Ramachandran on Aug 18th 1992 
--
-- Verification Information:
--
--                  Verified     By whom?           Date         Simulator
--                  --------   ------------        --------     ------------
--  Syntax            yes   Champaka Ramachandran  18th Aug 92    ZYCAD
--  Functionality     yes   Champaka Ramachandran  18th Aug 92    ZYCAD
--------------------------------------------------------------------------------

use work.BIT_FUNCTIONS.all;

Entity E is
end;

architecture A of E is
       Component KALMAN
       port (
                       Input_Vector: in BIT_VECTOR (15 downto 0);
                       Addr        : in integer;
                       Cexec       : in BIT;
                       Vector_type : in BIT_VECTOR (2 downto 0);
                       Output_Vector0 : out BIT_VECTOR (15 downto 0);
                       Output_Vector1 : out BIT_VECTOR (15 downto 0);
                       Output_Vector2 : out BIT_VECTOR (15 downto 0);
                       Output_Vector3 : out BIT_VECTOR (15 downto 0)
       );
       end component ;

                       signal Input_Vector: BIT_VECTOR (15 downto 0);
                       signal Addr        : integer;
                       signal Cexec       : BIT := '0';
                       signal Vector_type : BIT_VECTOR (2 downto 0);
                       signal Output_Vector0 : BIT_VECTOR (15 downto 0);
                       signal Output_Vector1 : BIT_VECTOR (15 downto 0);
                       signal Output_Vector2 : BIT_VECTOR (15 downto 0);
                       signal Output_Vector3 : BIT_VECTOR (15 downto 0);

for all : KALMAN use entity work.KALMAN(KALMAN) ;

begin

INST1 : KALMAN port map (
                       Input_Vector,
                       Addr,
                       Cexec,
                       Vector_type,
                       Output_Vector0,
                       Output_Vector1,
                       Output_Vector2,
                       Output_Vector3
                    );

process
  variable i, j : integer;
  variable O0, O1, O2, O3 : integer;
begin

-- ****************************************** 
-- *                                        * 
-- *           TEST VECTORS                 * 
-- *                                        * 
-- ****************************************** 

  Addr <= 0;
  Cexec <= '0';
  Vector_type <= "000";

wait for 1 ns;

  Cexec  <= '0';
--
-- Pattern #S0  Setting Matrix A 
-- 

  Vector_type <= "001";

  i := 0;
  while (i < 16) loop
    j := 0;
    while (j < 16) loop

      if (i = j) then
        Input_Vector <= SIGNED_INT_TO_BIN(-900, 16);
      else
        if (j - 9 = i) then
          Input_Vector <= SIGNED_INT_TO_BIN(10, 16);
        else
          Input_Vector <= SIGNED_INT_TO_BIN(0, 16);
        end if;
      end if;

      Addr <= i * 16 + j;
      wait for 1 ns;

      j := j + 1;
    end loop;
    i := i + 1;
  end loop;



--
-- Pattern #S1  Setting Matrix K
-- 

  Vector_type <= "010";

  i := 0;
  while (i < 16) loop
    j := 0;
    while (j < 16) loop

      if (i = j) and (j < 13) then
        Input_Vector <= SIGNED_INT_TO_BIN(75, 16);
      else
        if (i >= 13) and (i - 13 = j) then
          Input_Vector <= SIGNED_INT_TO_BIN(75, 16);
        else
          if (j < 13) then
            Input_Vector <= SIGNED_INT_TO_BIN(67, 16);
          else
            Input_Vector <= SIGNED_INT_TO_BIN(0, 16);
          end if;
        end if;
      end if;

      Addr <= i * 16 + j;
      wait for 1 ns;

      j := j + 1;
    end loop;
    i := i + 1;
  end loop;


--
-- Pattern #S2  Setting Matrix G
-- 

  Vector_type <= "011";

  i := 0;
  while (i < 4) loop
    j := 0;
    while (j < 16) loop

      Input_Vector <= SIGNED_INT_TO_BIN(358, 16);
      if (i = 0) and (j = 0) then
        Input_Vector <= SIGNED_INT_TO_BIN(328, 16);
      end if;

      if (i = 1) and (j = 5) then
        Input_Vector <= SIGNED_INT_TO_BIN(328, 16);
      end if;
 
      if (i = 2) and (j = 9) then
        Input_Vector <= SIGNED_INT_TO_BIN(328, 16);
      end if;

      if (i = 3) and (j = 12) then
        Input_Vector <= SIGNED_INT_TO_BIN(328, 16);
      end if;

      Addr <= i * 16 + j;
      wait for 1 ns;

      j := j + 1;
    end loop;
    i := i + 1;
  end loop;


--
-- Pattern #1  Setting Input Y (1)
-- 

  Vector_type <= "100";

  Input_Vector <= SIGNED_INT_TO_BIN(501, 16);
  Addr <= 0;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(550, 16);
  Addr <= 1;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(504, 16);
  Addr <= 2;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-500, 16);
  Addr <= 3;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(451, 16);
  Addr <= 4;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(650, 16);
  Addr <= 5;
  wait for 1 ns; 
 
  Input_Vector <= SIGNED_INT_TO_BIN(515, 16);
  Addr <= 6;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-481, 16);
  Addr <= 7;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-541, 16);
  Addr <= 8;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(410, 16);
  Addr <= 9;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(520, 16);
  Addr <= 10;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(421, 16);
  Addr <= 11;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-491, 16);
  Addr <= 12;
  wait for 1 ns; 

  Cexec <= '1';
  wait for 1 ns; 

assert (Output_Vector0 = SIGNED_INT_TO_BIN(467, 16))
report
"Assert 1 : < Output_Vector0 /= 467 >"
severity warning;

assert (Output_Vector1 = SIGNED_INT_TO_BIN(428, 16))
report
"Assert 1 : < Output_Vector1 /= 428 >"
severity warning;

assert (Output_Vector2 = SIGNED_INT_TO_BIN(-426, 16))
report
"Assert 1 : < Output_Vector2 /= -426 >"
severity warning;

assert (Output_Vector3 = SIGNED_INT_TO_BIN(383, 16))
report
"Assert 1 : < Output_Vector3 /= 383 >"
severity warning;


--
-- Pattern #2  Setting Input Y (2)
-- 

  Cexec <= '0';

  Input_Vector <= SIGNED_INT_TO_BIN(590, 16);
  Addr <= 0;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(531, 16);
  Addr <= 1;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(509, 16);
  Addr <= 2;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-490, 16);
  Addr <= 3;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(451, 16);
  Addr <= 4;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(620, 16);
  Addr <= 5;
  wait for 1 ns; 
 
  Input_Vector <= SIGNED_INT_TO_BIN(514, 16);
  Addr <= 6;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-482, 16);
  Addr <= 7;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-542, 16);
  Addr <= 8;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(449, 16);
  Addr <= 9;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(517, 16);
  Addr <= 10;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(422, 16);
  Addr <= 11;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-493, 16);
  Addr <= 12;
  wait for 1 ns; 

  Cexec <= '1';
  wait for 1 ns; 

assert (Output_Vector0 = SIGNED_INT_TO_BIN(471, 16))
report
"Assert 2 : < Output_Vector0 /= 471 >"
severity warning;

assert (Output_Vector1 = SIGNED_INT_TO_BIN(451, 16))
report
"Assert 2 : < Output_Vector1 /= 451 >"
severity warning;

assert (Output_Vector2 = SIGNED_INT_TO_BIN(-435, 16))
report
"Assert 2 : < Output_Vector2 /= -435 >"
severity warning;

assert (Output_Vector3 = SIGNED_INT_TO_BIN(400, 16))
report
"Assert 2 : < Output_Vector3 /= 400 >"
severity warning;


--
-- Pattern #3  Setting Input Y (3)
-- 

  Cexec <= '0';

  Input_Vector <= SIGNED_INT_TO_BIN(581, 16);
  Addr <= 0;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(521, 16);
  Addr <= 1;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(507, 16);
  Addr <= 2;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-492, 16);
  Addr <= 3;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(453, 16);
  Addr <= 4;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(620, 16);
  Addr <= 5;
  wait for 1 ns; 
 
  Input_Vector <= SIGNED_INT_TO_BIN(515, 16);
  Addr <= 6;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-483, 16);
  Addr <= 7;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-541, 16);
  Addr <= 8;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(457, 16);
  Addr <= 9;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(516, 16);
  Addr <= 10;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(423, 16);
  Addr <= 11;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-492, 16);
  Addr <= 12;
  wait for 1 ns; 

  Cexec <= '1';
  wait for 1 ns; 

assert (Output_Vector0 = SIGNED_INT_TO_BIN(462, 16))
report
"Assert 3 : < Output_Vector0 /= 462 >"
severity warning;

assert (Output_Vector1 = SIGNED_INT_TO_BIN(450, 16))
report
"Assert 3 : < Output_Vector1 /= 450 >"
severity warning;

assert (Output_Vector2 = SIGNED_INT_TO_BIN(-438, 16))
report
"Assert 3 : < Output_Vector2 /= -438 >"
severity warning;

assert (Output_Vector3 = SIGNED_INT_TO_BIN(402, 16))
report
"Assert 3 : < Output_Vector3 /= 402 >"
severity warning;



--
-- Pattern #4  Setting Input Y (4)
-- 

  Cexec <= '0';

  Input_Vector <= SIGNED_INT_TO_BIN(597, 16);
  Addr <= 0;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(529, 16);
  Addr <= 1;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(518, 16);
  Addr <= 2;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-493, 16);
  Addr <= 3;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(454, 16);
  Addr <= 4;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(621, 16);
  Addr <= 5;
  wait for 1 ns; 
 
  Input_Vector <= SIGNED_INT_TO_BIN(517, 16);
  Addr <= 6;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-486, 16);
  Addr <= 7;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-543, 16);
  Addr <= 8;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(438, 16);
  Addr <= 9;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(518, 16);
  Addr <= 10;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(424, 16);
  Addr <= 11;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-490, 16);
  Addr <= 12;
  wait for 1 ns; 

  Cexec <= '1';
  wait for 1 ns; 

  O0 := SIGNED_BIN_TO_INT(Output_Vector0);
  O1 := SIGNED_BIN_TO_INT(Output_Vector1);
  O2 := SIGNED_BIN_TO_INT(Output_Vector2);
  O3 := SIGNED_BIN_TO_INT(Output_Vector3);

assert (O0 = 470)
report
"Assert 4 : < O0 /= 470 >"
severity warning;

assert (O1 = 460)
report
"Assert 4 : < O1 /= 460 >"
severity warning;

assert (O2 = -439)
report
"Assert 4 : < O2 /= -439 >"
severity warning;

assert (O3 = 403)
report
"Assert 4 : < O3 /= 403 >"
severity warning;




--
-- Pattern #5  Setting Input Y (5)
-- 

  Cexec <= '0';

  Input_Vector <= SIGNED_INT_TO_BIN(597, 16);
  Addr <= 0;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(529, 16);
  Addr <= 1;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(518, 16);
  Addr <= 2;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-493, 16);
  Addr <= 3;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(454, 16);
  Addr <= 4;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(621, 16);
  Addr <= 5;
  wait for 1 ns; 
 
  Input_Vector <= SIGNED_INT_TO_BIN(517, 16);
  Addr <= 6;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-486, 16);
  Addr <= 7;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-543, 16);
  Addr <= 8;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(438, 16);
  Addr <= 9;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(518, 16);
  Addr <= 10;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(424, 16);
  Addr <= 11;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-490, 16);
  Addr <= 12;
  wait for 1 ns; 

  Cexec <= '1';
  wait for 1 ns; 

  O0 := SIGNED_BIN_TO_INT(Output_Vector0);
  O1 := SIGNED_BIN_TO_INT(Output_Vector1);
  O2 := SIGNED_BIN_TO_INT(Output_Vector2);
  O3 := SIGNED_BIN_TO_INT(Output_Vector3);

assert (O0 = 470)
report
"Assert 5 : < O0 /= 470 >"
severity warning;

assert (O1 = 460)
report
"Assert 5 : < O1 /= 460 >"
severity warning;

assert (O2 = -439)
report
"Assert 5 : < O2 /= -439 >"
severity warning;

assert (O3 = 403)
report
"Assert 5 : < O3 /= 403 >"
severity warning;


--
-- Pattern #6  Setting Input Y (6)
-- 

  Cexec <= '0';

  Input_Vector <= SIGNED_INT_TO_BIN(597, 16);
  Addr <= 0;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(529, 16);
  Addr <= 1;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(518, 16);
  Addr <= 2;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-493, 16);
  Addr <= 3;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(454, 16);
  Addr <= 4;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(621, 16);
  Addr <= 5;
  wait for 1 ns; 
 
  Input_Vector <= SIGNED_INT_TO_BIN(517, 16);
  Addr <= 6;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-486, 16);
  Addr <= 7;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-543, 16);
  Addr <= 8;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(438, 16);
  Addr <= 9;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(518, 16);
  Addr <= 10;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(424, 16);
  Addr <= 11;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-490, 16);
  Addr <= 12;
  wait for 1 ns; 

  Cexec <= '1';
  wait for 1 ns; 

  O0 := SIGNED_BIN_TO_INT(Output_Vector0);
  O1 := SIGNED_BIN_TO_INT(Output_Vector1);
  O2 := SIGNED_BIN_TO_INT(Output_Vector2);
  O3 := SIGNED_BIN_TO_INT(Output_Vector3);

assert (O0 = 470)
report
"Assert 6 : < O0 /= 470 >"
severity warning;

assert (O1 = 460)
report
"Assert 6 : < O1 /= 460 >"
severity warning;

assert (O2 = -439)
report
"Assert 6 : < O2 /= -439 >"
severity warning;

assert (O3 = 403)
report
"Assert 6 : < O3 /= 403 >"
severity warning;


--
-- Pattern #7  Setting Input Y (7)
-- 

  Cexec <= '0';

  Input_Vector <= SIGNED_INT_TO_BIN(597, 16);
  Addr <= 0;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(529, 16);
  Addr <= 1;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(518, 16);
  Addr <= 2;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-493, 16);
  Addr <= 3;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(454, 16);
  Addr <= 4;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(621, 16);
  Addr <= 5;
  wait for 1 ns; 
 
  Input_Vector <= SIGNED_INT_TO_BIN(517, 16);
  Addr <= 6;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-486, 16);
  Addr <= 7;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-543, 16);
  Addr <= 8;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(438, 16);
  Addr <= 9;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(518, 16);
  Addr <= 10;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(424, 16);
  Addr <= 11;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-490, 16);
  Addr <= 12;
  wait for 1 ns; 

  Cexec <= '1';
  wait for 1 ns; 

  O0 := SIGNED_BIN_TO_INT(Output_Vector0);
  O1 := SIGNED_BIN_TO_INT(Output_Vector1);
  O2 := SIGNED_BIN_TO_INT(Output_Vector2);
  O3 := SIGNED_BIN_TO_INT(Output_Vector3);

assert (O0 = 470)
report
"Assert 7 : < O0 /= 470 >"
severity warning;

assert (O1 = 460)
report
"Assert 7 : < O1 /= 460 >"
severity warning;

assert (O2 = -439)
report
"Assert 7 : < O2 /= -439 >"
severity warning;

assert (O3 = 403)
report
"Assert 7 : < O3 /= 403 >"
severity warning;


--
-- Pattern #8  Setting Input Y (8)
-- 

  Cexec <= '0';

  Input_Vector <= SIGNED_INT_TO_BIN(597, 16);
  Addr <= 0;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(529, 16);
  Addr <= 1;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(518, 16);
  Addr <= 2;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-493, 16);
  Addr <= 3;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(454, 16);
  Addr <= 4;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(621, 16);
  Addr <= 5;
  wait for 1 ns; 
 
  Input_Vector <= SIGNED_INT_TO_BIN(517, 16);
  Addr <= 6;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-486, 16);
  Addr <= 7;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-543, 16);
  Addr <= 8;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(438, 16);
  Addr <= 9;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(518, 16);
  Addr <= 10;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(424, 16);
  Addr <= 11;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-490, 16);
  Addr <= 12;
  wait for 1 ns; 

  Cexec <= '1';
  wait for 1 ns; 

  O0 := SIGNED_BIN_TO_INT(Output_Vector0);
  O1 := SIGNED_BIN_TO_INT(Output_Vector1);
  O2 := SIGNED_BIN_TO_INT(Output_Vector2);
  O3 := SIGNED_BIN_TO_INT(Output_Vector3);

assert (O0 = 470)
report
"Assert 8 : < O0 /= 470 >"
severity warning;

assert (O1 = 460)
report
"Assert 8 : < O1 /= 460 >"
severity warning;

assert (O2 = -439)
report
"Assert 8 : < O2 /= -439 >"
severity warning;

assert (O3 = 403)
report
"Assert 8 : < O3 /= 403 >"
severity warning;



-- Some general sanity check vectors
--
-- Pattern #9  Setting Input Y (9)
-- 

  Cexec <= '0';

  Input_Vector <= SIGNED_INT_TO_BIN(0, 16);
  Addr <= 0;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(0, 16);
  Addr <= 1;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(0, 16);
  Addr <= 2;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(0, 16);
  Addr <= 3;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(0, 16);
  Addr <= 4;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(0, 16);
  Addr <= 5;
  wait for 1 ns; 
 
  Input_Vector <= SIGNED_INT_TO_BIN(0, 16);
  Addr <= 6;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(0, 16);
  Addr <= 7;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(0, 16);
  Addr <= 8;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(0, 16);
  Addr <= 9;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(0, 16);
  Addr <= 10;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(0, 16);
  Addr <= 11;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(0, 16);
  Addr <= 12;
  wait for 1 ns; 

  Cexec <= '1';
  wait for 1 ns; 

  O0 := SIGNED_BIN_TO_INT(Output_Vector0);
  O1 := SIGNED_BIN_TO_INT(Output_Vector1);
  O2 := SIGNED_BIN_TO_INT(Output_Vector2);
  O3 := SIGNED_BIN_TO_INT(Output_Vector3);

assert (O0 = 0)
report
"Assert 9 : < O0 /= 0 >"
severity warning;

assert (O1 = 0)
report
"Assert 9 : < O1 /= 0 >"
severity warning;

assert (O2 = 0)
report
"Assert 9 : < O2 /= 0 >"
severity warning;

assert (O3 = 0)
report
"Assert 9 : < O3 /= 0 >"
severity warning;

--
-- Pattern #10  Setting Input Y (10)
-- 

  Cexec <= '0';

  Input_Vector <= SIGNED_INT_TO_BIN(-1, 16);
  Addr <= 0;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-1, 16);
  Addr <= 1;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(0, 16);
  Addr <= 2;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(0, 16);
  Addr <= 3;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(0, 16);
  Addr <= 4;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(1, 16);
  Addr <= 5;
  wait for 1 ns; 
 
  Input_Vector <= SIGNED_INT_TO_BIN(1, 16);
  Addr <= 6;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(1, 16);
  Addr <= 7;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-1, 16);
  Addr <= 8;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(0, 16);
  Addr <= 9;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(0, 16);
  Addr <= 10;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(1, 16);
  Addr <= 11;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(1, 16);
  Addr <= 12;
  wait for 1 ns; 

  Cexec <= '1';
  wait for 1 ns; 

  O0 := SIGNED_BIN_TO_INT(Output_Vector0);
  O1 := SIGNED_BIN_TO_INT(Output_Vector1);
  O2 := SIGNED_BIN_TO_INT(Output_Vector2);
  O3 := SIGNED_BIN_TO_INT(Output_Vector3);

assert (O0 = 0)
report
"Assert 10 : < O0 /= 0 >"
severity warning;

assert (O1 = 0)
report
"Assert 10 : < O1 /= 0 >"
severity warning;

assert (O2 = 0)
report
"Assert 10 : < O2 /= 0 >"
severity warning;

assert (O3 = 0)
report
"Assert 10 : < O3 /= 0 >"
severity warning;



--
-- Pattern #11  Setting Input Y (11)
-- 

  Cexec <= '0';

  Input_Vector <= SIGNED_INT_TO_BIN(1, 16);
  Addr <= 0;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(1, 16);
  Addr <= 1;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(1, 16);
  Addr <= 2;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(1, 16);
  Addr <= 3;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(1, 16);
  Addr <= 4;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(1, 16);
  Addr <= 5;
  wait for 1 ns; 
 
  Input_Vector <= SIGNED_INT_TO_BIN(1, 16);
  Addr <= 6;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(1, 16);
  Addr <= 7;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(1, 16);
  Addr <= 8;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(1, 16);
  Addr <= 9;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(1, 16);
  Addr <= 10;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(1, 16);
  Addr <= 11;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(1, 16);
  Addr <= 12;
  wait for 1 ns; 

  Cexec <= '1';
  wait for 1 ns; 

  O0 := SIGNED_BIN_TO_INT(Output_Vector0);
  O1 := SIGNED_BIN_TO_INT(Output_Vector1);
  O2 := SIGNED_BIN_TO_INT(Output_Vector2);
  O3 := SIGNED_BIN_TO_INT(Output_Vector3);

assert (O0 = 0)
report
"Assert 11 : < O0 /= 0 >"
severity warning;

assert (O1 = 0)
report
"Assert 11 : < O1 /= 0 >"
severity warning;

assert (O2 = 0)
report
"Assert 11 : < O2 /= 0 >"
severity warning;

assert (O3 = 0)
report
"Assert 11 : < O3 /= 0 >"
severity warning;


--
-- Pattern #12  Setting Input Y (12)
-- 

  Cexec <= '0';

  Input_Vector <= SIGNED_INT_TO_BIN(-1, 16);
  Addr <= 0;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-1, 16);
  Addr <= 1;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-1, 16);
  Addr <= 2;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-1, 16);
  Addr <= 3;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-1, 16);
  Addr <= 4;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-1, 16);
  Addr <= 5;
  wait for 1 ns; 
 
  Input_Vector <= SIGNED_INT_TO_BIN(-1, 16);
  Addr <= 6;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-1, 16);
  Addr <= 7;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-1, 16);
  Addr <= 8;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-1, 16);
  Addr <= 9;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-1, 16);
  Addr <= 10;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-1, 16);
  Addr <= 11;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-1, 16);
  Addr <= 12;
  wait for 1 ns; 

  Cexec <= '1';
  wait for 1 ns; 

  O0 := SIGNED_BIN_TO_INT(Output_Vector0);
  O1 := SIGNED_BIN_TO_INT(Output_Vector1);
  O2 := SIGNED_BIN_TO_INT(Output_Vector2);
  O3 := SIGNED_BIN_TO_INT(Output_Vector3);

assert (O0 = 0)
report
"Assert 12 : < O0 /= 0 >"
severity warning;

assert (O1 = 0)
report
"Assert 12 : < O1 /= 0 >"
severity warning;

assert (O2 = 0)
report
"Assert 12 : < O2 /= 0 >"
severity warning;

assert (O3 = 0)
report
"Assert 12 : < O3 /= 0 >"
severity warning;



--
-- Pattern #13  Setting Input Y (13)
-- 

  Cexec <= '0';

  Input_Vector <= SIGNED_INT_TO_BIN(5, 16);
  Addr <= 0;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(6, 16);
  Addr <= 1;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(7, 16);
  Addr <= 2;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(8, 16);
  Addr <= 3;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(1, 16);
  Addr <= 4;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(2, 16);
  Addr <= 5;
  wait for 1 ns; 
 
  Input_Vector <= SIGNED_INT_TO_BIN(3, 16);
  Addr <= 6;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(4, 16);
  Addr <= 7;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(5, 16);
  Addr <= 8;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(6, 16);
  Addr <= 9;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(7, 16);
  Addr <= 10;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(8, 16);
  Addr <= 11;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(9, 16);
  Addr <= 12;
  wait for 1 ns; 

  Cexec <= '1';
  wait for 1 ns; 

  O0 := SIGNED_BIN_TO_INT(Output_Vector0);
  O1 := SIGNED_BIN_TO_INT(Output_Vector1);
  O2 := SIGNED_BIN_TO_INT(Output_Vector2);
  O3 := SIGNED_BIN_TO_INT(Output_Vector3);

assert (O0 = 0)
report
"Assert 13 : < O0 /= 0 >"
severity warning;

assert (O1 = 0)
report
"Assert 13 : < O1 /= 0 >"
severity warning;

assert (O2 = 0)
report
"Assert 13 : < O2 /= 0 >"
severity warning;

assert (O3 = 0)
report
"Assert 13 : < O3 /= 0 >"
severity warning;






--
-- Pattern #14  Setting Input Y (14)
-- 

  Cexec <= '0';

  Input_Vector <= SIGNED_INT_TO_BIN(1, 16);
  Addr <= 0;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(2, 16);
  Addr <= 1;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(3, 16);
  Addr <= 2;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(4, 16);
  Addr <= 3;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(5, 16);
  Addr <= 4;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(6, 16);
  Addr <= 5;
  wait for 1 ns; 
 
  Input_Vector <= SIGNED_INT_TO_BIN(7, 16);
  Addr <= 6;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(8, 16);
  Addr <= 7;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-9, 16);
  Addr <= 8;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-1, 16);
  Addr <= 9;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-2, 16);
  Addr <= 10;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-3, 16);
  Addr <= 11;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-4, 16);
  Addr <= 12;
  wait for 1 ns; 

  Cexec <= '1';
  wait for 1 ns; 

  O0 := SIGNED_BIN_TO_INT(Output_Vector0);
  O1 := SIGNED_BIN_TO_INT(Output_Vector1);
  O2 := SIGNED_BIN_TO_INT(Output_Vector2);
  O3 := SIGNED_BIN_TO_INT(Output_Vector3);

assert (O0 = -1)
report
"Assert 14 : < O0 /= -1 >"
severity warning;

assert (O1 = -1)
report
"Assert 14 : < O1 /= -1 >"
severity warning;

assert (O2 = -1)
report
"Assert 14 : < O2 /= -1 >"
severity warning;

assert (O3 = -1)
report
"Assert 14 : < O3 /= -1 >"
severity warning;


--
-- Pattern #15  Setting Input Y (15)
-- 

  Cexec <= '0';

  Input_Vector <= SIGNED_INT_TO_BIN(-1, 16);
  Addr <= 0;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-2, 16);
  Addr <= 1;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-3, 16);
  Addr <= 2;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-4, 16);
  Addr <= 3;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-5, 16);
  Addr <= 4;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-6, 16);
  Addr <= 5;
  wait for 1 ns; 
 
  Input_Vector <= SIGNED_INT_TO_BIN(-7, 16);
  Addr <= 6;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-8, 16);
  Addr <= 7;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-9, 16);
  Addr <= 8;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-1, 16);
  Addr <= 9;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-2, 16);
  Addr <= 10;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-3, 16);
  Addr <= 11;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-4, 16);
  Addr <= 12;
  wait for 1 ns; 

  Cexec <= '1';
  wait for 1 ns; 

  O0 := SIGNED_BIN_TO_INT(Output_Vector0);
  O1 := SIGNED_BIN_TO_INT(Output_Vector1);
  O2 := SIGNED_BIN_TO_INT(Output_Vector2);
  O3 := SIGNED_BIN_TO_INT(Output_Vector3);

assert (O0 = 0)
report
"Assert 15 : < O0 /= 0 >"
severity warning;

assert (O1 = 0)
report
"Assert 15 : < O1 /= 0 >"
severity warning;

assert (O2 = 0)
report
"Assert 15 : < O2 /= 0 >"
severity warning;

assert (O3 = 0)
report
"Assert 15 : < O3 /= 0 >"
severity warning;


--
-- Pattern #16  Setting Input Y (16)
-- 

  Cexec <= '0';

  Input_Vector <= SIGNED_INT_TO_BIN(50, 16);
  Addr <= 0;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(60, 16);
  Addr <= 1;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(70, 16);
  Addr <= 2;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(80, 16);
  Addr <= 3;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(10, 16);
  Addr <= 4;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(20, 16);
  Addr <= 5;
  wait for 1 ns; 
 
  Input_Vector <= SIGNED_INT_TO_BIN(30, 16);
  Addr <= 6;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(40, 16);
  Addr <= 7;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(50, 16);
  Addr <= 8;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(60, 16);
  Addr <= 9;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(70, 16);
  Addr <= 10;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(80, 16);
  Addr <= 11;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(90, 16);
  Addr <= 12;
  wait for 1 ns; 

  Cexec <= '1';
  wait for 1 ns; 

  O0 := SIGNED_BIN_TO_INT(Output_Vector0);
  O1 := SIGNED_BIN_TO_INT(Output_Vector1);
  O2 := SIGNED_BIN_TO_INT(Output_Vector2);
  O3 := SIGNED_BIN_TO_INT(Output_Vector3);

assert (O0 = 12)
report
"Assert 16 : < O0 /= 12 >"
severity warning;

assert (O1 = 14)
report
"Assert 16 : < O1 /= 14 >"
severity warning;

assert (O2 = 16)
report
"Assert 16 : < O2 /= 16 >"
severity warning;

assert (O3 = 2)
report
"Assert 16 : < O3 /= 2 >"
severity warning;






--
-- Pattern #17  Setting Input Y (17)
-- 

  Cexec <= '0';

  Input_Vector <= SIGNED_INT_TO_BIN(10, 16);
  Addr <= 0;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(20, 16);
  Addr <= 1;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(30, 16);
  Addr <= 2;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(40, 16);
  Addr <= 3;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(50, 16);
  Addr <= 4;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(60, 16);
  Addr <= 5;
  wait for 1 ns; 
 
  Input_Vector <= SIGNED_INT_TO_BIN(70, 16);
  Addr <= 6;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(80, 16);
  Addr <= 7;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-90, 16);
  Addr <= 8;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-10, 16);
  Addr <= 9;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-20, 16);
  Addr <= 10;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-30, 16);
  Addr <= 11;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-40, 16);
  Addr <= 12;
  wait for 1 ns; 

  Cexec <= '1';
  wait for 1 ns; 

  O0 := SIGNED_BIN_TO_INT(Output_Vector0);
  O1 := SIGNED_BIN_TO_INT(Output_Vector1);
  O2 := SIGNED_BIN_TO_INT(Output_Vector2);
  O3 := SIGNED_BIN_TO_INT(Output_Vector3);

assert (O0 = 0)
report
"Assert 17 : < O0 /= 0 >"
severity warning;

assert (O1 = 0)
report
"Assert 17 : < O1 /= 0 >"
severity warning;

assert (O2 = 0)
report
"Assert 17 : < O2 /= 0 >"
severity warning;

assert (O3 = 0)
report
"Assert 17 : < O3 /= 0 >"
severity warning;


--
-- Pattern #18  Setting Input Y (18)
-- 

  Cexec <= '0';

  Input_Vector <= SIGNED_INT_TO_BIN(-10, 16);
  Addr <= 0;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-20, 16);
  Addr <= 1;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-30, 16);
  Addr <= 2;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-40, 16);
  Addr <= 3;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-50, 16);
  Addr <= 4;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-60, 16);
  Addr <= 5;
  wait for 1 ns; 
 
  Input_Vector <= SIGNED_INT_TO_BIN(-70, 16);
  Addr <= 6;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-80, 16);
  Addr <= 7;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-90, 16);
  Addr <= 8;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-10, 16);
  Addr <= 9;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-20, 16);
  Addr <= 10;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-30, 16);
  Addr <= 11;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-40, 16);
  Addr <= 12;
  wait for 1 ns; 

  Cexec <= '1';
  wait for 1 ns; 

  O0 := SIGNED_BIN_TO_INT(Output_Vector0);
  O1 := SIGNED_BIN_TO_INT(Output_Vector1);
  O2 := SIGNED_BIN_TO_INT(Output_Vector2);
  O3 := SIGNED_BIN_TO_INT(Output_Vector3);

assert (O0 = 4)
report
"Assert 18 : < O0 /= 4 >"
severity warning;

assert (O1 = 7)
report
"Assert 18 : < O1 /= 7 >"
severity warning;

assert (O2 = 9)
report
"Assert 18 : < O2 /= 9 >"
severity warning;

assert (O3 = 11)
report
"Assert 18 : < O3 /= 11 >"
severity warning;


--
-- Pattern #19  Setting Input Y (19)
-- 

  Cexec <= '0';

  Input_Vector <= SIGNED_INT_TO_BIN(500, 16);
  Addr <= 0;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(600, 16);
  Addr <= 1;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(700, 16);
  Addr <= 2;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(800, 16);
  Addr <= 3;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(100, 16);
  Addr <= 4;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(200, 16);
  Addr <= 5;
  wait for 1 ns; 
 
  Input_Vector <= SIGNED_INT_TO_BIN(300, 16);
  Addr <= 6;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(400, 16);
  Addr <= 7;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(500, 16);
  Addr <= 8;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(600, 16);
  Addr <= 9;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(700, 16);
  Addr <= 10;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(800, 16);
  Addr <= 11;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(900, 16);
  Addr <= 12;
  wait for 1 ns; 

  Cexec <= '1';
  wait for 1 ns; 

  O0 := SIGNED_BIN_TO_INT(Output_Vector0);
  O1 := SIGNED_BIN_TO_INT(Output_Vector1);
  O2 := SIGNED_BIN_TO_INT(Output_Vector2);
  O3 := SIGNED_BIN_TO_INT(Output_Vector3);

assert (O0 = 1502)
report
"Assert 19 : < O0 /= 1502 >"
severity warning;

assert (O1 = 1754)
report
"Assert 19 : < O1 /= 1754 >"
severity warning;

assert (O2 = 2003)
report
"Assert 19 : < O2 /= 2003 >"
severity warning;

assert (O3 = 250)
report
"Assert 19 : < O3 /= 250 >"
severity warning;






--
-- Pattern #20  Setting Input Y (20)
-- 

  Cexec <= '0';

  Input_Vector <= SIGNED_INT_TO_BIN(100, 16);
  Addr <= 0;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(200, 16);
  Addr <= 1;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(300, 16);
  Addr <= 2;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(400, 16);
  Addr <= 3;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(500, 16);
  Addr <= 4;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(600, 16);
  Addr <= 5;
  wait for 1 ns; 
 
  Input_Vector <= SIGNED_INT_TO_BIN(700, 16);
  Addr <= 6;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(800, 16);
  Addr <= 7;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-900, 16);
  Addr <= 8;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-100, 16);
  Addr <= 9;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-200, 16);
  Addr <= 10;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-300, 16);
  Addr <= 11;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-400, 16);
  Addr <= 12;
  wait for 1 ns; 

  Cexec <= '1';
  wait for 1 ns; 

  O0 := SIGNED_BIN_TO_INT(Output_Vector0);
  O1 := SIGNED_BIN_TO_INT(Output_Vector1);
  O2 := SIGNED_BIN_TO_INT(Output_Vector2);
  O3 := SIGNED_BIN_TO_INT(Output_Vector3);

assert (O0 = 114)
report
"Assert 20 : < O0 /= 114 >"
severity warning;

assert (O1 = 171)
report
"Assert 20 : < O1 /= 171 >"
severity warning;

assert (O2 = 228)
report
"Assert 20 : < O2 /= 228 >"
severity warning;

assert (O3 = 285)
report
"Assert 20 : < O3 /= 285 >"
severity warning;


--
-- Pattern #21  Setting Input Y (21)
-- 

  Cexec <= '0';

  Input_Vector <= SIGNED_INT_TO_BIN(-100, 16);
  Addr <= 0;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-200, 16);
  Addr <= 1;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-300, 16);
  Addr <= 2;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-400, 16);
  Addr <= 3;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-500, 16);
  Addr <= 4;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-600, 16);
  Addr <= 5;
  wait for 1 ns; 
 
  Input_Vector <= SIGNED_INT_TO_BIN(-700, 16);
  Addr <= 6;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-800, 16);
  Addr <= 7;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-900, 16);
  Addr <= 8;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-100, 16);
  Addr <= 9;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-200, 16);
  Addr <= 10;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-300, 16);
  Addr <= 11;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-400, 16);
  Addr <= 12;
  wait for 1 ns; 

  Cexec <= '1';
  wait for 1 ns; 

  O0 := SIGNED_BIN_TO_INT(Output_Vector0);
  O1 := SIGNED_BIN_TO_INT(Output_Vector1);
  O2 := SIGNED_BIN_TO_INT(Output_Vector2);
  O3 := SIGNED_BIN_TO_INT(Output_Vector3);

assert (O0 = 403)
report
"Assert 21 : < O0 /= 403 >"
severity warning;

assert (O1 = 605)
report
"Assert 21 : < O1 /= 605 >"
severity warning;

assert (O2 = 807)
report
"Assert 21 : < O2 /= 807 >"
severity warning;

assert (O3 = 1008)
report
"Assert 21 : < O3 /= 1008 >"
severity warning;



--
-- Pattern #22  Setting Input Y (22)
-- 

  Cexec <= '0';

  Input_Vector <= SIGNED_INT_TO_BIN(5000, 16);
  Addr <= 0;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(6000, 16);
  Addr <= 1;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(7000, 16);
  Addr <= 2;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(8000, 16);
  Addr <= 3;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(1000, 16);
  Addr <= 4;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(2000, 16);
  Addr <= 5;
  wait for 1 ns; 
 
  Input_Vector <= SIGNED_INT_TO_BIN(3000, 16);
  Addr <= 6;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(4000, 16);
  Addr <= 7;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(5000, 16);
  Addr <= 8;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(6000, 16);
  Addr <= 9;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(7000, 16);
  Addr <= 10;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(8000, 16);
  Addr <= 11;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(9000, 16);
  Addr <= 12;
  wait for 1 ns; 

  Cexec <= '1';
  wait for 1 ns; 

  O0 := SIGNED_BIN_TO_INT(Output_Vector0);
  O1 := SIGNED_BIN_TO_INT(Output_Vector1);
  O2 := SIGNED_BIN_TO_INT(Output_Vector2);
  O3 := SIGNED_BIN_TO_INT(Output_Vector3);

assert (O0 = 21576)
report
"Assert 22 : < O0 /= 21576 >"
severity warning;

assert (O1 = -18512)
report
"Assert 22 : < O1 /= -18512 >"
severity warning;

assert (O2 = 6923)
report
"Assert 22 : < O2 /= 6923 >"
severity warning;

assert (O3 = 25439)
report
"Assert 22 : < O3 /= 25439 >"
severity warning;






--
-- Pattern #23  Setting Input Y (23)
-- 

  Cexec <= '0';

  Input_Vector <= SIGNED_INT_TO_BIN(1000, 16);
  Addr <= 0;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(2300, 16);
  Addr <= 1;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(3000, 16);
  Addr <= 2;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(4000, 16);
  Addr <= 3;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(5000, 16);
  Addr <= 4;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(6000, 16);
  Addr <= 5;
  wait for 1 ns; 
 
  Input_Vector <= SIGNED_INT_TO_BIN(7000, 16);
  Addr <= 6;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(8000, 16);
  Addr <= 7;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-9000, 16);
  Addr <= 8;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-1000, 16);
  Addr <= 9;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-2000, 16);
  Addr <= 10;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-3000, 16);
  Addr <= 11;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-4000, 16);
  Addr <= 12;
  wait for 1 ns; 

  Cexec <= '1';
  wait for 1 ns; 

  O0 := SIGNED_BIN_TO_INT(Output_Vector0);
  O1 := SIGNED_BIN_TO_INT(Output_Vector1);
  O2 := SIGNED_BIN_TO_INT(Output_Vector2);
  O3 := SIGNED_BIN_TO_INT(Output_Vector3);

assert (O0 = 14211)
report
"Assert 23 : < O0 /= 14211 >"
severity warning;

assert (O1 = 18533)
report
"Assert23 : < O1 /= 18533 >"
severity warning;

assert (O2 = 24714)
report
"Assert23 : < O2 /= 24714 >"
severity warning;

assert (O3 = 30898)
report
"Assert23 : < O3 /= 30898 >"
severity warning;


--
-- Pattern #24  Setting Input Y (24)
-- 

  Cexec <= '0';

  Input_Vector <= SIGNED_INT_TO_BIN(-1000, 16);
  Addr <= 0;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-2000, 16);
  Addr <= 1;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-3000, 16);
  Addr <= 2;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-4000, 16);
  Addr <= 3;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-5000, 16);
  Addr <= 4;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-6000, 16);
  Addr <= 5;
  wait for 1 ns; 
 
  Input_Vector <= SIGNED_INT_TO_BIN(-7000, 16);
  Addr <= 6;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-8000, 16);
  Addr <= 7;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-9000, 16);
  Addr <= 8;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-1000, 16);
  Addr <= 9;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-2000, 16);
  Addr <= 10;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-3000, 16);
  Addr <= 11;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-4000, 16);
  Addr <= 12;
  wait for 1 ns; 

  Cexec <= '1';
  wait for 1 ns; 

  O0 := SIGNED_BIN_TO_INT(Output_Vector0);
  O1 := SIGNED_BIN_TO_INT(Output_Vector1);
  O2 := SIGNED_BIN_TO_INT(Output_Vector2);
  O3 := SIGNED_BIN_TO_INT(Output_Vector3);

assert (O0 = -26015)
report
"Assert 24 : < O0 /= -26015 >"
severity warning;

assert (O1 = -6257)
report
"Assert 24 : < O1 /= -6257 >"
severity warning;

assert (O2 = 13506)
report
"Assert 24 : < O2 /= 13506 >"
severity warning;

assert (O3 = -32274)
report
"Assert 24 : < O3 /= -32274 >"
severity warning;

assert (O0 = 0)
report
"Assert 24 complete"
severity warning;





--
-- Pattern #25  Setting Input Y (25)
-- 

  Cexec <= '0';

  Input_Vector <= SIGNED_INT_TO_BIN(1, 16);
  Addr <= 0;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(20, 16);
  Addr <= 1;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(300, 16);
  Addr <= 2;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(4000, 16);
  Addr <= 3;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(5, 16);
  Addr <= 4;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(60, 16);
  Addr <= 5;
  wait for 1 ns; 
 
  Input_Vector <= SIGNED_INT_TO_BIN(700, 16);
  Addr <= 6;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(8000, 16);
  Addr <= 7;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(9, 16);
  Addr <= 8;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(10, 16);
  Addr <= 9;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(200, 16);
  Addr <= 10;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(3000, 16);
  Addr <= 11;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(4, 16);
  Addr <= 12;
  wait for 1 ns; 

  Cexec <= '1';
  wait for 1 ns; 

  O0 := SIGNED_BIN_TO_INT(Output_Vector0);
  O1 := SIGNED_BIN_TO_INT(Output_Vector1);
  O2 := SIGNED_BIN_TO_INT(Output_Vector2);
  O3 := SIGNED_BIN_TO_INT(Output_Vector3);

assert (O0 = 115)
report
"Assert 25 : < O0 /= 115 >"
severity warning;

assert (O1 = 1739)
report
"Assert 25 : < O1 /= 1739 >"
severity warning;

assert (O2 = 23191)
report
"Assert 25 : < O2 /= 23191 >"
severity warning;

assert (O3 = 28)
report
"Assert 25 : < O3 /= 28 >"
severity warning;


--
-- Pattern #26  Setting Input Y (26)
-- 

  Cexec <= '0';

  Input_Vector <= SIGNED_INT_TO_BIN(1, 16);
  Addr <= 0;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(20, 16);
  Addr <= 1;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(300, 16);
  Addr <= 2;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(4000, 16);
  Addr <= 3;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(5, 16);
  Addr <= 4;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(60, 16);
  Addr <= 5;
  wait for 1 ns; 
 
  Input_Vector <= SIGNED_INT_TO_BIN(700, 16);
  Addr <= 6;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(8000, 16);
  Addr <= 7;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-9, 16);
  Addr <= 8;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-10, 16);
  Addr <= 9;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-200, 16);
  Addr <= 10;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-3000, 16);
  Addr <= 11;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-4, 16);
  Addr <= 12;
  wait for 1 ns; 

  Cexec <= '1';
  wait for 1 ns; 

  O0 := SIGNED_BIN_TO_INT(Output_Vector0);
  O1 := SIGNED_BIN_TO_INT(Output_Vector1);
  O2 := SIGNED_BIN_TO_INT(Output_Vector2);
  O3 := SIGNED_BIN_TO_INT(Output_Vector3);

assert (O0 = 69)
report
"Assert 26 : < O0 /= 69 >"
severity warning;

assert (O1 = 1046)
report
"Assert 26 : < O1 /= 1046 >"
severity warning;

assert (O2 = 13957)
report
"Assert 26 : < O2 /= 13957 >"
severity warning;

assert (O3 = 17)
report
"Assert 26 : < O3 /= 17 >"
severity warning;

assert (O0 = 0)
report
"Assert 26 complete"
severity warning;

--
-- Pattern #27  Setting Input Y (27)
-- 

  Cexec <= '0';

  Input_Vector <= SIGNED_INT_TO_BIN(-1, 16);
  Addr <= 0;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-20, 16);
  Addr <= 1;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-300, 16);
  Addr <= 2;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-4000, 16);
  Addr <= 3;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-5, 16);
  Addr <= 4;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-60, 16);
  Addr <= 5;
  wait for 1 ns; 
 
  Input_Vector <= SIGNED_INT_TO_BIN(-700, 16);
  Addr <= 6;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-8000, 16);
  Addr <= 7;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-9, 16);
  Addr <= 8;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-10, 16);
  Addr <= 9;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-200, 16);
  Addr <= 10;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-3000, 16);
  Addr <= 11;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-4, 16);
  Addr <= 12;
  wait for 1 ns; 

  Cexec <= '1';
  wait for 1 ns; 

  O0 := SIGNED_BIN_TO_INT(Output_Vector0);
  O1 := SIGNED_BIN_TO_INT(Output_Vector1);
  O2 := SIGNED_BIN_TO_INT(Output_Vector2);
  O3 := SIGNED_BIN_TO_INT(Output_Vector3);

assert (O0 = 117)
report
"Assert 27 : < O0 /= 117 >"
severity warning;

assert (O1 = 1766)
report
"Assert 27 : < O1 /= 1766 >"
severity warning;

assert (O2 = 23554)
report
"Assert 27 : < O2 /= 23554 >"
severity warning;

assert (O3 = 29)
report
"Assert 27 : < O3 /= 29 >"
severity warning;



--
-- Pattern #28  Setting Input Y (28)
-- 

  Cexec <= '0';

  Input_Vector <= SIGNED_INT_TO_BIN(-100, 16);
  Addr <= 0;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(200, 16);
  Addr <= 1;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-300, 16);
  Addr <= 2;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(400, 16);
  Addr <= 3;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-500, 16);
  Addr <= 4;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(600, 16);
  Addr <= 5;
  wait for 1 ns; 
 
  Input_Vector <= SIGNED_INT_TO_BIN(-700, 16);
  Addr <= 6;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(800, 16);
  Addr <= 7;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-900, 16);
  Addr <= 8;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(100, 16);
  Addr <= 9;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-200, 16);
  Addr <= 10;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(300, 16);
  Addr <= 11;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-400, 16);
  Addr <= 12;
  wait for 1 ns; 

  Cexec <= '1';
  wait for 1 ns; 

  O0 := SIGNED_BIN_TO_INT(Output_Vector0);
  O1 := SIGNED_BIN_TO_INT(Output_Vector1);
  O2 := SIGNED_BIN_TO_INT(Output_Vector2);
  O3 := SIGNED_BIN_TO_INT(Output_Vector3);

assert (O0 = -58)
report
"Assert 28 : < O0 /= -58 >"
severity warning;

assert (O1 = 86)
report
"Assert 28 : < O1 /= 86 >"
severity warning;

assert (O2 = -116)
report
"Assert 28 : < O2 /= -116 >"
severity warning;

assert (O3 = 144)
report
"Assert 28 : < O3 /= 144 >"
severity warning;




--
-- Pattern #29  Setting Input Y (29)
-- 

  Cexec <= '0';

  Input_Vector <= SIGNED_INT_TO_BIN(-1000, 16);
  Addr <= 0;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(2000, 16);
  Addr <= 1;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-3000, 16);
  Addr <= 2;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(4000, 16);
  Addr <= 3;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-5000, 16);
  Addr <= 4;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(6000, 16);
  Addr <= 5;
  wait for 1 ns; 
 
  Input_Vector <= SIGNED_INT_TO_BIN(-7000, 16);
  Addr <= 6;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(8000, 16);
  Addr <= 7;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-9000, 16);
  Addr <= 8;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(1000, 16);
  Addr <= 9;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-2000, 16);
  Addr <= 10;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(3000, 16);
  Addr <= 11;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-4000, 16);
  Addr <= 12;
  wait for 1 ns; 

  Cexec <= '1';
  wait for 1 ns; 

  O0 := SIGNED_BIN_TO_INT(Output_Vector0);
  O1 := SIGNED_BIN_TO_INT(Output_Vector1);
  O2 := SIGNED_BIN_TO_INT(Output_Vector2);
  O3 := SIGNED_BIN_TO_INT(Output_Vector3);

assert (O0 = -5116)
report
"Assert 29 : < O0 /= -5116 >"
severity warning;

assert (O1 = 7675)
report
"Assert 29 : < O1 /= 7675 >"
severity warning;

assert (O2 = -10235)
report
"Assert 29 : < O2 /= -10235>"
severity warning;

assert (O3 = 12783)
report
"Assert 29 : < O3 /= 12783 >"
severity warning;



--
-- Pattern #30  Setting Input Y (30)
-- 

  Cexec <= '0';

  Input_Vector <= SIGNED_INT_TO_BIN(-1, 16);
  Addr <= 0;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(20, 16);
  Addr <= 1;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-300, 16);
  Addr <= 2;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(4000, 16);
  Addr <= 3;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-5, 16);
  Addr <= 4;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(60, 16);
  Addr <= 5;
  wait for 1 ns; 
 
  Input_Vector <= SIGNED_INT_TO_BIN(-700, 16);
  Addr <= 6;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(8000, 16);
  Addr <= 7;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-9, 16);
  Addr <= 8;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(10, 16);
  Addr <= 9;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-200, 16);
  Addr <= 10;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(3000, 16);
  Addr <= 11;
  wait for 1 ns; 

  Input_Vector <= SIGNED_INT_TO_BIN(-4, 16);
  Addr <= 12;
  wait for 1 ns; 

  Cexec <= '1';
  wait for 1 ns; 

  O0 := SIGNED_BIN_TO_INT(Output_Vector0);
  O1 := SIGNED_BIN_TO_INT(Output_Vector1);
  O2 := SIGNED_BIN_TO_INT(Output_Vector2);
  O3 := SIGNED_BIN_TO_INT(Output_Vector3);

assert (O0 = 98)
report
"Assert 30 : < O0 /= 98 >"
severity warning;

assert (O1 = -1476)
report
"Assert 30 : < O1 /= -1476 >"
severity warning;

assert (O2 = 19667)
report
"Assert 30 : < O2 /= 19667 >"
severity warning;

assert (O3 = -25)
report
"Assert 30 : < O3 /= -25 >"
severity warning;


assert (O0 = 0)
report
"Assert 30 complete"
severity warning;



end process;

end A;
