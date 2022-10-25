--***************************************************************************
-- pack.vhdl                                                                *
--                     VHDL BIT_VECTOR Operations                           * 
--                                                                          * 
--                           Release 2.0                                    * 
--         Copyright (c) 1990   UCI CADLAB, Dept. of ICS                    * 
--         Author :  Sanjiv Narayan (narayan@ics.uci.edu)                   * 
--***************************************************************************
package BIT_FUNCTIONS is

  function SHL0 (v2: BIT_VECTOR; dist: INTEGER) return BIT_VECTOR;
  function SHL1 (v2: BIT_VECTOR; dist: INTEGER) return BIT_VECTOR; 
  function SHL (v2: BIT_VECTOR; fill: BIT) return BIT_VECTOR; 
  function SHR0 (v2: BIT_VECTOR; dist: INTEGER) return BIT_VECTOR; 
  function SHRS (v2: BIT_VECTOR; dist: INTEGER) return BIT_VECTOR; 

  function SHR1 (v2: BIT_VECTOR; dist: INTEGER) return BIT_VECTOR; 
  function SHR (v2: BIT_VECTOR; fill: BIT) return BIT_VECTOR; 

  function INT_TO_BIN (number, length:integer) return BIT_VECTOR;
  function SIGNED_INT_TO_BIN (number, length:integer) return BIT_VECTOR;
  function BIN_TO_INT (v2: BIT_VECTOR) return INTEGER;
  function SIGNED_BIN_TO_INT (v2: BIT_VECTOR) return INTEGER;

  function ONES_COMP (v2: BIT_VECTOR) return BIT_VECTOR;
  function TWOs_COMP (v2: BIT_VECTOR) return BIT_VECTOR;
  function "-"	(x1, x2: BIT_VECTOR) return BIT_VECTOR;
  function DEC(v2: BIT_VECTOR) return BIT_VECTOR;

  function "+"	(x1, x2: BIT_VECTOR) return BIT_VECTOR;
  function INC (v2: BIT_VECTOR) return BIT_VECTOR;

  function ODD_PARITY ( v1 :  BIT_VECTOR ) return BIT;
  function EVEN_PARITY ( v1 :  BIT_VECTOR ) return BIT;

  function REVERSE (v2: BIT_VECTOR) return BIT_VECTOR;
  function SUM(v2 : BIT_VECTOR) return integer;

  function BIT_SLICE (v2: BIT_VECTOR;high_val,low_val:integer)return BIT_VECTOR;
  function ASSIGN_TO_SLICE (v1: BIT_VECTOR; 
                            high_val, low_val: integer;
                            x2: BIT_VECTOR             ) return BIT_VECTOR;
  function "*"  ( x1, x2 :  BIT_VECTOR ) return BIT_VECTOR;
  function COMPARE ( x1, x2 :  BIT_VECTOR ) return BIT_VECTOR;

end BIT_FUNCTIONS; 

package body BIT_FUNCTIONS is

--********************************************************************
function SHL0 (v2: BIT_VECTOR; dist: INTEGER) return BIT_VECTOR is
--********************************************************************

   variable v1 : BIT_VECTOR(v2'high downto v2'low);
   variable shift_val: BIT_VECTOR(v1'range);
   variable I: INTEGER;

   begin
      v1 := v2;
      for I in v1'high downto (v1'low + dist) loop
         shift_val(I) := v1(I - dist);
      end loop;

      for I in (v1'low + dist - 1) downto v1'low loop
         shift_val(I) := '0';
      end loop;

      return shift_val;
end SHL0;

--********************************************************************
function SHL1 (v2: BIT_VECTOR; dist: INTEGER) return BIT_VECTOR is
--********************************************************************

   variable v1 : BIT_VECTOR(v2'high downto v2'low);
   variable shift_val: BIT_VECTOR(v1'range);
   variable I: INTEGER;

   begin
      v1 := v2;
      for I in v1'high downto (v1'low + dist) loop
         shift_val(I) := v1(I - dist);
      end loop;

      for I in (v1'low + dist - 1) downto v1'low loop
         shift_val(I) := '1';
      end loop;
   
      return shift_val;
end SHL1;

--********************************************************************
function SHL (v2: BIT_VECTOR; fill: BIT) return BIT_VECTOR is
--********************************************************************

   variable v1 : BIT_VECTOR(v2'high downto v2'low);
   variable shift_val: BIT_VECTOR(v1'range);
   variable I : integer;

   begin
      v1 := v2;
      for I in v1'high downto (v1'low + 1) loop
         shift_val(I) := v1(I - 1);
      end loop;

      shift_val(v1'low) := fill;
      return shift_val;
end SHL;

--********************************************************************
function SHR0 (v2: BIT_VECTOR; dist: INTEGER) return BIT_VECTOR is
--********************************************************************

   variable v1 : BIT_VECTOR(v2'high downto v2'low);
   variable shift_val: BIT_VECTOR(v1'range);
   variable I: INTEGER;

   begin
      v1 := v2;
      for I in v1'low to (v1'high - dist) loop
          shift_val(I) := v1(I + dist);
      end loop;

      for I in (v1'high - dist + 1 ) to v1'high loop
          shift_val(I) := '0';
      end loop;

      return shift_val;
end SHR0;

--********************************************************************
function SHRS (v2: BIT_VECTOR; dist: INTEGER) return BIT_VECTOR is
--********************************************************************

   variable v1 : BIT_VECTOR(v2'high downto v2'low);
   variable shift_val: BIT_VECTOR(v1'range);
   variable I: INTEGER;

   begin
      v1 := v2;
      for I in v1'low to (v1'high - dist -1) loop
          shift_val(I) := v1(I + dist);
      end loop;

      for I in (v1'high - dist ) to (v1'high - 1)  loop
          shift_val(I) := '0';
      end loop;

      shift_val(v1'high) := v1(v1'high);

      return shift_val;

end SHRS;



--********************************************************************
function SHR1 (v2: BIT_VECTOR; dist: INTEGER) return BIT_VECTOR is
--********************************************************************

   variable v1 : BIT_VECTOR(v2'high downto v2'low);
   variable shift_val: BIT_VECTOR(v1'range);
   variable I: INTEGER;

   begin
      v1 := v2;
      for I in v1'low to (v1'high - dist) loop
          shift_val(I) := v1(I + dist);
      end loop;

      for I in (v1'high - dist + 1 ) to v1'high loop
          shift_val(I) := '1';
      end loop;

      return shift_val;
end SHR1;

--********************************************************************
function SHR (v2: BIT_VECTOR; fill: BIT) return BIT_VECTOR is
--********************************************************************

   variable v1 : BIT_VECTOR(v2'high downto v2'low);
   variable shift_val: BIT_VECTOR(v1'range);

   begin
      v1 := v2; 
      for I in v1'low to (v1'high - 1) loop
          shift_val(I) := v1(I + 1);
      end loop;

      shift_val(v1'high) := fill;
      return shift_val;
end SHR;


--********************************************************************
function SIGNED_INT_TO_BIN(Number,Length : integer) return BIT_VECTOR is
--********************************************************************

    variable NUM : integer;
    variable temp, temp1 : BIT_VECTOR (length - 1 downto 0 ) ;

    begin
      if (Number < 0) then
        NUM := 0 - Number;
      else
        NUM := Number;
      end if;

      temp1 := INT_TO_BIN(NUM, Length);
      if (Number < 0) then
        temp := twos_comp(temp1);
      else
        temp := temp1;
      end if;

      return temp;
end SIGNED_INT_TO_BIN;


--********************************************************************
function INT_TO_BIN(Number,Length : integer) return BIT_VECTOR is
--********************************************************************

    variable temp : BIT_VECTOR (length - 1 downto 0 ) ;
    variable NUM, QUOTIENT : integer := 0;

    begin
       QUOTIENT := Number;

       for I in 0 to length - 1 loop

          NUM := 0;
          while QUOTIENT > 1 loop
             QUOTIENT:= QUOTIENT-2;
             NUM := NUM + 1;
          end loop;

          case QUOTIENT is
             when 1 => temp(I) := '1';
             when 0 => temp(I) := '0';
             when others => null;
          end case;

          QUOTIENT := NUM;    
       end loop;

      return temp;
end INT_TO_BIN;


--********************************************************************
function SIGNED_BIN_TO_INT (v2: BIT_VECTOR) return integer is
--********************************************************************

   variable v1 : BIT_VECTOR(v2'high downto v2'low);
   variable num : integer;
   variable SUM: integer := 0;

   begin
     if (v2(v2'high) = '1') then
       v1 := twos_comp(v2);
     else
       v1 := v2;
     end if;

     num := BIN_TO_INT(v1);
     if (v2(v2'high) = '1') then
       SUM := 0 - num;
     else
       SUM := num;
     end if;                          

     return SUM;
end SIGNED_BIN_TO_INT;

--********************************************************************
function BIN_TO_INT (v2: BIT_VECTOR) return integer is
--********************************************************************

   variable v1 : BIT_VECTOR(v2'high downto v2'low);
   variable SUM: integer := 0;

   begin
      v1 := v2;
      for N in v1'low to v1'high loop
         if v1(N) = '1' then
            SUM := SUM + (2**(N - v1'low));
         end if;
      end loop;

      return SUM;
end BIN_TO_INT;

--********************************************************************
function ones_comp (v2: BIT_VECTOR) return BIT_VECTOR is
--********************************************************************

   variable v1 : BIT_VECTOR(v2'high downto v2'low);
    variable temp: BIT_VECTOR(v1'range);
    variable I: INTEGER;

   begin
      v1 := v2;
      for I in v1'range loop
         if v1(I) = '0' then
            temp(i) := '1';
         else
            temp(i) := '0';
         end if;
      end loop;

      return temp;
end ones_comp;

--********************************************************************
function twos_comp (v2: BIT_VECTOR) return BIT_VECTOR is
--********************************************************************
 
   variable v1 : BIT_VECTOR(v2'high downto v2'low);
   variable temp: BIT_VECTOR(v1'range);
   variable one_occured : BIT;
   variable N : integer;
 
   begin
      v1 := v2; 

      one_occured := '0';

      for N in v1'low to v1'high loop
        if (one_occured = '1') then

         if v1(N) = '0' then
            temp(N) := '1';
         else
            temp(N) := '0';
         end if;

        else
          one_occured := v1(N);
          temp(N) := v1(N);
        end if;

      end loop;        
     
      return temp;
end twos_comp;

--********************************************************************
function "-" (x1, x2: BIT_VECTOR) return BIT_VECTOR is
--********************************************************************

   variable v1 : BIT_VECTOR(x1'high - x1'low downto 0);
   variable v2 : BIT_VECTOR(x2'high - x2'low downto 0);
   variable CARRY: BIT := '0';
   variable S: BIT_VECTOR(1 to 3);
   variable NUM: INTEGER range 0 to 3 := 0;
   variable TEMP,DIF: BIT_VECTOR(v1'range);
   variable I,K: INTEGER;

   begin
      v1 := x1;
      v2 := x2;
      assert v1'length = v2'length
      report "BIT_VECTOR -: operands of unequal lengths"
      severity FAILURE;

      TEMP := twos_comp(v2);
    
      for I in v1'low to v1'high loop
         S:= v1(I) & TEMP(I) & CARRY;
         NUM := 0;

         for K in 1 to 3 loop
            if S(K) = '1' then
               NUM := NUM + 1;
            end if;
         end loop;
   
         case NUM is
            when 0 => DIF(I) := '0'; CARRY := '0';
            when 1 => DIF(I) := '1'; CARRY := '0';
            when 2 => DIF(I) := '0'; CARRY := '1';
            when 3 => DIF(I) := '1'; CARRY := '1';
         end case;
      end loop;

   return DIF;
end "-";

--********************************************************************
function DEC (v2: BIT_VECTOR) return BIT_VECTOR is
--********************************************************************

   variable v1 : BIT_VECTOR(v2'high downto v2'low);
   variable temp : BIT_VECTOR(v1'range);

   begin
      v1 := v2;
      for I in temp'range loop
         temp(I) := '0';
      end loop;
  
      temp(temp'low):= '1';
      temp := v1 - temp;
      return temp;
end DEC; 

--********************************************************************
function "+"(x1, x2 :BIT_VECTOR) return BIT_VECTOR is
--********************************************************************

   variable v1 : BIT_VECTOR(x1'high - x1'low downto 0);
   variable v2 : BIT_VECTOR(x2'high - x2'low downto 0);
   variable CARRY: BIT := '0';
   variable S: BIT_VECTOR(1 to 3);
   variable NUM: INTEGER range 0 to 3 := 0;
   variable SUM: BIT_VECTOR(v1'range);
   variable I,K: INTEGER;

   begin
      v1 := x1;
      v2 := x2;

      assert v1'length = v2'length
      report "BIT_VECTOR +: operands of unequal lengths"
      severity FAILURE;

      for I in v1'low to v1'high loop
         S:= v1(I) & v2(I) & CARRY;
         NUM := 0;
  
         for K in 1 to 3 loop
            if S(K) = '1' then
               NUM := NUM + 1;
            end if;
         end loop;

         case NUM is
            when 0 => SUM(I) := '0'; CARRY := '0';
            when 1 => SUM(I) := '1'; CARRY := '0';
            when 2 => SUM(I) := '0'; CARRY := '1';
            when 3 => SUM(I) := '1'; CARRY := '1';
         end case;
      end loop;
 
      return SUM;
end "+";

--********************************************************************
function inc (v2: BIT_VECTOR) return BIT_VECTOR is
--********************************************************************
 
   variable v1 : BIT_VECTOR(v2'high downto v2'low);
   variable CARRY: BIT := '1';
   variable S: BIT_VECTOR(1 to 2);
   variable NUM: INTEGER range 0 to 2 := 0;
   variable SUM: BIT_VECTOR(v1'range);
   variable I,K: INTEGER;
 
   begin
      v1 := v2;
      for I in v1'low to v1'high loop
 
         S:= v1(I) & CARRY;
         NUM := 0;
         for K in 1 to 2 loop
            if S(K) = '1' then
               NUM := NUM + 1;
            end if;
         end loop;
       
         case NUM is
            when 0 => SUM(I) := '0'; CARRY := '0';
            when 1 => SUM(I) := '1'; CARRY := '0';
            when 2 => SUM(I) := '0'; CARRY := '1';
         end case;
      end loop;
 
      return SUM;
end inc;

--********************************************************************
function ODD_PARITY ( v1 :  BIT_VECTOR ) return BIT is
--********************************************************************

   begin
      if ((SUM(v1) mod 2) = 1) then
         return '0';
      else
         return '1';
      end if;
  end ODD_PARITY;

--********************************************************************
  function EVEN_PARITY ( v1 :  BIT_VECTOR ) return BIT is
--********************************************************************

   begin
      if ((SUM(v1) mod 2) = 1) then
         return '1';
      else
         return '0';
      end if;
  end EVEN_PARITY;

--********************************************************************
function REVERSE(v2:BIT_VECTOR) return BIT_VECTOR is
--********************************************************************

   variable v1 : BIT_VECTOR(v2'high downto v2'low);
   variable temp : BIT_VECTOR(v1'range);

   begin
      v1 := v2;
      for I in v1'high downto v1'low loop
         temp(I) := v1(v1'high - I + v1'low);
      end loop;

      return temp;
end REVERSE;

--********************************************************************
function SUM(v2 : BIT_VECTOR) return integer is
--********************************************************************

   variable v1 : BIT_VECTOR(v2'high downto v2'low);
   variable count : integer := 0;

   begin
      v1 := v2;
      for I in v1'high downto v1'low loop
          if (v1(I) = '1') then 
              count := count + 1; 
          end if;
      end loop;

      return count;
end SUM;


--********************************************************************
function BIT_SLICE (v2: BIT_VECTOR; high_val, low_val:integer ) 
                   return BIT_VECTOR is
--********************************************************************

   -- for use with Vantage Analyst version 1.203 

   variable v1 : BIT_VECTOR(v2'high downto v2'low);
   variable temp : BIT_VECTOR( (high_val - low_val) downto 0);

   begin
      v1 := v2;
      for I in temp'range loop
         temp(i) := v1(low_val + i);
      end loop;

      return temp;
end BIT_SLICE;

--********************************************************************
function ASSIGN_TO_SLICE (v1: BIT_VECTOR;
                          high_val, low_val:integer; 
                          x2: BIT_VECTOR ) return BIT_VECTOR is
--********************************************************************

   -- for use with Vantage Analyst version 1.203 

   variable v2 : BIT_VECTOR(x2'high downto x2'low);
   variable temp : BIT_VECTOR(v1'range);

   begin
      v2 := x2;
      assert (high_val  - low_val + 1) = v2'length
      report "ASSIGN_SLICE: operands of unequal lengths"
      severity FAILURE;

      temp := v1;
      for I in  high_val downto low_val loop
         temp(I) := v2( v2'low + I - low_val);
      end loop;
   
      return temp;
end ASSIGN_TO_SLICE;

--********************************************************************
function "*" (x1, x2: BIT_VECTOR) return BIT_VECTOR is
--********************************************************************

variable A,B,M, M_OUT  : BIT_VECTOR (x1'high downto x1'low);
variable temp  : BIT_VECTOR ((x1'high*2)+1 downto x1'low);
variable x1_sign, x2_sign, M_sign : BIT;
variable COUNT : INTEGER;

begin
      x1_sign := x1(x1'high);
      x2_sign := x2(x2'high);
     
      if (x1_sign = '1') then
        A := twos_comp(x1);
      else
        A := x1;
      end if;

      if (x2_sign = '1') then
        B := twos_comp(x2);
      else
        B := x2;
      end if;

      M_sign := '0';
      if (x1_sign = '0') and (x2_sign = '1') then
        M_sign := '1';
      end if;

      if (x1_sign = '1') and (x2_sign = '0') then
        M_sign := '1';
      end if;


      COUNT := M'low;
      while (COUNT <= M'high) loop
        M(COUNT) := '0';
        COUNT := COUNT + 1;
      end loop;

      COUNT := 0;
      while (COUNT < 16) loop
         if (A(0) = '1') then
	    M := M + B;
	 end if;
	 A := SHR(A,M(0));
	 M := SHR(M,'0');
	 COUNT := COUNT + 1;
      end loop;

      if (M_sign = '1') then
        temp := twos_comp(M&A);
      else
        temp := M&A;
      end if;

      temp := SHRS(temp,10);
      M_OUT := temp(temp'high/2 downto temp'low);
      return M_OUT;

end "*";

--********************************************************************
function COMPARE (x1, x2: BIT_VECTOR) return BIT_VECTOR is
--********************************************************************

variable i, x1_len, x2_len : integer;

begin

  x1_len := x1'high - x1'low;
  x2_len := x2'high - x2'low;

-- 11 implies x1 and x2 are equal.   
-- 01 implies x1 less than x2.
-- 10 implies x1 greater than x2.

  if (x1_len > x2_len) then
    return("10");
  else
    if (x2_len > x1_len) then
      return("01");
    else

-- x1 and x2 have  same bit widths

     i := x1'high; 
     while (i >= x1'low) loop

       if (x1(i) = '1') and (x2(i) = '0') then
         return("10");
       else 
         if (x1(i) = '0') and (x2(i) = '1') then
           return("01");
         end if;
       end if;
          
       i := i - 1;
     end loop;

     return("11");

    end if;

  end if;


end COMPARE;

end  BIT_FUNCTIONS;



