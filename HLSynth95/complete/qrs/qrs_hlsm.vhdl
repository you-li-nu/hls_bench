--**VHDL*************************************************************
--
-- SRC-MODULE : QRS
-- NAME       : qrs_hlsm.vhdl
-- VERSION    : 1.1
--
-- PURPOSE    : Architecture of QRS Chip
--                      (high level state machine description)
--
-- LAST UPDATE: Thu Feb 15 11:35:13 1993
--
-- Verification Information:
--
--                  Verified     By whom?           Date         Simulator
--                  --------   ------------        --------     ------------
--  Syntax            yes     Preeti R. Panda      17 Jan 95    Synopsys
--  Functionality     yes     Manu Gulati          01 Dec 93    Synopsys
--*******************************************************************
--
-- Architecture of QRS
--

USE work.qrs_types.all;

ARCHITECTURE hlsm OF qrs IS

  --
  -- The next two procedures "plus" and "not" are just for simulation.
  -- The synthesis tools should somehow know what to do with these procedures.
  -- These procedures are provided to rely on the standard VHDL package, only.
  -- In fact, the following lines look awful and I bet there exist better
  -- ways to specify following procedures. However, it works and so I did
  -- not think about better solutions.
  --
 
    PROCEDURE plus(lop : integer; rop : integer; carry_in : bit;
               res : out integer; carry_out : out bit) IS
        VARIABLE  result : integer;
    BEGIN
        result := lop + rop;
        IF carry_in = '1' THEN
            result := result + 1;
        END IF;
        IF result > 65535 THEN
            result := result - 65536;
            carry_out := '1';
        ELSIF result < -65536 THEN
            result := result + 65536;
            carry_out := '1';
        ELSE
            carry_out := '0';
        END IF;
        res := result;
    END plus;

    FUNCTION  "not"(op : integer)  return integer IS
    BEGIN
        return -1 - op;
    END "not";
  
BEGIN
  qrs: PROCESS

    CONSTANT  Active   : boolean := FALSE;  -- Low active inputs and outputs!
    CONSTANT  Inactive : boolean := TRUE;   -- Low active inputs and outputs!

    VARIABLE  ft, ftm1, ftm2, ecgm1, ecg1            : int16;
    VARIABLE  ysi,ymax,xmax,y0,ath,ys,y0m2,zmax,y0m1 : int16;
    VARIABLE  sth1,sth2,lxmax,lymax,lzmax            : int16;
    VARIABLE  low, high                              : int16;
    VARIABLE  xtmp, ytmp, ztmp                       : int16;
    VARIABLE  i, indx, RR                            : int16;
    VARIABLE  count                                  : nat4;
    VARIABLE  fl3                                    : nat2;
    VARIABLE  init, fl1, fl2                         : boolean;
    VARIABLE  RRflag                                 : boolean;   -- flag for RR > low
    VARIABLE  init_flag                              : boolean;
    VARIABLE  step                                   : nat4;      -- For the Schedule
    VARIABLE  ci1    : bit;                     -- Help variable for Adder 1
    VARIABLE  ci2    : bit;                     -- Help variable for Adder 2
    VARIABLE  ci3    : bit;                     -- Help variable for Adder 3
    VARIABLE  se3    : bit;                     -- Help variable for Adder 3
    VARIABLE  add1a  : int16;                   -- Help variable for Adder 1
    VARIABLE  add1b  : int16;                   -- Help variable for Adder 1
    VARIABLE  nadd1b : int16;                   -- Help variable for Adder 1
    VARIABLE  add2a  : int16;                   -- Help variable for Adder 2
    VARIABLE  add2b  : int16;                   -- Help variable for Adder 2
    VARIABLE  nadd2b : int16;                   -- Help variable for Adder 2
    VARIABLE  add3a  : int16;                   -- Help variable for Adder 3
    VARIABLE  add3b  : int16;                   -- Help variable for Adder 3
    VARIABLE  nadd3b : int16;                   -- Help variable for Adder 3
    VARIABLE  co1    : bit;                     -- Help variable for Adder 1
    VARIABLE  co2    : bit;                     -- Help variable for Adder 2
    VARIABLE  co3    : bit;                     -- Help variable for Adder 3
    VARIABLE  sum1   : int16;                   -- Help variable for Adder 1
    VARIABLE  sum2   : int16;                   -- Help variable for Adder 2
    VARIABLE  sum3   : int16;                   -- Help variable for Adder 3
    VARIABLE  sign1  : boolean;                 -- Help variable for Adder 1
    VARIABLE  sign2  : boolean;                 -- Help variable for Adder 2
    VARIABLE  sign3  : boolean;                 -- Help variable for Adder 3

  BEGIN

    rdy    <= Inactive;
    RRpeak <= Inactive;
    fl3o   <= 0;
    RRo    <= 0;
    y0m1   := 0;
    y0m2   := 0;
    ymax   := 0;
    xmax   := 0;
    zmax   := 0;
    xtmp   := 0;
    ytmp   := 0;
    ztmp   := 0;
    RR     := 0;         
    lymax  := 0;
    lzmax  := 0;
    lxmax  := 0;
    fl3    := 0;
    fl1    := False;
    fl2    := False;
    count  := 0;

  RESET_LOOP: LOOP

    --* wait until sENDer is free *--
    LOOP WAIT UNTIL clk = '1';EXIT RESET_LOOP WHEN (reset = '1');
        EXIT WHEN we = Inactive;
    END LOOP;

    --* announce ready to read *--
    rdy <= Active;                              

    --* wait until sENDer has sent *--
    LOOP WAIT UNTIL clk = '1';EXIT RESET_LOOP WHEN (reset = '1');
        EXIT WHEN we = Active;
    END LOOP;

    --* read the data *--
    low := data;

    rdy <= Inactive;

    --* wait until sENDer is free *--
    LOOP WAIT UNTIL clk = '1';EXIT RESET_LOOP WHEN (reset = '1');
        EXIT WHEN we = Inactive;
    END LOOP;

    --* announce ready to read *--
    rdy <= Active;                              

    --* wait until sENDer has sent *--
    LOOP WAIT UNTIL clk = '1';EXIT RESET_LOOP WHEN (reset = '1');
        EXIT WHEN we = Active;
    END LOOP;

    --* read the data *--
    high := data;

    rdy  <= Inactive;

    --* wait until sENDer is free *--
    LOOP WAIT UNTIL clk = '1';EXIT RESET_LOOP WHEN (reset = '1');
        EXIT WHEN we = Inactive;
    END LOOP;

    --* announce ready to read *--
    rdy <= Active;                              

    --* wait until sENDer has sent *--
    LOOP WAIT UNTIL clk = '1';EXIT RESET_LOOP WHEN (reset = '1');
        EXIT WHEN we = Active;
    END LOOP;

    --* read the data *--
    indx := data;

    rdy  <= Inactive;

    --* wait until sENDer is free *--
    LOOP WAIT UNTIL clk = '1';EXIT RESET_LOOP WHEN (reset = '1');
        EXIT WHEN we = Inactive;
    END LOOP;

    --* announce ready to read *--
    rdy <= Active;                              

    --* wait until sENDer has sent *--
    LOOP WAIT UNTIL clk = '1';EXIT RESET_LOOP WHEN (reset = '1');
        EXIT WHEN we = Active;
    END LOOP;

    --* read the data *--
    ftm2 := data;

    rdy  <= Inactive;

    --* wait until sENDer is free *--
    LOOP WAIT UNTIL clk = '1';EXIT RESET_LOOP WHEN (reset = '1');
        EXIT WHEN we = Inactive;
    END LOOP;

    --* announce ready to read *--
    rdy <= Active;                              

    --* wait until sENDer has sent *--
    LOOP WAIT UNTIL clk = '1';EXIT RESET_LOOP WHEN (reset = '1');
        EXIT WHEN we = Active;
    END LOOP;

    --* read the data *--
    ftm1  := data;

    ecgm1 := ftm1;

    i    := 0;
    init := True;    
    step := 0;
    rdy  <= Inactive;

    -- start regular detection routine or initialize
    LOOP WAIT UNTIL clk = '1';EXIT RESET_LOOP WHEN (reset = '1');

        --   initialization of variables, to avoid register inference
        se3 := '0'; ci3 := '0'; add3a := 0; add3b := 0;
        CASE step IS
          WHEN 0 =>
            ci1 := '0'; add1a := xtmp; add1b := xmax / 8;
            ci2 := '0'; add2a := ytmp; add2b := ymax / 8;

          WHEN 1 =>
            ci1 := '0'; add1a := xtmp; add1b := lxmax / 8;
            ci2 := '0'; add2a := ytmp; add2b := lymax / 8;
            se3 := '1'; ci3 := '1'; add3a := 0; add3b := i;

          WHEN 2 =>
            -- ft = ftm1 + 0.9965*(ecg1 - ecgm1) ;
            ci1 := '1'; add1a := ecg1; add1b := ecgm1;
            ci2 := '0'; add2a := zmax / 2; add2b := zmax / 4;

          WHEN 3 =>
            ci1 := '1'; add1a := ft;   add1b := ft / 256;
            ci2 := '0'; add2a := ztmp; add2b := zmax / 8;
            se3 := '0'; ci3 := '1'; add3a := ftm1; add3b := ftm2;

          WHEN 4 =>
            ci1 := '0'; add1a := ft; add1b := ftm1;
            ci2 := '0'; add2a := ztmp; add2b := lzmax / 8;
            se3 := '0'; ci3 := '0'; add3a := ysi; add3b := ft;

          WHEN 5 =>
            IF (init = False) THEN
                ci1 := '1'; add1b := ysi; add1a := lymax;
                ci2 := '1'; add2b := ft; add2a := lxmax;
            ELSE
                ci1 := '1'; add1b := ysi; add1a := ymax;
                ci2 := '1'; add2b := ft; add2a := xmax;
            END IF;
            se3 := '0'; ci3 := '1'; add3a := 0; add3b := ft;

          WHEN 6 =>
            ath := xmax / 4;
            ci1 := '1'; add1b := ath; add1a := y0;
            ci2 := '1'; add2a := y0; add2b := y0m2;

          WHEN 7 =>
            IF (init = False) THEN
                ci1 := '1'; add1b := ys; add1a := lzmax;
            ELSE
                ci1 := '1'; add1b := ys; add1a := zmax;
            END IF;
            ci2 := '1'; add2b := RR; add2a := high;
            se3 := '1'; ci3 := '1'; add3a := 0; add3b := fl3;

          WHEN 8 =>
            -- sth1 := ymax * 0.6875;
            ci1 := '0'; add1a := ymax / 2; add1b := ymax / 8;
            -- sth2 := zmax * 0.6875;                          
            ci2 := '0'; add2a := zmax / 2; add2b := zmax / 8;
            se3 := '0'; ci3 := '1'; add3a := i; add3b := indx;

          WHEN 9 =>    
            ci1 := '0'; add1a := sth1; add1b := ymax / 16;
            ci2 := '0'; add2a := sth2; add2b := zmax / 16;
            se3 := '1'; ci3 := '1'; add3a := 0; add3b := RR;

          WHEN 10 =>
            ci1 := '1'; add1b := ysi; add1a := sth1;
            ci2 := '1'; add2b := ys; add2a := sth2;
            se3 := '0'; ci3 := '1'; add3b := RR; add3a := low;

          WHEN 11 =>
            ci1 := '0'; add1a := xmax / 2; add1b := xmax / 4;
            ci2 := '0'; add2a := ymax / 2; add2b := ymax / 4;
            se3 := '1'; ci3 := '1'; add3a := 0; add3b := count;

          WHEN OTHERS =>
        END CASE;

        -- Perform ADD operations
        IF (ci1 = '1') THEN
            nadd1b := not add1b;
            plus(add1a, nadd1b, ci1, sum1, co1);
        ELSE
            plus(add1a, add1b, ci1, sum1, co1);
        END IF;
        sign1 := (sum1 < 0);

        IF (ci2 = '1') THEN   
            nadd2b := not add2b;
            plus(add2a, nadd2b, ci2, sum2, co2);
        ELSE
            plus(add2a, add2b, ci2, sum2, co2);
        END IF;
        sign2 := (sum2 < 0);

        IF (se3 = '0') THEN
            IF (ci3 = '1') THEN   
                nadd3b := not add3b;
                plus(add3a, nadd3b, ci3, sum3, co3);
            ELSE
                plus(add3a, add3b, ci3, sum3, co3);
            END IF;
        ELSE                  
            plus(add3a, add3b, ci3, sum3, co3);
        END IF;
        sign3 := (sum3 < 0);

        CASE step IS
          WHEN 0 =>
            --* wait until sENDer is free *--
            IF (we = Inactive) THEN
                step := step + 1;
                IF (init = False) AND (RRflag = True) THEN
                    xtmp := sum1;
                    ytmp := sum2;
                END IF;
                --* announce ready to read *--
                rdy <= Active;                              
            END IF;

          WHEN 1 =>
            --* wait until sENDer has sent *--
            IF (we = Active) THEN
                step := step + 1;
                --* read the data *--
                ecg1 := data;
                IF (init = False) AND (RRflag = True) THEN
                    xmax  := sum1;
                    ymax  := sum2;
                    lxmax := 0;
                    lymax := 0;
                END IF;
                i := sum3;
            END IF;

          WHEN 2 =>
            -- ft = ftm1 + 0.9965*(ecg1 - ecgm1) ;
            ft   := sum1;
            IF (init = False) AND (RRflag = True) THEN
                ztmp := sum2;
            END IF;
            step := step + 1;

          WHEN 3 =>
            ft   := sum1;
            IF (init = False) AND (RRflag = True) THEN
                ztmp := sum2;
            END IF;
            ysi  := sum3;
            step := step + 1;

          WHEN 4 =>
            ft   := sum1;
            IF (init = False) AND (RRflag = True) THEN
                zmax  := sum2;
                lzmax := 0;
             END IF;
            ysi  := sum3;
            step := step + 1;

          WHEN 5 =>
            IF (init = False) AND (sign1 = True) THEN
                lymax := ysi;
            ELSIF (init = True) AND (sign1 = True) THEN
                ymax := ysi; 
            END IF;
            IF (init = False) AND (sign2 = True) THEN
                lxmax := ft;
            ELSIF (init = True) AND (sign2 = True) THEN
                xmax := ft;
            END IF;

            IF (ft >= 0) THEN
                y0 := ft;
            ELSE -- y0 := -1*ft;
                y0 := sum3;
            END IF;        
            step := step + 1;

          WHEN 6 =>
            IF (sign1 = True) THEN
                y0 := ath;                      
            END IF;
            ys   := sum2;
            step := step + 1;

          WHEN 7 =>
            IF (init = False) AND (sign1 = True) THEN
                lzmax := ys;
            ELSIF (init = True) AND (sign1 = True) THEN
                zmax := ys;
            END IF;
            IF (count = 8) THEN
                fl1 := False; fl2 := False; count := 0;
            END IF;
            IF (init = False) AND (sign2 = True) THEN
                fl3  := sum3;
                RR   := 0;
                ymax := ymax / 2;
                zmax := zmax / 2;
            END IF;
            step := step + 1;
                       
          WHEN 8 =>
            -- sth1 := ymax * 0.6875;
            sth1 := sum1;
            -- sth2 := zmax * 0.6875;                          
            sth2 := sum2;
            init_flag := sign3;
            step := step + 1;

          WHEN 9 =>
            IF (init = False) THEN
                RR := sum3;
            END IF;
            sth1  := sum1;
            sth2  := sum2;
            ecgm1 := ecg1;
            y0m2  := y0m1;
            y0m1  := y0;
            ftm2  := ftm1;
            ftm1  := ft;
            IF (init = True) AND (init_flag = False) THEN
                init := False;
            END IF;
            step  := step + 1;

          WHEN 10 =>
            IF (init = False) AND (sign1 = True) THEN
                fl1   := True;
                count := 0;
            END IF;
            IF (init = False) AND (sign2 = True) THEN
                fl2   := True;
                count := 0;
            END IF;

            RRflag := sign3;
            step   := step + 1;

          WHEN 11 =>
            IF (init = False) AND ((fl1 = True) AND (fl2 = True) AND (RRflag = True)) THEN
                RRpeak <= Active;
                xtmp   := sum1;
                ytmp   := sum2;
                RR     := 0; count := 0; fl1 := False; fl2 := False; fl3 := 0;
            ELSE
                RRflag := False;
                RRpeak <= Inactive;
            END IF;
            IF (init = False) THEN
                fl3o <= fl3;
                RRo  <= RR;
            END IF;
            IF (init = False) AND ((fl1 = True) OR (fl2 = True)) THEN
                count := sum3;
            END IF;
            rdy  <= Inactive;
            step := 0;

          WHEN OTHERS =>
        END CASE;
        
        EXIT WHEN (rc = Active);
    END LOOP;

  END LOOP RESET_LOOP;

  END PROCESS qrs;

END hlsm;
