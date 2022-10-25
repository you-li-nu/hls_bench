----------------------------------------------------------------------------------
-- Radix-512 Divider Benchmark
--
-- Source:  "Division and Square Root: Digit-Recurrence Algorithms and
--           Implementations" M.D. Ergegovac, T. Lang
--
-- VHDL Benchmark author: Alberto Nannarelli on Jan 18 1994 
--
-- Verification Information:
--
--                  Verified     By whom?           Date         Simulator
--                  --------   ------------       ---------     ------------
--  Syntax            yes     Alberto Nannarelli  28 Jan 94      Synopsys
--  Functionality     yes     Alberto Nannarelli   1 Feb 94      Synopsys
--
-- Modification Information:
--
--                  Verified     By whom?           Date         Simulator
--                  --------   ------------       ---------     -----------
--  Syntax            yes     Alberto Nannarelli  22 Feb 94      Synopsys
--  Functionality     yes     Alberto Nannarelli  22 Feb 94      Synopsys
--
--------------------------------------------------------------------------------

Library IEEE;            
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use IEEE.std_logic_unsigned.all; 
use work.DIVIDER.all;

entity radix512 is
  generic( simulation_delay : time := 10 ns );
  port( x,d: in std_logic_vector (52 downto 0);
          q: out std_logic_vector (52 downto 0));
end radix512;

architecture radix512 of radix512 is 

begin

  process
    variable 	r : integer;
    variable 	uno, zero, onehalf,
		z, ws, wc, wr, rws, rwc,
	 	qi, qz, qu : std_logic_vector (66 downto 0);
    variable 	double_qz : std_logic_vector ((66*2+1) downto 0);
    variable 	di : std_logic_vector (14 downto 0);
    variable 	m  : std_logic_vector (13 downto 0);

    begin

	-- Initalization 
	r := 9;			-- this is log2 of the radix (512)
	zero := conv_std_logic_vector(0, 67);
	uno := conv_std_logic_vector(1, 67);
	onehalf := left_shift(uno, 67-11);

	wait on d,x;

	qu := zero;
	q  <= put_result(qu);

	-- 15 MSBs of d are taken to choose the scaling factor M
	for i in 0 to 14 loop
	     di(i) := d(38+i) ;
	end loop;
	-- M is calculated
	m  := find_m(di);

	-- Scaling of d and x, Mx = w is stored in Carry-Save form (CS-form)
	z  := m*d;
	rws := m*x;
	rwc := zero;

	-- 6 iterations
	for i in 1 to 6 loop

	     -- 9 bits of the result are calculated every iteration
	     qi := right_shift(( rws + rwc + onehalf ),67-(r+1),i) ;
	     qu := qu + left_shift(qi,(6-i)*r);

	     -- the new residue is CS-form is calculated
	     double_qz := qi * z ;
	     qz := fit(double_qz) ;
	     qz := two_complement(qz) ;
	     ws := csa_sum(rws,rwc,qz) ;
	     wc := csa_carry(rws,rwc,qz) ;

	     wait for simulation_delay;

	     rws := left_shift(ws,r);
	     rwc := left_shift(wc,r);

	end loop;

	-- final rounding
	-- if the residue is positive add 1 to the result
	wr := ws + wc ;
	if ( wr(66) = '0' ) then
                qu := qu + 1 ;
	end if;

	q  <= put_result(qu);

  end process;

end radix512;
