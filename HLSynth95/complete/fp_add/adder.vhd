----------------------------------------------------------------------------
--
-- Floating Point Adder/Subtractor Benchmark: VHDL Code
--
-- Source:  Patterson, David A., and Hennessy, John L.,  "Computer 
--	         architecture: a quantitative approach".  San Mateo, CA: Morgan
--		 Kaufman Publishers, 1990,  Appendix A, p. 12-20
--  
-- Author: Bob McIlhenny 
--	   University of California, Irvine, CA 92717
--
--    based on an original design by:
--    Marc Rose, Intel Corporation, Floating Point Adder/Subtractor Version 3
--         
-- Written on June 9, 1993
--
-- Modified by Jesse Pan on Nov 18, 1993
--
-- Verification Information:
--
--                  Verified     By whom?           Date         Simulator
--                  --------   ------------        --------     ------------
--  Syntax            yes     Jesse Pan	           18 Nov 93    Synopsys
--  Functionality     yes     Jesse Pan	           18 Nov 93    Synopsys
-------------------------------------------------------------------------------

PACKAGE fpadd_pkg is

    constant MNT_LENGTH    : INTEGER := 24;   -- including hidden "1" bit

    constant ADDEND_LENGTH : INTEGER := MNT_LENGTH + 4;  
	-- 3 bits for precision, 1 for overflow

    constant MAX_EXP : INTEGER := 2#11111111#;

    subtype mnt    is bit_vector(MNT_LENGTH - 1 downto 0);    

    subtype addend is bit_vector(ADDEND_LENGTH - 1 downto 0);

    subtype mantissa is bit_vector((MNT_LENGTH - 1) -1 downto 0);
	
    subtype exp is integer range 0 to MAX_EXP;

    type op_type is (idle, add, subtract);

END fpadd_pkg;

----------------------------------------------------------------

USE work.fpadd_pkg.all;
--LIBRARY std_developerskit;
--USE     std_developerskit.std_regpak.all;

ENTITY fau is 
    PORT (
	  clk       : in bit;
	  op1_sign  : in bit;
	  op1_exp   : in exp;
	  op1_mant  : in mantissa;
	  op2_sign  : in bit;
	  op2_exp   : in exp;
	  op2_mant  : in mantissa;
          res_sign  : out bit;
	  res_exp   : out exp;
          res_mant  : out mantissa;
	  operation : in op_type := idle;
	  flags : out bit_vector(3 downto 0) := "0000");  

-- Note: The flags vector is used to indicate special result cases; when the
--       case is met, the bit is set to 1, otherwise 0
--       Bit 3 --> Zero result
--       Bit 2 --> Positive Infinity result
--       Bit 1 --> Negative Infinity result
--       Bit 0 --> NaN result
--
-- The representation for input operands and the result is IEEE standard as
-- shown below, with a 1-bit sign, an 8-bit exponent biased 127, and a 23-bit
-- mantissa with a "hidden 1". 
--
--        ______________________________
--        | sign | exponent | mantissa |
--        |______|__________|__________|
--          1 bit   8 bits     23 bits 

END fau;

----------------------------------------------------------------

ARCHITECTURE fau_behavior of fau is


   -- Bit vector concatenation function.
FUNCTION "&" (bv1, bv2 : bit_vector) RETURN bit_vector IS 
  variable result_length : integer := bv1'length + bv2'length;
  variable bv_out : bit_vector(result_length - 1 downto 0);
  BEGIN
    bv_out((bv2'length-1) downto 0) := bv2;
    bv_out(result_length-1 downto bv2'length) := bv1; 
    RETURN(bv_out);
  END;


FUNCTION bit_complement (b_in : bit) RETURN bit IS
  variable result : bit;
  BEGIN
    IF b_in = '0' THEN result := '1';
    ELSE result := '0';
    END IF;
    RETURN(result);
  END bit_complement;


FUNCTION flip_bits (bv_in : bit_vector) RETURN bit_vector IS
  variable bv_out : bit_vector(bv_in'length - 1 downto 0);
  BEGIN
    bv_out := bv_in;
    FOR i in bv_out'range LOOP
	bv_out(i) := bit_complement(bv_in(i));
    END LOOP;
    RETURN(bv_out);
  END flip_bits;
    


PROCEDURE left_shift (
    reg_val : inout bit_vector;
    shift_amt : in natural) is

  BEGIN
    FOR i in reg_val'range LOOP
        IF i >= shift_amt THEN reg_val(i) := reg_val(i - shift_amt);
	ELSE reg_val(i) := '0';
	END IF;
    END LOOP;
  END left_shift;



PROCEDURE right_shift (reg_val: inout bit_vector; shift_amt: in natural) IS
  variable i : integer;
  BEGIN
    FOR i in reg_val'reverse_range LOOP
	IF i < (reg_val'length - shift_amt) THEN 
 	    reg_val(i) := reg_val(i + shift_amt);
        ELSE 
	    reg_val(i) := '0';
        END IF;
    END LOOP;
  END right_shift;



    -- Extends the precision by three extra bits.  These are the
    -- guard, round, and sticky bits.
PROCEDURE form_extended_operand (
    reg_val      : in mnt;
    extended_reg : out addend;
    shift_amt : in natural) is

  variable sticky : bit;
  variable  i : integer;
  variable  tmp_reg : addend;

  BEGIN
    sticky   := '0';
    FOR i in 0 to shift_amt - 3 LOOP
	IF reg_val(i) = '1' THEN sticky := '1';
	END IF;
    END LOOP;

    tmp_reg := "0" & reg_val & "000";
    right_shift(tmp_reg, shift_amt);
    extended_reg := tmp_reg;
    extended_reg(0) := sticky;
  END form_extended_operand;



PROCEDURE swap_exponents (
	in1 : inout exp;
	in2 : inout exp) is

  variable tmp : exp;

  BEGIN
    tmp := in1;
    in1 := in2;
    in2 := tmp;
  END swap_exponents;
  

PROCEDURE swap_mantissas (
	in1 : inout mnt;
	in2 : inout mnt) is

  variable tmp : mnt;

  BEGIN
    tmp := in1;
    in1 := in2;
    in2 := tmp;
  END swap_mantissas;



PROCEDURE swap_bits (
	in1 : inout bit;
	in2 : inout bit) is

  variable tmp : bit;

  BEGIN
    tmp := in1;
    in1 := in2;
    in2 := tmp;
  END swap_bits;


   -- Operates on unsigned numbers.
   -- Shifts the number so that the left-most '1' becomes the most significant
   -- bit.
PROCEDURE normalize (
    prelim_result : inout bit_vector;
    exponent   : inout exp ) is
   -- Shift prelim_result to left until normalized. Normalized when the value 
   -- to the left of the decimal point is 1.
   -- Adjust the exponent value accordingly. 

  variable i, count_from_left : integer;
  variable shift_out : bit;
  variable found_one : boolean := false;

  BEGIN
	count_from_left := 0;
	FOR i in prelim_result'left downto prelim_result'right LOOP
	    IF (not found_one) and (prelim_result(i) = '0') THEN
	        count_from_left := count_from_left + 1;
	    ELSE
	        found_one := true;
	    END IF;
	END LOOP;   -- $BSYNTH(definite_unroll);
	IF (count_from_left > 0) THEN
	    left_shift(prelim_result, count_from_left);
	    IF (exponent - count_from_left >= 0) THEN
		exponent := exponent - count_from_left;
	    END IF;	
	END IF;
  END normalize;


    -- Note: This assumes that the two input bitvectors are the same length
PROCEDURE bv_add (
    result : out bit_vector;
    in1 : in  bit_vector;
    in2 : in  bit_vector;
    overflow : out boolean) is

  variable i     : integer;
  variable carry_in  : bit := '0';
  variable carry_out : bit;

  BEGIN
    FOR i in in1'reverse_range LOOP
	IF carry_in = '0' THEN
	    IF in1(i) = in2(i) THEN result(i) := '0';
	    ELSE result(i) := '1';
	    END IF;
	    carry_out := in1(i) AND in2(i);
	ELSE
	    IF in1(i) = in2(i) THEN result(i) := '1';
	    ELSE result(i) := '0';
	    END IF;
	    carry_out := in1(i) OR in2(i);
	END IF;

	-- Note, the overflow check below should be performed only for the
	-- highest order bit.  However, the behavior was easier to write
	-- this way, and the outcome is the same.  If we were synthesizing
	-- the adder itself, we would have to watch out for this type of
	-- description.
	IF carry_out = carry_in THEN overflow := false;
	ELSE overflow := true;
	END IF;
	carry_in := carry_out;

  END LOOP;
  END bv_add;


FUNCTION twos_complement(bv_in: in bit_vector) RETURN bit_vector IS
    variable bv_out : bit_vector(bv_in'length-1 downto 0);
    variable i : integer;
    variable carry : boolean := true;
	
    BEGIN
	bv_out := NOT(bv_in);
	FOR i IN bv_in'reverse_range LOOP
	    IF carry THEN
		IF bv_out(i) = '0' THEN
		    bv_out(i) := '1';
		    carry := false;
		ELSE
		    bv_out(i) := '0';
		END IF;
	    END IF;
	END LOOP;		
	RETURN(bv_out);
    END twos_complement;	

-- IEEE 754 standard, default rounding mode, round to nearest/even 
PROCEDURE round_result (
    prelim_result : inout bit_vector;
    exp_result : inout exp) is

    variable r : bit;          -- round bit
    variable s : bit;          -- sticky bit

    variable i : integer;	
    variable carry: boolean := true;	

    BEGIN
	-- If any of the round bit or sticky bit is '0' then no rounding.
	--
	-- Assign the result of (r OR s) to s 
	-- as reference Patterson and Hennesy "Computer architecture" appendix A
	-- page A-18
 
	IF (prelim_result(1)='1') or (prelim_result(0)='1') then 
		s:='1';
	ELSE    s:='0';
	END IF;
	
	-- assign the previous guard bit to round bit
	r:=prelim_result(2);
	
	-- condition for not rounding
		-- if the round bit r=0 then do not round result 
	IF  r='0'  then 
	    RETURN;

		-- In the case of tie, ie r=1 and s=0 then round to 
		-- nearest even number. 
  		-- Therefoer, if LSB is even do not round the result.
	ELSIF (s='0') and (prelim_result(3)='0') then
	    RETURN; 
	END IF;

		-- round result, add 1 to LSB, for the other case

	if prelim_result((ADDEND_LENGTH - 2) - 1 downto 3) =   
		"11111111111111111111111" then             --overflow   
	    prelim_result((ADDEND_LENGTH -2) -1  downto 3) := 
		"00000000000000000000000";
	    exp_result := exp_result + 1;
	    RETURN;
        end if;
	
	-- round result
	FOR i IN 3 to ((ADDEND_LENGTH-2)-1) LOOP
	    IF carry THEN
		IF prelim_result(i) = '0' THEN
		    prelim_result(i) := '1';
		    carry := false;
		ELSE
		    prelim_result(i) := '0';
		END IF;
	    END IF;	
	END LOOP;
	RETURN;
    END round_result;

	
BEGIN
main_proc : process
    variable mnt1          : mnt;         -- @BSYNTH(reg)
    variable mnt2          : mnt;         -- @BSYNTH(reg)
    variable exp1          : exp;         -- @BSYNTH(reg)
    variable exp2          : exp;         -- @BSYNTH(reg)
    variable sign1         : bit;
    variable sign2         : bit;
    variable sign_result   : bit;
    variable exp_diff      : integer;
    variable addend1       : addend;
    variable addend2       : addend;
    variable prelim_result : addend;
    variable overflow      : boolean;
    variable exp_result    : exp;
    variable true_subtract : boolean;
    variable swapped       : boolean;
    variable pos_inf_flag1 : boolean;
    variable neg_inf_flag1 : boolean;
    variable pos_inf_flag2 : boolean;
    variable neg_inf_flag2 : boolean;
    variable nan_flag      : boolean;
    variable special_flag  : boolean;

    alias zero_res    : bit is flags(3);
    alias pos_inf_res : bit is flags(2);
    alias neg_inf_res : bit is flags(1);
    alias nan_res     : bit is flags(0);

  BEGIN
    WAIT on clk, operation;
    IF (clk = '1' and operation /= idle) THEN

        -- Step 1: Load operands and set flags
        exp1 := op1_exp;
        exp2 := op2_exp;

	    -- Add the 1 (hidden 1) assumed in the representation.
            -- Actually, should not do this for any input which is 
            -- denormalized. ( Both input assumed to be nomalized. )

	IF (exp1 = 0) AND (op1_mant = "00000000000000000000000") THEN
	    mnt1 := "0" & op1_mant;
	    exp1 := exp2;
	ELSE
            mnt1 := "1" & op1_mant;
        END IF;

	IF (exp2 = 0) AND (op2_mant = "00000000000000000000000") THEN
            mnt2 := "0" & op2_mant;
            exp2 := exp1;
	ELSE
	    mnt2 := "1" & op2_mant;
	END IF;	

	sign1 := op1_sign;
        sign2 := op2_sign;

        pos_inf_flag1 := false;
        neg_inf_flag1 := false;
        pos_inf_flag2 := false;
        neg_inf_flag2 := false;
        nan_flag      := false;
        special_flag  := false;
	flags         <= "0000";

        -- Step 2: Check for special inputs ( +/- Infinity,  NaN) 
        IF (op1_exp = MAX_EXP) THEN
	    exp_result := exp1;
	    special_flag := true;
	    IF op1_mant = "00000000000000000000000" THEN
	        IF op1_sign = '0' THEN
		    pos_inf_flag1 := true;
	        ELSE 
		    neg_inf_flag1 := true;
		END IF;
	    ELSE 
		nan_flag := true;
	    END IF;
	END IF;

	IF (op2_exp = MAX_EXP) then
	    exp_result := exp2;
	    special_flag := true;
	    IF op2_mant = "00000000000000000000000" THEN
	        IF op2_sign = '0' THEN
		    pos_inf_flag2 := true;
	        ELSE 
		    neg_inf_flag2 := true;
		END IF;
	    ELSE 
		nan_flag := true;
	    END IF;    
	END IF;


	-- Step 3: Compare exponents.  Swap the operands of exp1 < exp2
        --         or of (exp1 = exp2 AND mnt1 < mnt2)
	swapped  := false;
	IF (exp1 < exp2 OR (exp1 = exp2 AND mnt1 < mnt2)) THEN
	    swap_exponents(exp1, exp2);
	    swap_mantissas(mnt1, mnt2);
	    swap_bits(sign1, sign2);
	    swapped := true;
	END IF;
	exp_diff := exp1 - exp2;
	exp_result := exp1;
	sign_result := sign1;

	IF (exp_diff > (ADDEND_LENGTH - 2)) THEN
       	    ASSERT (exp_diff <= (ADDEND_LENGTH -2)) 
	        REPORT "Precision lost in exponent difference"
	    	      SEVERITY warning;
	    exp_diff := ADDEND_LENGTH -2;
	END IF;


	-- Step 4: Shift the mantissa corresponding to the smaller exponent, 
        -- and extend precision by three bits to the right.
	IF (exp_diff > 0) THEN
	    addend1 := "0" & mnt1 & "000";
	    form_extended_operand(mnt2, addend2, exp_diff);
	ELSE
	    addend1 := "0" & mnt1 & "000";
	    addend2 := "0" & mnt2 & "000";
	END IF;


	--  Step 5: Add or subtract the mantissas.
	IF (operation = subtract) THEN
	    IF swapped THEN
	        sign_result := NOT(sign_result);
	    END IF;
	    IF (sign1 = sign2) THEN
 	        true_subtract := true;
	    ELSE 
	        true_subtract := false;
	    END IF;
	ELSIF (sign1 /= sign2 and operation = add) THEN
	    true_subtract := true;
	ELSE
	    true_subtract := false;
	END IF;

	IF true_subtract THEN
	    addend2 := twos_complement(addend2);
	END IF;
	
	IF (special_flag = false) THEN
	    bv_add(prelim_result, addend1, addend2, overflow);
	END IF;


        -- Step 6: Normalize the result.
	IF (special_flag = false) THEN
	    IF (prelim_result = "0000000000000000000000000000") AND 
		(overflow = false) THEN
	        sign_result := '0';
	        exp_result:= 0;
		zero_res <= '1';
     	    ELSIF overflow THEN
	        IF exp_result >= (MAX_EXP - 1) THEN
		    prelim_result := "0000000000000000000000000000";
		    exp_result := MAX_EXP;
		    pos_inf_res <= '1';
	        ELSE
        	    exp_result := exp_result + 1;
                    right_shift(reg_val => prelim_result, shift_amt => 1);
	        END IF; 
	    ELSE
    	    -- Shift left until normalized.  Normalized when the value to the 
            -- left of the decimal point is 1.
	  
                normalize(prelim_result((ADDEND_LENGTH-2) downto 0), 
			  exp_result);
	    END IF; 
	END IF; 


        -- Step 7: Round the result.
        IF (special_flag = false) THEN
		round_result(prelim_result, exp_result);	
	END IF;


        -- Step 8: Put sum onto output.
	IF (special_flag = false) THEN
		res_sign <= sign_result;
		res_exp  <= exp_result;
		res_mant <= prelim_result((ADDEND_LENGTH - 2) - 1 downto 3);  
                -- leaves off "hidden 1" and most significant bit(reserved for 
                -- overflow earlier)
	ELSIF (nan_flag = true) THEN
		res_sign <= '0';
		res_exp <= exp1;
		res_mant <= mnt1(22 downto 0);
		nan_res <= '1';
--  The rest of the code is to set the flag for the boundry conditions.
-- 
--  Following truth table is for the boundry condition for setting the Flags
--  "ctrl" refer to the conditional control for the hightest levels of ELSIF
--  
--  pos_inf_f1  pos_inf_f2  neg_inf_f1  neg_inf_f2  add  sub  Zero  +INF  -INF
--  **********  **********  **********  **********  ***  ***  ****  ****  ****
--  ctrl=1          1            0           0       0    1    1      0     0
--  ctrl=1          0            0           1       1    0    1      0     0
--  ctrl=1          0            0           0       X    X    0      1     0
--
--      0       ctrl=1           1           0       1    0    1      0     0
--      0       ctrl=1           0           0       0    1    0      0     1
--      0       ctrl=1           1           0       0    1    0      0     1
--
--      0           0        ctrl=1          1       0    1    1      0     0
--      0           0        ctrl=1          1       1    0    0      0     1
--      0           0        ctrl=1          0       0    1    0      0     1
--
--      0           0            0       ctrl=1      0    1    0      1     0
--      0           0            0       ctrl=1      1    0    0      0     1
--
-- 
    	ELSIF (pos_inf_flag1 = true) THEN
		res_sign <= '0';
	        res_mant <= mnt1(22 downto 0);
	        IF (pos_inf_flag2 = true) AND (operation = subtract) THEN
		    res_exp <= 0;
		    zero_res <= '1';	
	    	ELSIF (neg_inf_flag2 = true) AND (operation = add) THEN
		    res_exp <= 0;
		    zero_res <= '1';
	    	ELSE
		    res_exp <= MAX_EXP;
		    pos_inf_res <= '1';
            	END IF;
    	ELSIF (pos_inf_flag2 = true) THEN
	        res_mant <= op2_mant;
	        res_exp <= MAX_EXP;
	        IF (neg_inf_flag1 = true) AND (operation = add) THEN
		    res_exp <= 0;
		    res_sign <= '0';
		    zero_res <= '1';
		ELSIF (operation = subtract) THEN
		    res_sign <= '1';
		    neg_inf_res <= '1';
	        ELSE
		    res_sign <= '0';
		    pos_inf_res <= '1';
                END IF;
        ELSIF (neg_inf_flag1 = true) THEN
	        res_sign <= '1';
	        res_mant <= op1_mant;
	        IF (neg_inf_flag2 = true) AND (operation = subtract) THEN
		    res_exp <= 0;
		    res_sign <= '0';
		    zero_res <= '1';		
	        ELSE
		    res_exp <= MAX_EXP;
		    neg_inf_res <= '1';
                END IF;
       ELSIF (neg_inf_flag2 = true) THEN
	        res_mant <= op2_mant;
	        res_exp <= MAX_EXP;
	        IF (operation = subtract) THEN
		    res_sign <= '0';
		    pos_inf_res <= '1';
	        ELSE
		    res_sign <= '1';
		    neg_inf_res <= '1';
                END IF;
      END IF;

  END IF;

END PROCESS;

END fau_behavior;
