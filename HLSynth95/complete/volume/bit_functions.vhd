package bit_functions is

   -- shifting and rotating
   function Shl(constant v2 : in bit_vector ; constant fill : in bit ) 
               	return bit_vector;
   function Shl0(constant v2 : in bit_vector ; constant dist : in integer ) 
               	return bit_vector;
   function Shl1(constant v2 : in bit_vector ; constant dist : in integer ) 
		return bit_vector;
   function Shr(constant v2 : in bit_vector ; constant fill : in bit ) 
		return bit_vector;
   function Shr0(constant v2 : in bit_vector ; constant dist : in integer ) 
		return bit_vector;
   function Shr1(constant v2 : in bit_vector ; constant dist : in integer ) 
		return bit_vector;
   function Rotr(constant v2 : in bit_vector ; constant dist : in integer ) 
		return bit_vector;
   function Rotl(constant v2 : in bit_vector ; constant dist : in integer ) 
		return bit_vector;

   -- integer conversion
   function I2B(constant Number : in integer ; constant len : in integer ) 
		return bit_vector;
   function B2I(constant v2 : in bit_vector ) return integer;

   -- arithmetic operations
   function Sub(constant x1 : in bit_vector ; constant x2 : in bit_vector ) 
		return bit_vector;
   function Dec(constant x : in bit_vector ) return bit_vector;
   function CarryAdd(constant x1:in bit_vector ; constant x2:in bit_vector ) 
		return bit_vector;
   function Add(constant x1 : in bit_vector ; constant x2 : in bit_vector ) 
		return bit_vector;
   function Inc(constant x : in bit_vector ) return bit_vector;
   function Mul(constant x1 : in bit_vector ; constant x2 : in bit_vector ) 
		return bit_vector;

   -- complementing
   function Comp(constant v2 : in bit_vector ) return bit_vector;
   function TwosComp(constant v2 : in bit_vector ) return bit_vector;

   -- miscellaneous
   function Reverse(constant v2 : in bit_vector ) return bit_vector;
   function Sum(constant v2 : in bit_vector ) return integer;
   function Pad(constant v : in bit_vector ; constant width : in integer ) 
		return bit_vector;

   -- parity
   function OddParity(constant v1 : in bit_vector ) return bit;
   function EvenParity(constant v1 : in bit_vector ) return bit;

end;

package body bit_functions is

   --------------------------------
   --   shifting and rotating
   --------------------------------

   function Shl(constant v2 : in bit_vector ; constant fill : in bit ) 
		return bit_vector is
      variable v1: bit_vector (v2'high downto v2'low);
      variable shift_val: bit_vector (v1'low to v1'high);
      variable I: integer;
   begin
      v1 := v2;
      for I in v1'high downto (v1'low + 1) loop
         shift_val(I) := v1(I - 1);
      end loop ;
      shift_val(v1'low) := fill;
      return shift_val;
   end;

   function Shl0(constant v2 : in bit_vector ; constant dist : in integer ) 
		return bit_vector is
      variable v1: bit_vector (v2'high downto v2'low);
      variable I: integer;
   begin
      v1 := v2;
      for I in 1 to dist loop
         v1 := Shl(v1,'0');
      end loop ;
      return v1;
   end;

   function Shl1(constant v2 : in bit_vector ; constant dist : in integer ) 
		return bit_vector is
      variable v1: bit_vector (v2'high downto v2'low);
      variable I: integer;
   begin
      v1 := v2;
      for I in 1 to dist loop
         v1 := Shl(v1,'1');
      end loop ;
      return v1;
   end;

   function Shr(constant v2 : in bit_vector ; constant fill : in bit ) 
		return bit_vector is
      variable v1: bit_vector (v2'high downto v2'low);
      variable shift_val: bit_vector (v1'low to v1'high);
   begin
      v1 := v2;
      for I in v1'low to (v1'high - 1) loop
         shift_val(I) := v1(I + 1);
      end loop ;
      shift_val(v1'high) := fill;
      return shift_val;
   end;

   function Shr0(constant v2 : in bit_vector ; constant dist : in integer ) 
		return bit_vector is
      variable v1: bit_vector (v2'high downto v2'low);
      variable I: integer;
   begin
      v1 := v2;
      for I in 1 to dist loop
         v1 := Shr(v1,'0');
      end loop ;
      return v1;
   end;

   function Shr1(constant v2 : in bit_vector ; constant dist : in integer ) 
		return bit_vector is
      variable v1: bit_vector (v2'high downto v2'low);
      variable I: integer;
   begin
      v1 := v2;
      for I in 1 to dist loop
         v1 := Shr(v1,'1');
      end loop ;
      return v1;
   end;

   function Rotr(constant v2 : in bit_vector ; constant dist : in integer ) 
		return bit_vector is
      variable v1: bit_vector (v2'high downto v2'low);
      variable I: integer;
   begin
      v1 := v2;
      for i in 1 to dist loop
         v1 := Shr(v1,v1(v1'low));
      end loop ;
      return v1;
   end;

   function Rotl(constant v2 : in bit_vector ; constant dist : in integer ) 
		return bit_vector is
      variable v1: bit_vector (v2'high downto v2'low);
      variable I: integer;
   begin
      v1 := v2;
      for i in 1 to dist loop
         v1 := Shl(v1,v1(v1'high));
      end loop ;
      return v1;
   end;

   --------------------------------
   -- integer conversion
   --------------------------------

   function I2B(constant Number : in integer ; constant len : in integer ) 
		return bit_vector is
      variable temp: bit_vector (len - 1 downto 0);
      variable NUM: integer:=0;
      variable QUOTIENT: integer:=0;
   begin
      QUOTIENT := Number;
      for I in 0 to len - 1 loop
         NUM := 0;
         while QUOTIENT > 1 loop
            QUOTIENT := QUOTIENT - 2;
            NUM := NUM + 1;
         end loop ;
         case QUOTIENT is
            when 1 =>
               temp(I) := '1';
            when 0 =>
               temp(I) := '0';
            when others =>
               null;
         end case;
         QUOTIENT := NUM;
      end loop ;
      return temp;
   end;

   function B2I(constant v2 : in bit_vector ) return integer is
      variable v1: bit_vector (v2'high downto v2'low);
      variable Sum: integer:=0;
   begin
      v1 := v2;
      for N in v1'low to v1'high loop
         if v1(N) = '1' then
            Sum := Sum + (2 ** (N - v1'low));
         end if;
      end loop ;
      return Sum;
   end;

   --------------------------------
   -- arithmetic operations
   --------------------------------

   function Sub(constant x1 : in bit_vector ; constant x2 : in bit_vector ) 
		return bit_vector is
      variable v1: bit_vector (x1'high - x1'low downto 0);
      variable v2: bit_vector (x2'high - x2'low downto 0);
      variable Sum: bit_vector (v1'low to v1'high);
   begin
      v1 := x1;
      v2 := x2;
      assert v1'length = v2'length report "bit_vector -: operands of unequal lengths" severity FAILURE;
      Sum := I2B(B2I(v1) - B2I(v2),Sum'length);
      return (Sum);
   end;

   function Dec(constant x : in bit_vector ) return bit_vector is
      variable v: bit_vector (x'high downto x'low);
   begin
      v := x;
      return I2B(B2I(v) - 1,v'length);
   end;

   function CarryAdd(constant x1 : in bit_vector ; constant x2 : in bit_vector ) 
		return bit_vector is
      variable v1: bit_vector (x1'high - x1'low downto 0);
      variable v2: bit_vector (x2'high - x2'low downto 0);
      variable Sum: bit_vector (x1'high - x1'low + 1 downto 0);
   begin
      v1 := x1;
      v2 := x2;
      assert v1'length = v2'length report "bit_vector +: operands of unequal lengths" severity FAILURE;
      Sum := I2B(B2I(v1) + B2I(v2),Sum'length);
      return (Sum);
   end;

   function Add(constant x1 : in bit_vector ; constant x2 : in bit_vector ) 
		return bit_vector is
      variable v1: bit_vector (x1'high - x1'low downto 0);
      variable v2: bit_vector (x2'high - x2'low downto 0);
      variable Sum: bit_vector (v1'low to v1'high);
   begin
      v1 := x1;
      v2 := x2;
      assert v1'length = v2'length report "bit_vector +: operands of unequal lengths" severity FAILURE;
      Sum := I2B(B2I(v1) + B2I(v2),Sum'length);
      return (Sum);
   end;

   function Inc(constant x : in bit_vector ) return bit_vector is
      variable v: bit_vector (x'high downto x'low);
   begin
      v := x;
      return I2B(B2I(v) + 1,v'length);
   end;

   function Mul(constant x1 : in bit_vector ; constant x2 : in bit_vector ) return bit_vector is
      variable v1: bit_vector (x1'high - x1'low downto 0);
      variable v2: bit_vector (x2'high - x2'low downto 0);
      variable PROD: bit_vector (v1'low to v1'high);
   begin
      v1 := x1;
      v2 := x2;
      assert v1'length = v2'length report "bit_vector +: operands of unequal lengths" severity FAILURE;
      PROD := I2B(B2I(v1) * B2I(v2),PROD'length);
      return (PROD);
   end;

   --------------------------------
   -- complementing
   --------------------------------

   function Comp(constant v2 : in bit_vector ) return bit_vector is
      variable v1: bit_vector (v2'high downto v2'low);
      variable temp: bit_vector (v1'low to v1'high);
      variable I: integer;
   begin
      v1 := v2;
      for I in v1'low to v1'high loop
         if v1(I) = '0' then
            temp(i) := '1';
         else
            temp(i) := '0';
         end if;
      end loop ;
      return temp;
   end;

   function TwosComp(constant v2 : in bit_vector ) return bit_vector is
      variable v1: bit_vector (v2'high downto v2'low);
      variable temp: bit_vector (v1'low to v1'high);
   begin
      v1 := v2;
      temp := Comp(v1);
      temp := Inc(temp);
      return temp;
   end;

   --------------------------------
   -- miscellaneous
   --------------------------------

   function Reverse(constant v2 : in bit_vector ) return bit_vector is
      variable v1: bit_vector (v2'high downto v2'low);
      variable temp: bit_vector (v1'low to v1'high);
   begin
      v1 := v2;
      for I in v1'high downto v1'low loop
         temp(I) := v1(v1'high - I + v1'low);
      end loop ;
      return temp;
   end;

   function Sum(constant v2 : in bit_vector ) return integer is
      variable v1: bit_vector (v2'high downto v2'low);
      variable count: integer:=0;
   begin
      v1 := v2;
      for I in v1'high downto v1'low loop
         if (v1(I) = '1') then
            count := count + 1;
         end if;
      end loop ;
      return count;
   end;

   function Pad(constant v : in bit_vector ; constant width : in integer ) 
		return bit_vector is
   begin
      return I2B(B2I(v),width);
   end;

   --------------------------------
   -- parity
   --------------------------------

   function OddParity(constant v1 : in bit_vector ) return bit is
   begin
      if ((Sum(v1) mod 2) = 1) then
         return '0';
      else
         return '1';
      end if;
   end;

   function EvenParity(constant v1 : in bit_vector ) return bit is
   begin
      if ((Sum(v1) mod 2) = 1) then
         return '1';
      else
         return '0';
      end if;
   end;

end;
