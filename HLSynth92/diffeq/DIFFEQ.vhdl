--------------------------------------------------------------------------------
--
-- Differential Equation Benchmark
--
-- Source: Adapted from example in paper
--        "HAL: A Multi-Paradigm Approach to Automatic Data Path Synthesis"
--         by P. Paulin, J. Knight and E. Girczyc
--         23rd DAC, June 1986, pp. 263-270
--
-- Benchmark author: Joe Lis
--
--    Copyright (c) 1989 by Joe Lis 
-- 
-- Modified by Champaka Ramachandran on Aug 17th 1992 
--
-- Verification Information:
--
--                  Verified     By whom?           Date         Simulator
--                  --------   ------------        --------     ------------
--  Syntax            yes   Champaka Ramachandran  17th Aug 92    ZYCAD
--  Functionality     yes   Champaka Ramachandran  17th Aug 92    ZYCAD
--------------------------------------------------------------------------------

entity diffeq is
   port (Xinport: in integer;
         Xoutport: out integer;
         DXport: in integer;
         Aport: in integer;
         Yinport: in integer;
         Youtport: out integer;
         Uinport: in integer;
         Uoutport: out integer);
end diffeq;

--VSS: design_style BEHAVIORAL

architecture diffeq of diffeq is

begin

P1 : process (Aport, DXport, Xinport, Yinport, Uinport)

   variable x_var,y_var,u_var, a_var, dx_var: integer ;
   variable x1, y1, t1,t2,t3,t4,t5,t6: integer ;

begin

  x_var := Xinport;  a_var := Aport; dx_var := DXport; y_var := Yinport; u_var := Uinport;
  
   while (x_var < a_var) loop

      t1 := u_var * dx_var;
      t2 := 3 * x_var;
      t3 := 3 * y_var;
      t4 := t1 * t2;
      t5 := dx_var * t3;
      t6 := u_var - t4;

      u_var := t6 - t5;
      y1 := u_var * dx_var;
      y_var := y_var + y1;
      x_var := x_var + dx_var;


   end loop;

  Xoutport <= x_var;
  Youtport <= y_var;
  Uoutport <= u_var;

end process P1;

end diffeq;
