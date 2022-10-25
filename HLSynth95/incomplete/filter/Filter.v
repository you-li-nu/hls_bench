/*********************************************************************

   AUTHOR: H. Fatih Ugurdag, Staff Fellow (hugurdag@bonnie.cs.gmr.com)
   ORGANIZATION: GM R&D Center, Warren, MI

   GOAL OF SYNTHESIS: 

   Simulation results of the synthesized circuit SHOULD match with
   simulation results of the behavior on a clock-cycle-by-clock-cycle
   basis.

   DESCRIPTION of Behavior:

   This filter is an "Interpolating Switchable 3rd Order FIR Filter."
   It is "switchable" because it samples its input either every 2
   clock cycles or 4 clock cycles depending on the "switch" input. It
   is "interpolating" because although it only generates a true output
   value based on the 3rd FIR filter equation at the same frequency as
   it samples its input, it still updates the output by linear
   interpolation in intermediate clock cycles. 

   The interesting thing about this description is that different
   execution paths take different number of clock cycles. There is
   also no Clock edge right after "if." Most behavioral synthesis
   tools won't accept such descriptions. 

-- Verification Information:
--
--                  Verified     By whom?           Date         Simulator
--                  --------   ------------        --------     ------------
--  Syntax            yes     Fatih Ugurdag	      ?              ?
--  Functionality     yes     Fatih Ugurdag	      ?              ?

*********************************************************************/

module filter (Clock, reset, in, switch, out);

input Clock, reset, switch;
input [7:0] in;
output [7:0] out;
reg [7:0] out, x1, x2, x3, y, yold, delta;

initial forever @(negedge reset) begin
	disable main;
	out = 0;
end

always begin
	@(posedge Clock)
	x1 = in; out <= y; yold = y;
	y = x1 + x2 + x3;
	delta = y - yold;
	delta = delta >> 1;
	if (switch == 1) begin
		delta = delta >> 1;
		@(posedge Clock) out <= out + delta;
		@(posedge Clock) out <= out + delta;
	end
	@(posedge Clock) out <= out + delta;
	x3 = x2; x2 = x1;

endmodule
