--**VHDL*************************************************************
--
-- SRC-MODULE : FALSEPATH
-- NAME       : falsepath.vhdl
-- VERSION    : 1.0
--
-- PURPOSE    : Architecture of FALSEPATH benchmark
--
-- LAST UPDATE: Wed May 19 12:35:42 MET DST 1993
--
--*******************************************************************
--
-- Architecture of FALSEPATH
--

PACKAGE types IS
  SUBTYPE  nat16 is integer RANGE 0 TO 65535;
  FUNCTION conv_bit_vector(arg: IN INTEGER;length: integer) RETURN BIT_VECTOR;
END types;

PACKAGE BODY types IS

  --   Unfortunately, VHDL does not provide conversion functions for the buildt in
  --   standard types. Thus, it is necessary to specify a function
  --   to convert integers into bit_vectors. Of course, synthesis
  --   must be able to understand this conversion function.
  --   returns bit_vector with range length-1 downto 0
  --   if integer-number too large then truncating to length
    FUNCTION conv_bit_vector(arg: IN INTEGER; length: integer) RETURN BIT_VECTOR IS
      VARIABLE result: BIT_VECTOR (length-1 DOWNTO 0);
      VARIABLE temp: INTEGER;
      VARIABLE i: integer := 0;
    BEGIN
        IF arg < 0 THEN
            ASSERT false
                REPORT "you could get problems by converting a negative integerto bit_vector"
                SEVERITY WARNING;
            result := not(conv_bit_vector(-arg-1,length));
        ELSE
            temp := arg;
            WHILE temp /= 0 and i <= length-1 LOOP
                IF temp MOD 2 = 1 THEN
                    result(i) := '1';
                ELSE
                    result(i) := '0';
                END IF;
                temp := temp / 2;
                i := i + 1;
            END LOOP;
            IF i > length-1 THEN
                ASSERT false
                   REPORT "length is not extensive enough, bit_vector truncated to length"
                   SEVERITY warning;
            ELSE
                WHILE i  <= length - 1 LOOP
                    result(i) := '0';
                    i := i + 1;
                END LOOP;
            END IF;
        END IF;
        RETURN result;
    END conv_bit_vector;
END types;


USE work.types.ALL;

ENTITY falsepath IS
PORT(reset      : IN bit;          -- Global reset
     clk        : IN bit;          -- Global clock
     stackinp   : IN nat16;
     datainp    : IN nat16;
     offset1inp : IN nat16;
     offset2inp : IN nat16;
     maddr      : OUT nat16);
END falsepath;

ARCHITECTURE algorithm OF falsepath IS
BEGIN
  falsepath: PROCESS
    VARIABLE stack   : nat16;
    VARIABLE data    : nat16;
    VARIABLE offset1 : nat16;
    VARIABLE offset2 : nat16;
    VARIABLE ir      : nat16;
    VARIABLE addr    : nat16;
    VARIABLE p       : bit_vector(0 TO 1);
    VARIABLE z       : bit;
  BEGIN

    maddr <= 0;
  RESET_LOOP: LOOP

    stack := stackinp;
    data  := datainp;
    offset1 := offset1inp;
    offset2 := offset2inp;
    WAIT UNTIL clk'event and clk = '1'; EXIT RESET_LOOP WHEN (reset = '1');
    WAIT UNTIL clk'event and clk = '1'; EXIT RESET_LOOP WHEN (reset = '1');
    ir := data + 1;
    p  := conv_bit_vector(ir,2);
    CASE p IS
      WHEN "00" =>
        addr := stack + offset1;
        z := p(0);
      WHEN "01" =>
        addr := offset1;
        z := p(1);
      WHEN "10" =>
        addr := stack + 1;
        z := p(1);
      WHEN "11" =>
        addr := 0;
        z := p(0);
    END CASE;
    IF z = '1' THEN
        maddr <= addr + offset2;
    ELSE
        maddr <= addr;
    END IF;

  END LOOP RESET_LOOP;

  END PROCESS falsepath;
END algorithm;	 	 
