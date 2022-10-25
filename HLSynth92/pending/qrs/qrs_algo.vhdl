--**VHDL*************************************************************
--
-- SRC-MODULE : QRS
-- NAME       : qrs_algo.vhdl
-- VERSION    : 1.1
--
-- PURPOSE    : Architecture of QRS Chip (algorithmic description)
--
-- LAST UPDATE: Thu Feb 11 19:51:45 1993
--
--*******************************************************************
--
-- Architecture of QRS
--

USE work.qrs_types.all;

ARCHITECTURE algorithm OF qrs IS
BEGIN
  qrs: PROCESS

    CONSTANT Active   : boolean := FALSE;  -- Low active inputs and outputs!
    CONSTANT Inactive : boolean := TRUE;   -- Low active inputs and outputs!

    VARIABLE  ft, ftm1, ftm2, ecgm1, ecg1            : int16;
    VARIABLE  ysi,ymax,xmax,y0,ath,ys,y0m2,zmax,y0m1 : int16;
    VARIABLE  sth1,sth2,lxmax,lymax,lzmax            : int16;
    VARIABLE  low, high                              : int16;
    VARIABLE  h                                      : int16;
    VARIABLE  i, indx, RR                            : int16;
    VARIABLE  count                                  : nat4;
    VARIABLE  fl3                                    : nat2;
    VARIABLE  init, fl1, fl2, RRpeak_tmp             : boolean;

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
    RR     := 0;         
    lymax  := 0;
    lzmax  := 0;
    lxmax  := 0;
    fl3    := 0;
    fl1    := False;
    fl2    := False;
    count  := 0;

  RESET_LOOP : LOOP 

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
    indx := data;

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
    ftm2 := data;

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
    ftm1 := data;

    ecgm1 := ftm1;

    i := 0;
    init := True;

    -- start regular detection routine or initialize
    LOOP 

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
        ecg1 := data;

	    -- ft = ftm1 + 0.9965*(ecg1 - ecgm1) ;
        h := (ecg1 - ecgm1);
        ft := ftm1 + h - (h / 256);  -- 1/256
        ysi := ft - ftm2;
        IF (init = False) AND (ysi > lymax) THEN
            lymax := ysi;
        ELSIF (init = True) AND ( ysi > ymax) THEN
            ymax := ysi; 
        END IF;
        IF (init = False) AND (ft > lxmax) THEN
            lxmax := ft;
        ELSIF (init = True) AND ( ft > xmax) THEN
            xmax := ft;
        END IF;
        IF (ft > 0) THEN
            y0 := ft;
        ELSE -- y0 := -1*ft;
            y0 := -ft;
        END IF;
        ath := xmax / 4;
        IF ( ath > y0) THEN
            y0 := ath;                      
        END IF;
        ys := y0 - y0m2;
        IF (init = False) AND (ys > lzmax) THEN
            lzmax := ys;
        ELSIF (init = True) AND (ys > zmax) THEN
            zmax := ys;
        END IF;
        IF (count = 8) THEN
            fl1 := False; fl2 := False; count := 0;
        END IF;
        IF (init = False) AND (RR > high) THEN
            fl3 := fl3 + 1;
            RR := 0;
            ymax := ymax / 2;
            zmax := zmax / 2;
        END IF;

        -- sth1 := ymax * 0.6875;
        sth1 := (ymax / 2) + (ymax / 8) + (ymax / 16);
        -- sth2 := zmax * 0.6875;                          
        sth2 := (zmax / 2) + (zmax / 8) + (zmax / 16);

        IF (init = False) THEN
            RR := RR + 1;
        END IF;

        ecgm1 := ecg1;
        y0m2 := y0m1;
        y0m1 := y0;
        ftm2 := ftm1;
        ftm1 := ft;

        i := i + 1;
        IF (init = True) AND (i = indx) THEN
            init := False;
        END IF;

        IF (init = False) AND (ysi > sth1) THEN
            fl1 := True;
            count := 0;
        END IF;
        IF (init = False) AND (ys > sth2) THEN
            fl2 := True;
            count := 0;
        END IF;

        IF (init = False) AND ((fl1 = True) AND (fl2 = True) AND (RR > low)) THEN
            RRpeak_tmp := Active;
            xmax := (xmax / 2) + (xmax / 4) + (xmax / 8) + (lxmax / 8);
            ymax := (ymax / 2) + (ymax / 4) + (ymax / 8) + (lymax / 8);
            zmax := (zmax / 2) + (zmax / 4) + (zmax / 8) + (lzmax / 8);
            RR := 0; count := 0; fl1 := False; fl2 := False; fl3 := 0;
            lxmax := 0; lymax := 0; lzmax := 0;
        ELSE
            RRpeak_tmp := Inactive;
        END IF;
        IF (init = False) AND ((fl1 = True) OR (fl2 = True)) THEN
            count := count + 1;
        END IF;

        WAIT UNTIL clk = '1';EXIT RESET_LOOP WHEN (reset = '1');
        WAIT UNTIL clk = '1';EXIT RESET_LOOP WHEN (reset = '1');
        WAIT UNTIL clk = '1';EXIT RESET_LOOP WHEN (reset = '1');
        WAIT UNTIL clk = '1';EXIT RESET_LOOP WHEN (reset = '1');
        WAIT UNTIL clk = '1';EXIT RESET_LOOP WHEN (reset = '1');
        WAIT UNTIL clk = '1';EXIT RESET_LOOP WHEN (reset = '1');
        WAIT UNTIL clk = '1';EXIT RESET_LOOP WHEN (reset = '1');
        WAIT UNTIL clk = '1';EXIT RESET_LOOP WHEN (reset = '1');
        WAIT UNTIL clk = '1';EXIT RESET_LOOP WHEN (reset = '1');
        WAIT UNTIL clk = '1';EXIT RESET_LOOP WHEN (reset = '1');
        
        IF (init = False) THEN
            fl3o   <= fl3;
            RRo    <= RR;
            RRpeak <= RRpeak_tmp;
        END IF;

        EXIT WHEN (rc = Active);
    END LOOP;

  END LOOP RESET_LOOP;

  END PROCESS qrs;

END algorithm;
