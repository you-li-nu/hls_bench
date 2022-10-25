/*********************************************************************

   AUTHOR: H. Fatih Ugurdag, Staff Fellow (hugurdag@bonnie.cs.gmr.com)
   ORGANIZATION: GM R&D Center, Warren, MI

   GOAL OF SYNTHESIS: 

   Simulation results of the synthesized circuit SHOULD match with
   simulation results of the behavior on a clock-cycle-by-clock-cycle
   basis.

   DESCRIPTION of Behavior:

   This is a "period counter." It counts the length of a complete
   cycle of signal "IN" in terms of the number of "Clock" cycles it
   takes. The circuit is asleep as long as "reset" is low. When reset
   is released, it waits for a positive edge on "COMMAND" (1st while
   loop). Note that the circuit assumes that the initial value of
   COMMAND is 0. That is if COMMAND is 1 the first time it is sampled,
   that is regarded as a positive edge. Then, the circuit waits for a
   positive edge on IN (2nd while loop), because we want to measure a
   complete cycle of IN. That is, we have to start with a fresh new
   cycle of IN. Then, we count the positive half cycle of IN (3rd
   while loop).Then, we keep counting in the negative half cycle of IN
   (4th while loop). Then, we update the output "PERIOD." The circuit
   later starts waiting for a new positive edge on COMMAND. 

   The interesting feature of this behavioral description is the
   locations of Clock edges. There is no clock edge before we enter
   while loops (except the 1st). And there is no clock edge before we
   exit a while loop. 

   Most behavioral synthesis tools won't even accept this
   description.

-- Verification Information:
--
--                  Verified     By whom?           Date         Simulator
--                  --------   ------------        --------     ------------
--  Syntax            yes     Fatih Ugurdag	      ?              ?
--  Functionality     yes     Fatih Ugurdag	      ?              ?

*********************************************************************/

module period_counter (Clock, reset, COMMAND, IN, STATUS, PERIOD);

input Clock, reset;
input COMMAND, IN;
output [1:0] STATUS;
output [7:0] PERIOD;
reg prev_IN;
reg [1:0] STATUS;
reg [7:0] PERIOD, count, prev_COMMAND;

parameter 
	WAITING = 2'd0, IN_PROGRESS = 2'd1, 
	OVERFLOW = 2'd2, DONE = 2'd3;

initial forever @(negedge reset) begin
	disable main;
	prev_COMMAND = 0; prev_IN = 1;
	STATUS <= DONE; PERIOD <= 0;
end

always begin :main
	/*{reset}*/ wait (reset);
	@(posedge Clock)

	// wait for a posedge on COMMAND
	while (!((COMMAND == 1) && (prev_COMMAND == 0)))
		@(posedge Clock) prev_COMMAND = COMMAND;

	begin: calculation
	STATUS <=WAITING;
	PERIOD <= 0;

	// wait for a posedge on IN
	while (!((IN == 1) && (prev_IN == 0)))
		@(posedge Clock) prev_IN = IN;

	STATUS <= IN_PROGRESS;
	count = 0;

	// count the length of (+) half cycle
	while (IN == 1) begin 
		@(posedge Clock)
		count = count + 1;
		if (count == 0) begin
			STATUS <= OVERFLOW;
			#1 disable calculation;
		end
	end

	// count the length of (-) half cycle
	while (IN == 0) begin
		@(posedge Clock) 
		count = count + 1;
		if (count == 0) begin
			STATUS <= OVERFLOW;
			#1 disable calculation;
		end
	end

	STATUS <= DONE;
	PERIOD <= count;

	end // calculation

	prev_COMMAND = 1;
end

endmodule
