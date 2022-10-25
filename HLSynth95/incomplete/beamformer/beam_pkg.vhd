-- VHDL Package used by Beamformer model
--
-- Author: Smita Bakshi, University of California, Irvine
--
-- Verification Information:
--
--                  Verified     By whom?           Date         Simulator
--                  --------   ------------        --------     ------------
--  Syntax            yes     Preeti R. Panda      25 Jan 95    Synopsys
--  Functionality     No

package beam_pkg is

    constant  P: integer := 16;          -- FIR order
    constant  M: integer := 16;          -- Number of beams
    constant  N: integer := 16;          -- Number of elements
    constant  S: integer := 100;         -- Number of samples

    type beam_input_type is array(0 to N-1) of integer;
       			-- for all elements
    type beam_output_type is array(0 to M-1) of integer;
       			-- for all beams

end beam_pkg;

