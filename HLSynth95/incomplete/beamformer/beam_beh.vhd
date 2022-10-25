-- VHDL description of N-Element, M-Beam beamformer
-- with P-th order FIR filter (N=16, M=16, P=16)
--
-- Author: Smita Bakshi, University of California, Irvine
--
-- Verification Information:
--
--                  Verified     By whom?           Date         Simulator
--                  --------   ------------        --------     ------------
--  Syntax            yes     Preeti R. Panda      25 Jan 95    Synopsys
--  Functionality     No


use work.beam_pkg.all;

entity beamE is
   port(
         clk    : in bit;
         Binput : in beam_input_type;
         Boutput : out beam_output_type
       );
end beamE;

architecture beamA of beamE is
begin

   beamformer: process
      type fir_coeff_type is array(0 to M-1, 0 to N-1, 0 to P-1) of integer;
      type fir_input_type is array(0 to N-1, 0 to P-1) of integer;
      type fir_output_type is array(0 to M-1, 0 to N-1) of integer;
      type pr_coeff_type is array(0 to M-1, 0 to N-1) of integer;
      variable c : fir_coeff_type;
      variable D : fir_input_type;
      variable y : fir_output_type;
      variable w : pr_coeff_type;
      variable R : beam_output_type;

      variable b, e, k, i : integer;
      variable first_clock : bit := '1';
   begin

       wait until (clk = '1') and not (clk'stable); 
 
       -- initializing the fir input for all elements
       if (first_clock = '1') then
          for e in 0 to N-1 loop		-- for all elements
             for k in 0 to P-1 loop		-- for all FIR values
                D(e,k) := 0;
       	     end loop;
          end loop;
          first_clock := '0';
       end if;
        
       -- read the input for all elements
       for e in 0 to N-1 loop		-- for all elements
          D(e,0) := Binput(e);
       end loop;

       --  computing the output for each beam
       for i in  0 to S-1 loop			-- for all samples
          for b in 0 to M-1 loop		-- for all beams
             R(b) := 0;
             for e in 0 to N-1 loop		-- for all elements
                y(b,e) := 0;
                for k in 0 to P-1 loop		-- for all FIR values
                   y(b,e) := y(b,e) + D(e,i-k)*c(b,e,k);
                end loop;
                R(b) := R(b) + y(b,e)*w(b,e);
             end loop;
             Boutput(b) <= R(b);
          end loop;
       end loop;

       -- shifting the FIR input for each element
       for e in 0 to N-1 loop		        -- for all elements
          for k in 1 to P-1 loop		-- for all FIR values
             D(e,k) := D(e,k-1);
          end loop;
       end loop;
       
   end process;
end beamA;

