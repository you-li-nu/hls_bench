--**VHDL*************************************************************
--
-- SRC-MODULE : QRS
-- NAME       : qrs_sys.vhdl
-- VERSION    : 1.1
--
-- PURPOSE    : Architecture of QRS Chip (system description)
--
-- LAST UPDATE: Thu Feb 11 19:51:45 1993
--
--*******************************************************************
--
-- Architecture of QRS
--

USE work.qrs_types.all;

ARCHITECTURE system OF qrs IS
BEGIN
  qrs: PROCESS

    CONSTANT    ACTIVE           : boolean := false;
    CONSTANT    INACTIVE         : boolean := true;

    VARIABLE   ft, ftm1, ftm2, ecgm1, ecg1, ysi    : int16;
    VARIABLE   ymax,xmax,y0,ath,ys,y0m2,zmax,y0m1  : int16;
    VARIABLE   sth1,sth2,lxmax,lymax,lzmax         : int16;
    VARIABLE   low,high                            : int16;
    VARIABLE   count, indx, RR                     : int16;
    VARIABLE   fl3                                 : nat2;
    VARIABLE   fl1, fl2                            : boolean;

  begin
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

    WAIT until we = INACTIVE;                --   wait until sender is free
    rdy <= Active;                           --   announce ready to read
    WAIT until we = ACTIVE;                  --   wait until sender has sent
    low := data;                             --   read data
    rdy <= Inactive;                         --   disable ready to read     

    WAIT until we = INACTIVE;                --   wait until sender is free 
    rdy <= Active;                           --   announce ready to read    
    WAIT until we = ACTIVE;                  --   wait until sender has sent
    high := data;                            --   read data                 
    rdy  <= Inactive;                        --   disable ready to read     

    WAIT until we = INACTIVE;                --   wait until sender is free 
    rdy <= Active;                           --   announce ready to read    
    WAIT until we = ACTIVE;                  --   wait until sender has sent
    indx := data;                            --   read data                 
    rdy  <= Inactive;                        --   disable ready to read     

    WAIT until we = INACTIVE;                --   wait until sender is free 
    rdy <= Active;                           --   announce ready to read    
    WAIT until we = ACTIVE;                  --   wait until sender has sent
    ftm2 := data;                            --   read data                 
    rdy  <= Inactive;                        --   disable ready to read     

    WAIT until we = INACTIVE;                --   wait until sender is free 
    rdy <= Active;                           --   announce ready to read    
    WAIT until we = ACTIVE;                  --   wait until sender has sent
    ftm1  := data;                           --   read data                 
    ecgm1 := ftm1;    

    init: FOR i IN 1 TO indx LOOP            --   initialization loop

        rdy <= Inactive;                     --   disable ready to read
        WAIT until we = INACTIVE;            --   wait until sender is free 
        rdy <= Active;                       --   announce ready to read    
        WAIT until we = ACTIVE;              --   wait until sender has sent
        ecg1 := data;                        --   read data                 

        --   ft := ftm1 + 0.9965*(ecg1 - ecgm1)
        ft  := ftm1 + (ecg1 - ecgm1) - ((ecg1 - ecgm1)/256);
        ysi := ft - ftm2;
	IF (ysi > ymax) THEN ymax := ysi; END IF;
	IF ( ft > xmax) THEN xmax := ft;  END IF;
      	IF (ft > 0) THEN y0 := ft;  END IF;
	IF (ft < 0) THEN y0 := -ft; END IF;
	ath := xmax / 4;
	IF ( ath > y0) THEN y0 := ath; END IF;
	ys := y0 - y0m2;
	IF (ys > zmax) THEN zmax := ys; END IF;
	ftm2  := ftm1;
	ftm1  := ft;
	ecgm1 := ecg1;
	y0m2  := y0m1;
	y0m1  := y0;
        --   sth1 = ymax * 0.6875;
        sth1  := (ymax / 2) + (ymax / 8) + (ymax / 16);
        --   sth2 = zmax * 0.6875; */
        sth2  := (zmax / 2) + (zmax / 8) + (zmax / 16);

    END LOOP init;

    regular : LOOP 

        IF (ysi > sth1) THEN
	    fl1   := true;
	    count := 0;
        END IF;
        IF (ys > sth2) THEN
            fl2   := true;
            count := 0;
        END IF; 
	IF ((fl1 = true) AND (fl2 = true) AND (RR > low)) THEN
            RRpeak <= Active;
            xmax  := (xmax / 2) + (xmax / 4) + (xmax / 8) + (lxmax / 8);
            ymax  := (ymax / 2) + (ymax / 4) + (ymax / 8) + (lymax / 8);
            zmax  := (zmax / 2) + (zmax / 4) + (zmax / 8) + (lzmax / 8);
            RR    := 0;
            count := 0;
            fl1   := false;
            fl2   := false;
            fl3   := 0;
            lxmax := 0;
            lymax := 0;
            lzmax := 0;
        ELSE
            RRpeak <= Inactive;
        END IF;
            
        IF ((fl1 = true) OR  (fl2 = true)) THEN
            count := count + 1;
        END IF;

        fl3o  <= fl3;
        RRo   <= RR;
        
        rdy <= Inactive;                     --   disable ready to read
        WAIT until we = INACTIVE;            --   wait until sender is free 
        rdy <= Active;                       --   announce ready to read    
        WAIT until we = ACTIVE;              --   wait until sender has sent
        ecg1 := data;                        --   read data                 

        --	ft  := ftm1 + 0.9965*(ecg1 - ecgm1)
        ft  := ftm1 + (ecg1 - ecgm1) - ((ecg1 - ecgm1)/256);
        ysi := ft - ftm2;
        IF (ysi > lymax) THEN lymax := ysi; END IF;
        IF ( ft > lxmax) THEN lxmax := ft;  END IF;
        IF (ft > 0) THEN y0 := ft;  END IF; 
        IF (ft < 0) THEN y0 := -ft; END IF;
        ath := (xmax / 4);
        IF (y0 < ath) THEN y0 := ath; END IF;
        ys := y0 - y0m2;
        IF (ys > lzmax) THEN lzmax := ys; END IF;
        IF (count = 8) THEN
            fl1   := false;
            fl2   := false;
            count := 0;
        END IF;
        IF (RR > high) THEN
            fl3  := fl3 + 1;
            RR   := 0;
            ymax := (ymax / 2);
            zmax := (zmax / 2);
        END IF;
--      sth1 := ymax *0.6875
        sth1 := (ymax / 2) + (ymax / 8) + (ymax / 16);
--      sth2 := zmax * 0.6875
        sth2 := (zmax / 2) + (zmax / 8) + (zmax / 16);
        RR   := RR + 1;
        ecgm1 := ecg1;
        y0m2  := y0m1;
        y0m1  := y0;
        ftm2  := ftm1;
        ftm1  := ft;

    END LOOP regular;

  END PROCESS qrs;
    
END system;
--
-- End of Architecture
--

