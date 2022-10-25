----------------------------------------------------------------------------
--
-- Floating Point Multiplier Benchmark: VHDL Code
--
-- Source:  Patterson, David A., and Hennessy, John L.,  "Computer 
--	         architecture: a quantitative approach".  San Mateo, CA: Morgan
--		 Kaufman Publishers, 1990,  Appendix A, p. 3-22
--  
-- Author: Jesse Pan
--	   Department of Electrical and Computer Engineering
--	   University of California, Irvine, CA 92717
--
-- Acknowledgement: Special thanks to Dr. Tomas Lang's advice on this benchmark
--         
-- Written on Feb 01, 1994
--
-- Verification Information:
--
--                  Verified     By whom?           Date         Simulator
--                  --------   ------------        --------     ------------
--  Syntax            yes     Jesse Pan	           01 Feb 94    Synopsys
--  Functionality     yes     Jesse Pan	           01 Feb 94    Synopsys
-------------------------------------------------------------------------------

PACKAGE fpmult_pkg is

    constant MNT_LENGTH    : INTEGER := 24;   -- including hidden "1" bit

    constant PRODUCT_LENGTH : INTEGER := 48;  -- twice of mantissa length 

    constant MAX_EXP : INTEGER := 2#11111111#;

    subtype mnt    is bit_vector(MNT_LENGTH - 1 downto 0);    

    subtype product is bit_vector(PRODUCT_LENGTH - 1 downto 0);

    subtype mantissa is bit_vector((MNT_LENGTH - 1) -1 downto 0);
	
    subtype exp is integer range 0 to MAX_EXP;

    type op_type is (idle, multiply);

END fpmult_pkg;

----------------------------------------------------------------

USE work.fpmult_pkg.all;

ENTITY fmu is 
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

END fmu;

-- ***************************************************************************
ARCHITECTURE fmu_behavior of fmu is
------------------------------------------------------------------------------
FUNCTION shift_left1(bv  : bit_vector) RETURN bit_vector IS
VARIABLE temp: bit_vector(bv'RANGE);	
BEGIN
	temp:= bv;
	FOR i IN temp'high DOWNTO temp'low+1 LOOP
		temp(i):=temp(i-1);
	END LOOP;
	temp(temp'LOW):='0';		
	RETURN (temp);
END shift_left1;
------------------------------------------------------------------------------
PROCEDURE bit_add(    		-- add operation does bv1+bv2 --> bv2
	bv1 : in bit_vector; 
	bv2 : in bit_vector;
	result: out bit_vector;
	Cout: out bit) IS
	VARIABLE Ci,Co : bit;
	VARIABLE i: integer:=0;
BEGIN
	Co :='0';
	FOR i IN bv1'REVERSE_RANGE LOOP 
	    Ci:=Co;
       	    IF Ci='1' THEN
		IF bv1(i)=bv2(i) THEN result(i):= '1';
		ELSE result(i):= '0';
		END IF; 
		Co := bv1(i) OR bv2(i);
	    ELSE
		IF bv1(i)=bv2(i) THEN result(i):='0';
		ELSE result(i):='1';
		END IF;
		Co:=bv1(i) AND bv2(i);
	    END IF;
	END LOOP;
	Cout :=Co;
END bit_add;
------------------------------------------------------------------------------
PROCEDURE shift_right1(
	Cout: in bit; 
	bv  : inout bit_vector) IS
VARIABLE temp: bit_vector(bv'RANGE);	
BEGIN
	temp:= bv;
	FOR i IN temp'LOW TO temp'HIGH-1 LOOP
		temp(i):=temp(i+1);
	END LOOP;
	temp(temp'high):=Cout;
	bv:= temp;
END shift_right1;
------------------------------------------------------------------------------
-- IEEE 754 standard, default rounding mode, round to NEAREST/EVEN
PROCEDURE round_result (
    round      : in bit;
    sticky     : in bit;
    prelim_result : inout bit_vector;
    exp_result : inout integer) IS

variable carry: boolean := true;
BEGIN
        -- condition for not rounding
                -- if the round bit r=0 then do not round result
                -- In the case of tie, ie r=1 and s=0 then round to
                -- nearest even number.
                	-- Therefore, if LSB is even do not round the result,
                	-- else, add 1 to LSB, for the other case.
	IF round = '0' THEN
		RETURN;
	ELSIF (sticky = '0' and prelim_result(0)='0') THEN
		RETURN;
	END IF;

	-- round result, add one to the prelimanary result overflow

        IF prelim_result = B"11111111_11111111_11111111" THEN   --overflow
            prelim_result := B"10000000_00000000_00000000";
            exp_result := exp_result + 1;
            RETURN;
        END IF;
		

        -- round result
        FOR i IN MNT_LENGTH TO (prelim_result'HIGH - 1) LOOP
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
------------------------------------------------------------------------------

BEGIN 

multply: PROCESS(clk, operation)
    VARIABLE exp1, exp2		: exp;
    VARIABLE exp_product	: integer;
    VARIABLE mant1, mant2	: mnt;
    VARIABLE p_addend, p_result	: mnt;
    VARIABLE temp_product	: product;
    VARIABLE mant_result	: mantissa;
    VARIABLE sign1, sign2 	: bit;
    VARIABLE sign_product	: bit;
    VARIABLE underflow, overflow: boolean;
    VARIABLE zero_flag1		: boolean;
    VARIABLE zero_flag2		: boolean;
    VARIABLE inf_flag1 		: boolean;
    VARIABLE inf_flag2		: boolean;
    VARIABLE Nan_flag1		: boolean; 
    VARIABLE Nan_flag2		: boolean;
    VARIABLE non_special1	: boolean;
    VARIABLE non_special2	: boolean;
    VARIABLE over_under_flow	: boolean;
    VARIABLE Cout		: bit:='0';
    VARIABLE sticky_bit		: bit:='0';
    VARIABLE round_bit		: bit:='0';


    ALIAS zero    : bit is flags(3);
    ALIAS pos_inf : bit is flags(2);
    ALIAS neg_inf : bit is flags(1);
    ALIAS Nan     : bit is flags(0);

BEGIN

   IF clk='1' and operation/= idle THEN

   -- 1. Initialize the flags, check for special operands and load operands
   -- 
	zero_flag1:=false;   	
	zero_flag2:=false;   

	underflow:=false;    	
	overflow :=false;    

	inf_flag1:=false;	
	inf_flag2:=false;

	Nan_flag1:=false;       
	Nan_flag2:=false;    

	non_special1:=false;    -- operand 1 is not special input if true
	non_special2:=false;    -- operand 2 is not special input if true

	over_under_flow:=false;

	flags<="0000";

	sticky_bit:='0';	-- initialize sticky bit
	-- Load oprand1 and set internal flags 

	IF op1_exp=0 and op1_mant=B"0000000_00000000_00000000" THEN
		zero_flag1:=true;
	ELSIF op1_exp=MAX_EXP  THEN
            IF op1_mant/=B"0000000_00000000_00000000" THEN
                Nan_flag1:= true;
            ELSE	
               inf_flag1:=true;
            END IF;
	ELSE
	    non_special1:= true;
	    sign1 := op1_sign;
	    exp1  := op1_exp;
	    mant1 := '1'&op1_mant;	
	END IF;

	-- Load oprand2 and set internal flags 

	IF op2_exp=0 and op2_mant=B"0000000_00000000_00000000" THEN
                zero_flag2:=true;
	ELSIF op2_exp=MAX_EXP  THEN
            IF op2_mant/=B"0000000_00000000_00000000" THEN
                Nan_flag2:= true;
            ELSE
                inf_flag2:=true;
            END IF;
	ELSE 
	    non_special2:=true;		
	    sign2 := op2_sign;
	    exp2  := op2_exp;
	    mant2 := '1'&op2_mant;
        END IF;
    
    -- 2. Check Special operands

    -- If there are no special input (0, Nan, +/- Infinity) do step 3 through  
    -- step 5; otherwise, skip to step 7
	
	IF non_special1 and non_special2 THEN 
	
    -- 3. Operate on the exponent and set product sign bit

    -- Check the product exponent overflow after result normalized in step 5
	    -- Add two exponent and subtract bias		
	
	    exp_product:=exp1+exp2-127;
	    -- Set result sign bit		

	    IF sign1=sign2 THEN 
		sign_product:='0';
            ELSE 
		sign_product:='1';	
	    END IF;

    -- 4. Multiply the mantissa using shift and add algorithm
	
	    temp_product:=X"000000"&mant1;
	    Cout:='0';			-- initialize for each multiplication
	    p_result:=X"000000";	-- initialize for each multiplication
		
	    FOR i IN mant1'REVERSE_RANGE LOOP


		p_addend := temp_product(temp_product'HIGH downto MNT_LENGTH);
	
		IF mant1(i)='1' THEN
		    bit_add(mant2, p_addend, p_result, Cout);
		    temp_product(temp_product'HIGH downto MNT_LENGTH):=p_result;
		END IF;
		
	        shift_right1(Cout, temp_product);	    
		sticky_bit:= sticky_bit OR temp_product(MNT_LENGTH-3);
		Cout:='0';
	    END LOOP;

    -- 5. Normalize result and load round and sticky bit 
	
	    IF temp_product(temp_product'HIGH)='0' THEN
	 	temp_product:=shift_left1(temp_product);
	    ELSE
		exp_product:=exp_product+1;
		sticky_bit:= sticky_bit OR temp_product(MNT_LENGTH-2); 
	    END IF;

	    round_bit:= temp_product(MNT_LENGTH-1);

    -- 6. Round result, check overflow, underflow, denormal(subnormal) results 
          -- and set flags
	    
	    round_result(round_bit, sticky_bit, temp_product, exp_product);
	    mant_result:= temp_product(temp_product'HIGH-1 downto MNT_LENGTH);
	    -- Check overflow, halt operation if true	    
	    ASSERT 
		NOT(exp_product > MAX_EXP) 
	    REPORT 
		"EXPONENT OVERFLOW RESULT FROM MULTIPLICATION, OPERATION HAS NO EFFECT ON OUTPUT!" 
	    SEVERITY WARNING;
	   
	    -- Check underflow, halt operation if true
	    ASSERT 
		NOT(exp_product < 0) 
	    REPORT 
		"EXPONENT UNDERFLOW RESULT FROM MULTIPLICATION, OPERATION HAS NO EFFECT ON OUTPUT!" 
	    SEVERITY WARNING;

	    -- overflow or underflow check
	    IF (exp_product<0)or(exp_product>MAX_EXP) THEN 
		over_under_flow:=true; 
	    END IF;	

	    -- set special flag 
	    IF exp_product = MAX_EXP THEN
		IF mant_result=B"0000000_00000000_00000000" THEN
		    IF sign_product='0' THEN
			pos_inf<='1';
		    ELSE
			neg_inf<='1';
		    END IF;
		ELSE
		    Nan <= '1';
		END IF;
	    ELSIF exp_product = 0 THEN
		-- check for denormal number
		ASSERT 
		    NOT(mant_result=B"0000000_00000000_00000000")
		REPORT 
		    "DENORMAL NUMBER RESULT FROM MULTIPLICATION"	
		SEVERITY WARNING;

		IF mant_result=B"0000000_00000000_00000000" THEN
		    zero <='1'; 
		END IF;
	    END IF;		
	ELSE
    -- 7. Handle special input and set flags	

    --=========================================================================

			------------------------------------------ 
			--   special operands operation table    |
			------------------------------------------
			--op1\op2|| Zero  | Nan	|  +Inf	 | -Inf  |
			--========================================
			-- zero  || Zero  | Nan |  Zero  | Zero  |
			------------------------------------------
			-- Nan   || Nan   | Nan |  Nan   | Nan   |
			------------------------------------------
			-- +Inf  || Zero  | Nan |  +Inf  | -Inf  |
			------------------------------------------
			-- -Inf  || Zero  | Nan |  -Inf  | +Inf  |
			------------------------------------------ 

    --=========================================================================
	    IF Nan_flag1 OR Nan_flag2 THEN
		Nan <= '1';
		IF Nan_flag1 THEN
			exp_product :=op1_exp;
			sign_product:=op1_sign;
			mant_result :=op1_mant;			
		ELSE 
			exp_product :=op2_exp;
			sign_product:=op2_sign;
			mant_result :=op2_mant;			
		END IF;
	     ELSIF zero_flag1 OR zero_flag2 THEN
		zero <= '1';
	 	exp_product := 0;
		sign_product:=op1_sign XOR op2_sign; 		
		mant_result :=B"00000000000000000000000";
	     ELSIF inf_flag1 THEN
		exp_product := op1_exp;
		sign_product:= op1_sign XOR op2_sign;
		mant_result := op1_mant;
		IF sign_product='1' THEN neg_inf<='1';
		ELSE pos_inf<='1';
		END IF;
	     ELSE 
		exp_product := op2_exp;
		sign_product:= op1_sign XOR op2_sign;
		mant_result := op2_mant;
		IF sign_product='1' THEN neg_inf<='1';
		ELSE pos_inf<='1';
		END IF;
	     END IF;
        END IF;
    -- 8. Put result on the output if no overflow or underflow occurs
	IF NOT over_under_flow THEN
            res_sign <= sign_product;
	    res_exp  <= exp_product;
	    res_mant <= mant_result;
	END IF;
    END IF;
END process;
END fmu_behavior;
