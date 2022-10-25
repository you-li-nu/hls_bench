--------------------------------------------------------------------------------
--
--   Intel 8251 Benchmark -- Complete design model
--
-- Source:  Intel Data Book
--
-- VHDL Benchmark author Indraneel Ghosh
--                       University Of California, Irvine, CA 92717
--
-- Developed on April 7, 92
--
-- Verification Information:
--
--                  Verified     By whom?           Date         Simulator
--                  --------   ------------        --------     ------------
--  Syntax            yes   Champaka Ramachandran  Sept 18, 92    ZYCAD
--  Functionality     yes   Champaka Ramachandran  Sept 18, 92    ZYCAD
--------------------------------------------------------------------------------


use work.types.all;
use work.MVL7_functions.all;
use work.synthesis_types.all;

 entity Intel_8251 is
 port (
	CLK 	  : in clock;
	RxC_BAR   : in clock;
	TxC_BAR   : in clock;
	RESET 	  : in MVL7;
	CS_BAR 	  : in MVL7;
	C_D_BAR   : in MVL7;
	RD_BAR 	  : in MVL7;
	WR_BAR 	  : in MVL7;
	RxD 	  : in MVL7;
	TxD  	  : out MVL7;
	D_0	  : inout MVL7;
	D_1	  : inout MVL7;
	D_2	  : inout MVL7;
	D_3	  : inout MVL7;
	D_4	  : inout MVL7;
	D_5	  : inout MVL7;
	D_6	  : inout MVL7;
	D_7	  : inout MVL7;
	TxEMPTY   : out MVL7;			  
	TxRDY 	  : out MVL7;
	SYNDET_BD : inout MVL7;			 
	RxRDY     : out MVL7;			 
	DTR_BAR   : out MVL7;
	RTS_BAR   : out MVL7;
	DSR_BAR   : in MVL7;
	CTS_BAR   : in MVL7
      );
 end;

 architecture USART of Intel_8251 is

 signal mode	    	 : MVL7_VECTOR(7 downto 0);
 signal command	    	 : MVL7_VECTOR(7 downto 0);
 signal SYNC1	    	 : MVL7_VECTOR(7 downto 0);
 signal SYNC2	    	 : MVL7_VECTOR(7 downto 0);
 signal SYNC_mask	 : MVL7_VECTOR(7 downto 0);
 signal Tx_buffer   	 : MVL7_VECTOR(7 downto 0);
 signal Rx_buffer   	 : MVL7_VECTOR(7 downto 0);
 signal Tx_wr_while_cts  : MVL7;
 signal baud_clocks	 : MVL7_VECTOR(7 downto 0);
 signal stop_clocks	 : MVL7_VECTOR(7 downto 0);
 signal brk_clocks	 : MVL7_VECTOR(10 downto 0);
 signal chars            : MVL7_VECTOR(3 downto 0);

 signal SYNDET_BD_temp	 : MVL7;      -- intermediate signal 
				      -- (for writing to inout port)

 signal status_main	 : MVL7_VECTOR(7 downto 0); -- sub-signal (main)
 signal status_Rx	 : MVL7_VECTOR(7 downto 0); -- sub-signal (Rx)
 signal status_Tx	 : MVL7_VECTOR(7 downto 0); -- sub-signal (Tx)
 signal status	    	 : MVL7_VECTOR(7 downto 0);

 signal trigger_status_main  : MVL7 := '0';         -- trigger-signal (main)
 signal trigger_status_Tx    : MVL7 := '0';         -- trigger-signal (Tx)
 signal trigger_status_Rx    : MVL7 := '0';         -- trigger-signal (Rx)

 signal SYNDET_BD_Rx	 : MVL7;		    -- sub-signal (Rx)
 signal SYNDET_BD_main	 : MVL7;	 	    -- sub-signal (main)

 signal trigger_SYNDET_BD_main : MVL7 := '0';       -- trigger-signal (main)
 signal trigger_SYNDET_BD_Rx   : MVL7 := '0';       -- trigger-signal (Rx)
					     

 signal RxRDY_Rx	 : MVL7;		    -- sub-signal (Rx)
 signal RxRDY_main	 : MVL7;	  	    -- sub-signal (main)

 signal trigger_RxRDY_main : MVL7 := '0';           -- trigger-signal (main)
 signal trigger_RxRDY_Rx   : MVL7 := '0';           -- trigger-signal (Rx)
					 
 begin

-- ********************************************************************

 main : process

-- ********************************************************************

   variable mode_var    	  : MVL7_VECTOR(7 downto 0);
   variable status_var    	  : MVL7_VECTOR(7 downto 0);
   variable command_var    	  : MVL7_VECTOR(7 downto 0);
   variable baud_clocks_var	  : MVL7_VECTOR(7 downto 0);
   variable stop_clocks_var       : MVL7_VECTOR(7 downto 0);
   variable chars_var             : MVL7_VECTOR(3 downto 0);

 -- Because signals dont get new values immediately on assignment, we need to
 -- use variables (mode_var, command_var, baud_clocks_var, stop_clocks_var,
 -- status_var, chars_var) 
 -- which are the same as signals 
 -- (mode, command, stop_clocks, stop_clocks, status, chars).

 -- This is needed because the new values of these signals are used for
 -- further computation inside the "main" process.

   variable next_cpu_control_word : MVL7_VECTOR(1 downto 0);
                       
	-- Variable "next_cpu_control_word" keeps track of which control
 	-- word should come next from the CPU (mode/SYNC-char/command)
					-- 00 = mode
					-- 01 = SYNC CHAR 1
					-- 10 = SYNC CHAR 2
					-- 11 = command

   variable SYNC_var       : MVL7_VECTOR(7 downto 0);
   variable temp   	   : MVL7_VECTOR(10 downto 0);

 begin

 wait until ( clk = '1' ) and ( not clk'stable );

 if (CS_BAR = '0') then			-- if chip select

   if ( RESET = '1') or ( command_var(6) = '1' ) then     -- if reset (external/internal)

						-- Initialize ports and global
						-- signals on reset

	DTR_BAR <= '1';
	RTS_BAR <= '1';

	command_var := "00000000";
	command <= command_var;

	status_var := "00000101"; 
	status_main <= status_var;
	trigger_status_main <= not(trigger_status_main);

        Tx_wr_while_cts <= '0';

			-- Note the type of control word that comes next 
			--  (Mode word)

	next_cpu_control_word := "00";

   else					-- if not reset

	if (RD_BAR = '0') then		-- if read

	  if (C_D_BAR = '1') then	-- if read status

					-- read the value at the DSR_BAR input

	     status_var := not(DSR_BAR) & status(6 downto 0);

					-- Place status word on data bus pins

	     D_0 <= status_var(0);
	     D_1 <= status_var(1);
	     D_2 <= status_var(2);
	     D_3 <= status_var(3);
	     D_4 <= status_var(4);
	     D_5 <= status_var(5);
	     D_6 <= status_var(6);
	     D_7 <= status_var(7);
	     
	     if ( mode_var(1 downto 0) = "00") then	   -- Sync mode

				-- reset SYNDET_BD on status read

		SYNDET_BD_main <= '0';
		trigger_SYNDET_BD_main <= not(trigger_SYNDET_BD_main);
		status_var := status(7) & '0' & status(5 downto 0);
		status_main <= status_var;
		trigger_status_main <= not(trigger_status_main);
	     end if;	     

	  else				-- if read Rx data

	     if (command_var(2) = '1') then  -- if RxENABLE 

			     -- Place received data character on data bus pins

	        D_0 <= Rx_buffer(0);
	        D_1 <= Rx_buffer(1);
	        D_2 <= Rx_buffer(2);
	        D_3 <= Rx_buffer(3);
	        D_4 <= Rx_buffer(4);
	        D_5 <= Rx_buffer(5);
	        D_6 <= Rx_buffer(6);
	        D_7 <= Rx_buffer(7);

			      -- Reset RxRDY on data read

	        RxRDY_main <= '0';	
	        trigger_RxRDY_main <= not(trigger_RxRDY_main);
		status_var := status(7 downto 2) & '0' & status(0); 
		status_main <= status_var;
		trigger_status_main <= not(trigger_status_main);

	     end if;

	  end if;			-- end if command/data

	elsif (WR_BAR = '0') then		-- if write

				-- Tristate the data bus pins (bi-directional)
				-- so that CPU can write data/control word

	  D_0 <= 'Z';
          D_1 <= 'Z'; 
          D_2 <= 'Z';
          D_3 <= 'Z';
          D_4 <= 'Z';
          D_5 <= 'Z';
          D_6 <= 'Z';
          D_7 <= 'Z';

	  wait for 0 ns;	-- only for simulation (resolution function)

	  if (C_D_BAR = '1') then	-- if write command/mode/sync-char

	     case (next_cpu_control_word) is

		when "00" =>	-- next_cpu_control_word = mode

				-- Read mode word from data bus lines

		  mode_var(0) := D_0;
		  mode_var(1) := D_1;
		  mode_var(2) := D_2;
		  mode_var(3) := D_3;
		  mode_var(4) := D_4;
		  mode_var(5) := D_5;
		  mode_var(6) := D_6;
		  mode_var(7) := D_7;

		  mode <= mode_var;

				    -- Find the number of bits per character

		  chars_var := "0101" + ("00" & mode_var(3 downto 2) ); 
	          chars <= chars_var;	-- no. of char bits

		  if ( mode_var(1 downto 0) = "00") then   -- Sync mode

			      -- Note the type of control word that comes next

		     if ( mode_var(6) = '1') then	     -- Ext Sync Mode
		       next_cpu_control_word := "11";	-- command word
		     else				     -- Int Sync Mode
		       next_cpu_control_word := "01";	-- SYNC1
		     end if;

				-- In Synchronous mode, each data/parity bit
				-- is one clock cycle long. There are no stop
				-- bits.

		     stop_clocks <= "00000000";
		     stop_clocks_var := "00000000";
		     baud_clocks <= "00000001";
		     baud_clocks_var := "00000001";

		  else					   -- if Async mode

			      -- Note the type of control word that comes next

		     next_cpu_control_word := "11";	-- command

			    -- Find the number of clock cycles per data/parity
			    -- bit
		     
		     case ( mode_var(1 downto 0)) is	-- set baud rate clks

			when "00" =>
					
			when "01" =>
					baud_clocks_var := "00000001";
					baud_clocks <= baud_clocks_var;
			when "10" =>
					baud_clocks_var := "00010000";
					baud_clocks <= baud_clocks_var;
			when "11" =>
					baud_clocks_var := "01000000";
					baud_clocks <= baud_clocks_var;
			when others =>

		     end case;
		
			    -- Find the number of stop bit clock cycles

		     case ( mode_var(7 downto 6)) is	-- set stop bit clks
			when "00" =>

			when "01" =>
					stop_clocks_var := baud_clocks_var;
					stop_clocks <= stop_clocks_var;
			when "10" =>
					stop_clocks_var := baud_clocks_var(7 downto 0) + ( '0' & baud_clocks_var(7 downto 1) );
					stop_clocks <= stop_clocks_var; 
			when "11" =>
					stop_clocks_var := baud_clocks_var(6 downto 0) & '0';
					stop_clocks <= stop_clocks_var;
			when others =>

		     end case;

  -- Calculate no. of clocks that RxD has to be low for a Break
  -- to be detected. (Two full character sequences)

		-- Count number of start bit clocks

		     temp := "000" & baud_clocks_var;

		-- Count number of data bit clocks (full character)

		     while ( chars_var /= "0000") loop
			temp := temp + ( "000" & baud_clocks_var);
			chars_var := chars_var - "0001";
		     end loop;

		-- Count number of parity bit clocks

		     if (mode_var(4) = '1') then	-- if Parity enable
			temp := temp + ( "000" & baud_clocks_var);
		     end if;

		-- Count number of stop bit clocks

		     temp := temp + ( "000" & stop_clocks_var);

		-- Double this number (RxD has to be low through two
		-- character sequences)

		     brk_clocks <= temp(9 downto 0) & '0';

		  end if;				-- end if sync mode

		when "01" =>	-- next_cpu_control_word = SYNC-CHAR 1

		           -- Read the SYNC1 character from the data bus lines

		  SYNC_var(0) := D_0;
		  SYNC_var(1) := D_1;
		  SYNC_var(2) := D_2;
		  SYNC_var(3) := D_3;
		  SYNC_var(4) := D_4;
		  SYNC_var(5) := D_5;
		  SYNC_var(6) := D_6;
		  SYNC_var(7) := D_7;

			      -- Note the type of control word that comes next
		  
		  if (mode_var(7) = '0') then	-- if Double SYNC char
		     next_cpu_control_word := "10";         -- SYNC2
		  else
		     next_cpu_control_word := "11";	    -- Command
		  end if;	

			     -- Place SYNC1 character into proper format
			     -- (according to number of bits per character).
			     -- Also create a template (SYNC_mask) to be used
			     -- in SYNC-character detection

		  case (mode_var(3 downto 2)) is	-- char. length
		     when "00" =>
				  SYNC1 <= "000" & SYNC_var(4 downto 0);
				  SYNC_mask <= "00011111";
		     when "01" =>
				  SYNC1 <= "00" & SYNC_var(5 downto 0);
				  SYNC_mask <= "00111111";
		     when "10" =>
				  SYNC1 <= "0" & SYNC_var(6 downto 0);
				  SYNC_mask <= "01111111";
		     when "11" =>
				  SYNC1 <= SYNC_var;
				  SYNC_mask <= "11111111";
		     when others =>

		  end case;

		when "10" =>	-- next_cpu_control_word = SYNC-CHAR 2

		           -- Read the SYNC2 character from the data bus lines

		  SYNC_var(0) := D_0;
		  SYNC_var(1) := D_1;
		  SYNC_var(2) := D_2;
		  SYNC_var(3) := D_3;
		  SYNC_var(4) := D_4;
		  SYNC_var(5) := D_5;
		  SYNC_var(6) := D_6;
		  SYNC_var(7) := D_7;

			      -- Note the type of control word that comes next
			      --           (command)

		  next_cpu_control_word := "11";

			     -- Place SYNC2 character into proper format
			     -- (according to number of bits per character).

		  case (mode_var(3 downto 2)) is	-- char. length
		     when "00" =>
				  SYNC2 <= "000" & SYNC_var(4 downto 0);
		     when "01" =>
				  SYNC2 <= "00" & SYNC_var(5 downto 0);
		     when "10" =>
				  SYNC2 <= "0" & SYNC_var(6 downto 0);
		     when "11" =>
				  SYNC2 <= SYNC_var;
		     when others =>

		  end case;

		when "11" =>	-- next_cpu_control_word = command

		           -- Read the command word from the data bus lines

		  command_var(0) := D_0;
		  command_var(1) := D_1;
		  command_var(2) := D_2;
		  command_var(3) := D_3;
		  command_var(4) := D_4;
		  command_var(5) := D_5;
		  command_var(6) := D_6;
		  command_var(7) := D_7;

		  command <= command_var;

			      -- Note the type of control word that comes next
			      -- (another command if there is no reset)
			
		  next_cpu_control_word := "11";

		  status_var := status;

			      -- If receiver is disabled, reset RxRDY
		  
		  if (command_var(2) = '0') then	-- RxENABLE
		     RxRDY_main <= '0';
		     trigger_RxRDY_main <= not(trigger_RxRDY_main);
		     status_var := status(7 downto 2) & '0' & status(0);
		  end if;

			    -- Reset error flags (depending on comand word)

		  if (command_var(4) = '1') then	-- error reset
		     status_var := status_var(7 downto 6) & "000" & status_var(2 downto 0);	
		  end if;

			   -- Update status

		  status_main <= status_var;
	  	  trigger_status_main <= not(trigger_status_main);

			-- Assert output pins (depending on command word)

		  RTS_BAR <= not(command_var(5));
		  DTR_BAR <= not(command_var(1)) ;

		when others =>	
 
	     end case;

	  else				-- if write data for Transmission

             if (command_var(0) = '1') then		-- if TxENABLE

		-- Load data for transmission from data bus lines into parallel
		-- buffer

  	        case (mode_var(3 downto 2)) is	-- char. length
	          when "00" =>
		    Tx_buffer <= "000" & D_4 & D_3 & D_2 & D_1 & D_0;
	          when "01" =>
		    Tx_buffer <= "00" & D_5 & D_4 & D_3 & D_2 & D_1 & D_0;
	          when "10" =>
		    Tx_buffer <= "0" & D_6 & D_5 & D_4 & D_3 & D_2 & D_1 & D_0;
	          when "11" =>
		    Tx_buffer <= D_7 & D_6 & D_5 & D_4 & D_3 & D_2 & D_1 & D_0;
		  when others =>

	        end case;

		-- Reset TxRDY status bit after loading data for transmission

		status_var := status(7 downto 1) & '0';  -- TxRDY
		status_main <= status_var;
		trigger_status_main <= not(trigger_status_main);

		-- Note whether data was written by CPU while CTS_BAR was low

		if (CTS_BAR = '0') then  	-- Tx data was written while
		  Tx_wr_while_cts <= '1';	--  CTS_BAR was asserted
		else
		  Tx_wr_while_cts <= '0';
		end if;

	     end if;

	  end if;				-- end if command/data

	else				-- if neither read nor write

	end if;				-- end if read/write

   end if;				-- end if reset

 end if; 				-- end if chip select

 end process main;

-- ********************************************************************

 transmitter : process

-- ********************************************************************

 variable parity	   : MVL7;
 variable serial_Tx_buffer : MVL7_VECTOR(7 downto 0);
 variable store_Tx_buffer  : MVL7_VECTOR(7 downto 0); -- parity computation
 variable clk_count   	   : MVL7_VECTOR(7 downto 0);
 variable char_bit_count   : MVL7_VECTOR(3 downto 0);

 begin

   if ( RESET = '1') or ( command(6) = '1' ) then       -- if reset

      TxD <= '1';	  -- Send marking signal
      TxEMPTY <= '1';
      status_Tx <= status(7 downto 3) & '1' & status(1 downto 0);
      trigger_status_Tx <= not(trigger_status_Tx);

      wait until ( TxC_BAR = '0' ) and ( not TxC_BAR'stable );

   else

      if (status(0) = '0') then       -- if Tx_buffer is full 
				      --  (TxRDY status bit reset)

			        -- if Tx is enabled and CTS_BAR is low or data
			        -- was written while CTS_BAR was low

	if ( ( (CTS_BAR = '0') and (command(0) = '1') ) or ( Tx_wr_while_cts = '1' ) ) then 

	  -- Load data into serial buffer 

	  serial_Tx_buffer := Tx_buffer;
	  store_Tx_buffer := Tx_buffer;		-- used for parity computation

	  -- Reset TxEMPTY and set TxRDY status bit (we are going to start 
	  -- transmission)

	  TxEMPTY <= '0';

	  if (command(2) = '1') then
	    status_Tx <= status(7 downto 3) & '0' & status(1) & '1';
	  else
	    status_Tx <= status(7 downto 3) & "001";
	  end if;

          trigger_status_Tx <= not(trigger_status_Tx);
			-- TxRDY  and TxEMPTY status bits

	  if (mode(1 downto 0) /= "00") then	-- if async mode (start)

					-- SEND START BIT

	     clk_count := baud_clocks;		

			 -- Loop for counting number of clock cycles per bit
			 -- (according to baud rate)

	     while ( clk_count /= "00000000") loop
	       TxD <= '0';		
	       wait until (TxC_BAR = '0') and (not TxC_BAR'stable);
	       clk_count := clk_count - "00000001";
	     end loop;	     

	  end if;				-- end if async mode (start)

				    -- SEND CHARACTER BITS

	  char_bit_count := chars;      

		-- Loop for counting number of character bits

	  while ( char_bit_count /= "0000") loop

             char_bit_count := char_bit_count - "0001";
	     clk_count := baud_clocks;

			 -- Loop for counting number of clock cycles per bit
			 -- (according to baud rate)

             while ( clk_count /= "00000000") loop
	       TxD <= serial_Tx_buffer(0);
               wait until (TxC_BAR = '0') and (not TxC_BAR'stable);
	       clk_count := clk_count - "00000001";
	     end loop;

	     serial_Tx_buffer := '0' & serial_Tx_buffer(7 downto 1);

          end loop;

			-- SEND PARITY BIT (IF APPLICABLE)

	  if (mode(4) = '1') then		       -- if parity enabled

			-- CALCULATE PARITY BIT

	    parity :=   store_Tx_buffer(0) xor store_Tx_buffer(1) xor				       store_Tx_buffer(2) xor store_Tx_buffer(3) xor				      store_Tx_buffer(4) xor store_Tx_buffer(5) xor				     store_Tx_buffer(6) xor store_Tx_buffer(7) xor 				    (not mode(5));	

	    clk_count := baud_clocks;		-- SEND PARITY BIT

			 -- Loop for counting number of clock cycles per bit
			 -- (according to baud rate)

	    while ( clk_count /= "00000000") loop
	      TxD <= parity;		
              wait until (TxC_BAR = '0') and (not TxC_BAR'stable);
	      clk_count := clk_count - "00000001";
	    end loop;	     

	  end if;	  			       -- end if parity enabled

			-- Data has been sent. Set TxEMPTY unless a new data
			-- character has been written and is about to be sent

	  if ( not((((CTS_BAR = '0') and (command(0) = '1')) or (Tx_wr_while_cts = '1')) and (status(0) = '0'))) then

	     TxEMPTY <= '1';
	     status_Tx <= status(7 downto 3) & '1' & status(1 downto 0);
             trigger_status_Tx <= not(trigger_status_Tx);

	  end if;

	  if (mode(1 downto 0) /= "00") then	-- if async mode (stop)

							-- SEND STOP BIT

	     clk_count := stop_clocks;		

			 -- Loop for counting number of clock cycles in stop 
			 -- stop bit

	     while ( clk_count /= "00000000") loop
	       TxD <= '1';		
	       wait until (TxC_BAR = '0') and (not TxC_BAR'stable);
	       clk_count := clk_count - "00000001";
	     end loop;	     

	  end if;				-- end if async mode (stop)

	else   -- if Transmitter not enabled or
	       -- data was written while CTS_BAR was high

	  TxD <= '1';				-- mark
	  TxEMPTY <= '1';

          wait until ( TxC_BAR = '0' ) and ( not TxC_BAR'stable );

	end if; -- end if Tx disable and data was written while it was disabled

      else				       -- if Tx_buffer empty

	TxEMPTY <= '1';

	if (command(3) = '1') then		-- if send break

	   TxD <= '0';

           wait until ( TxC_BAR = '0' ) and ( not TxC_BAR'stable );

	else					-- if dont send break

	   if (mode(1 downto 0) = "00") then	-- if Sync mode

	     if (CTS_BAR = '0') and (command(0) = '1') then   -- if Tx enabled

		-- SEND SYNC1
  
	       serial_Tx_buffer := SYNC1;
	       store_Tx_buffer := SYNC1;		-- for parity
	       char_bit_count := chars;      

		   -- SEND CHARACTER BITS
		
		   -- Loop for counting number of character bits

	       while ( char_bit_count /= "0000") loop	
		
		  char_bit_count := char_bit_count - "0001";
		  clk_count := baud_clocks;

			 -- Loop for counting number of clock cycles per bit
			 -- (according to baud rate)

		  while ( clk_count /= "00000000") loop
		    TxD <= serial_Tx_buffer(0);
		    wait until (TxC_BAR = '0') and (not TxC_BAR'stable);
		    clk_count := clk_count - "00000001";
		  end loop;

		  serial_Tx_buffer := '0' & serial_Tx_buffer(7 downto 1);

	       end loop;

               if (mode(4) = '1') then		       -- if parity enabled

					-- CALCULATE PARITY BIT

	          parity :=     store_Tx_buffer(0) xor store_Tx_buffer(1) xor	       		               store_Tx_buffer(2) xor store_Tx_buffer(3) xor			              store_Tx_buffer(4) xor store_Tx_buffer(5) xor				     store_Tx_buffer(6) xor store_Tx_buffer(7) xor				    (not mode(5));	-- even/odd parity

	          clk_count := baud_clocks;		

			 -- SEND PARITY BIT

			 -- Loop for counting number of clock cycles per bit
			 -- (according to baud rate)

	          while ( clk_count /= "00000000") loop
	            TxD <= parity;		
                    wait until (TxC_BAR = '0') and (not TxC_BAR'stable);
	            clk_count := clk_count - "00000001";
	          end loop;	     

	       end if;	  			       -- end if parity enabled

	       if (mode(7) = '0') then			-- if Double Sync
					 -- SEND SYNC2 char

 	         serial_Tx_buffer := SYNC2;		
       	         store_Tx_buffer := SYNC2;		-- for parity
	         char_bit_count := chars;      

 		         -- SEND CHARACTER BITS

 		         -- Loop for counting number of character bits

	         while ( char_bit_count /= "0000") loop 
		
		    char_bit_count := char_bit_count - "0001";
		    clk_count := baud_clocks;

			 -- Loop for counting number of clock cycles per bit
			 -- (according to baud rate)

		    while ( clk_count /= "00000000") loop
		      TxD <= serial_Tx_buffer(0);
		      wait until (TxC_BAR = '0') and (not TxC_BAR'stable);
		      clk_count := clk_count - "00000001";
		    end loop;

		    serial_Tx_buffer := '0' & serial_Tx_buffer(7 downto 1);

	         end loop;

                 if (mode(4) = '1') then	          -- if parity enabled

					-- CALCULATE PARITY BIT

	            parity :=     store_Tx_buffer(0) xor store_Tx_buffer(1) xor	       		                 store_Tx_buffer(2) xor store_Tx_buffer(3) xor			                store_Tx_buffer(4) xor store_Tx_buffer(5) xor				       store_Tx_buffer(6) xor store_Tx_buffer(7) xor				      (not mode(5));	-- even/odd parity

	            clk_count := baud_clocks;	

		  	 -- SEND PARITY BIT

			 -- Loop for counting number of clock cycles per bit
			 -- (according to baud rate)

	            while ( clk_count /= "00000000") loop
	              TxD <= parity;		
                      wait until (TxC_BAR = '0') and (not TxC_BAR'stable);
	              clk_count := clk_count - "00000001";
	            end loop;	     

	         end if;			     -- end if parity enabled

	       end if;					-- end if Double Sync

	     else					-- if Tx disabled

	        TxD <= '1';			-- Send marking signal

                wait until ( TxC_BAR = '0' ) and ( not TxC_BAR'stable );

	     end if;

	   else 				-- if Async mode

	     TxD <= '1';			-- Send marking signal

             wait until ( TxC_BAR = '0' ) and ( not TxC_BAR'stable );
	
	   end if; 				-- end if Sync mode

	end if;					-- end if send break

      end if;					-- end if Tx_buffer full

   end if;					-- end if reset

 end process transmitter;

-- ********************************************************************

 receiver : process

-- ********************************************************************

 variable serial_Rx_buffer : MVL7_VECTOR(7 downto 0);
 variable sync_shift   	   : MVL7_VECTOR(7 downto 0);
 variable brk_count   	   : MVL7_VECTOR(10 downto 0);
 variable clk_count   	   : MVL7_VECTOR(7 downto 0);
 variable half_baud        : MVL7_VECTOR(7 downto 0);
 variable char_bit_count   : MVL7_VECTOR(3 downto 0);
 variable status_var       : MVL7_VECTOR(7 downto 0);
 
 variable got_sync         : MVL7;	-- This variable is used in enter hunt
					-- mode to check whether
					-- synchronization has been achieved i
					-- (Used in Internal Sync detect Mode)

 variable got_half_sync	   : MVL7;	-- This variable is used in Double
					-- Sync mode (outside hunt mode). Its
					-- assertion means that SYNC1 has been
					-- received and SYNDET_BD should be 
       					-- asserted if SYNC2 is received next
 variable parity	   : MVL7;

 begin

 if ( RESET = '1') or ( command(6) = '1' ) then       -- if reset 

					-- Initialize ports, signals and
					-- variables on reset

   SYNDET_BD_Rx <= '0';
   trigger_SYNDET_BD_Rx <= not(trigger_SYNDET_BD_Rx);
   RxRDY_Rx <= '0';
   trigger_RxRDY_Rx <= not(trigger_RxRDY_Rx);
   got_half_sync := '0';

   wait until (RxC_BAR = '1') and (not RxC_BAR'stable);

 else						      -- if not reset

   if (command(2) = '1') then			      -- if RxENABLE

      if (mode(1 downto 0) = "00") then		      -- if sync mode

	  -- SYNCHRONOUS MODE

	 if (command(7) = '1') then		      -- if ENTER HUNT MODE

	    if (mode(6) = '1') then		      -- if external sync mode

		   -- In External Synchronization mode, the USART tristates
		   -- its own SYNDET_BD output 

	       SYNDET_BD_Rx <= 'Z';
	       wait on SYNDET_BD_Rx; 	--  Only for simulation
					--  (resolution function)
	       trigger_SYNDET_BD_Rx <= not(trigger_SYNDET_BD_Rx);

		  -- USART waits for a rising edge on the SYNDET_BD pin
		  --  (coming externally)

	       wait until (SYNDET_BD = '1') and (not SYNDET_BD'stable);

	       SYNDET_BD_Rx <= '1';
	       trigger_SYNDET_BD_Rx <= not(trigger_SYNDET_BD_Rx);
   	       status_Rx <= status(7) & '1' & status(5 downto 0);
               trigger_status_Rx <= not(trigger_status_Rx);

		  -- After Synchronization is achieved, character assembly
		  -- starts at next clock edge

	       wait until (RxC_BAR = '1') and (not RxC_BAR'stable);

	    else		     		      -- if internal sync mode

		-- In internal synchronization mode, reset the "got_sync" 
		-- variable before entering the loop, to show that
		-- synchronization has'nt yet been achieved

	      got_sync := '0';

		-- Enter "HUNT LOOP" to achieve synchronization

	      while (got_sync = '0') loop 

		  -- Load all zeros into the Rx buffer to avoid false SYNC
		  -- character detection

	        serial_Rx_buffer := "00000000";
		sync_shift := "00000000";
		
		  -- Enter loop to shift in a bit from "RxD" pin at every
		  -- clock edge (i.e. check for SYNC1 at every bit boundary)

	        while ( (SYNC_mask and sync_shift) /= SYNC1) loop

 		  serial_Rx_buffer := RxD & serial_Rx_buffer(7 downto 1);

			-- Format the bits in the receive buffer to facilitate
			-- comparison with SYNC1

		  case (mode(3 downto 2)) is	-- char. length
		     when "00" =>
		      sync_shift := "000" & serial_Rx_buffer(7 downto 3);
		     when "01" =>
		      sync_shift := "00" & serial_Rx_buffer(7 downto 2);
		     when "10" =>
		      sync_shift := "0" & serial_Rx_buffer(7 downto 1);
		     when "11" =>
		      sync_shift := serial_Rx_buffer(7 downto 0);
		     when others =>
		  end case;

                  wait until (RxC_BAR = '1') and (not RxC_BAR'stable);

	        end loop;	     
		
			-- SYNC1 must have been received since 
			-- it got out of above loop. 

			-- parity is not checked for SYNC chars in hunt mode
 
	        if (mode(4) = '1') then		      -- if parity enabled
                  wait until (RxC_BAR = '1') and (not RxC_BAR'stable);
	        end if;				      -- end if parity enabled

	        if (mode(7) = '1') then		      -- if single sync mode

			-- In Single Sync mode, getting SYNC1 means that 
			-- synchronization has been achieved

		  got_sync := '1';
		 
	        else				     -- if double sync mode

			-- In Double sync mode, assemble next character and
			-- compare it to SYNC2 to check for synchronization

  	          serial_Rx_buffer := "00000000";		 
		  char_bit_count := chars;		 

			-- ASSEMBLE POSSIBLE SYNC2 CHARACTER

 		         -- Loop for counting number of character bits

		  while (char_bit_count /= "0000") loop
 		    serial_Rx_buffer := RxD & serial_Rx_buffer(7 downto 1);
		    char_bit_count := char_bit_count - "0001";
                    wait until (RxC_BAR = '1') and (not RxC_BAR'stable);
		  end loop;

			-- ALIGN ASSEMBLED CHARACTER CORRECTLY FOR COMPARISON
			-- WITH SYNC2

		  case (mode(3 downto 2)) is	-- char. length
		     when "00" =>
		      serial_Rx_buffer := "000" & serial_Rx_buffer(7 downto 3);
		     when "01" =>
		      serial_Rx_buffer := "00" & serial_Rx_buffer(7 downto 2);
		     when "10" =>
		      serial_Rx_buffer := "0" & serial_Rx_buffer(7 downto 1);
		     when "11" =>
		      serial_Rx_buffer := serial_Rx_buffer(7 downto 0);
		     when others =>
		  end case;

			-- parity is not checked for SYNC chars in hunt mode

  	          if (mode(4) = '1') then		   -- if parity enabled
                    wait until (RxC_BAR = '1') and (not RxC_BAR'stable);
	          end if;			       -- end if parity enabled

			-- If SYNC2 is received, synchronization has been 
			-- achieved and it should get out of "HUNT LOOP"
			-- Else it re-enters "HUNT LOOP" and looks for SYNC1
			-- again.

		  if (serial_Rx_buffer = SYNC2) then    -- if got sync
		    got_sync := '1';
		  end if;			       -- end if got sync

	        end if;				     -- end if double sync mode

	      end loop;				     -- end while got_sync

		-- Internal Synchronization must have been achieved since it
		-- got out of above loop ("HUNT LOOP").

		-- Assert SYNDET_BD to show that Synchronization has been
		-- achieved

	      SYNDET_BD_Rx <= '1'; 
	      trigger_SYNDET_BD_Rx <= not(trigger_SYNDET_BD_Rx);

	      if (command(0) = '1') then
  	        status_Rx <= status(7) & '1' & status(5 downto 0);
	      else
  	        status_Rx <= status(7) & '1' & status(5 downto 3) & '1' &					status(1 downto 0);
	      end if;

              trigger_status_Rx <= not(trigger_status_Rx);

	    end if;				      -- end if ext sync mode

	 end if;				      -- end if enter hunt mode

	 -- ASSEMBLE CHARACTER

  	 serial_Rx_buffer := "00000000";		 
         char_bit_count := chars;		 

          -- Loop for counting number of character bits

         while (char_bit_count /= "0000") loop	-- ASSEMBLE CHAR
	   serial_Rx_buffer := RxD & serial_Rx_buffer(7 downto 1);
	   char_bit_count := char_bit_count - "0001";
           wait until (RxC_BAR = '1') and (not RxC_BAR'stable);
         end loop;	    

	-- Align assembled character correctly

         case (mode(3 downto 2)) is	-- char. length
	     when "00" =>
		    serial_Rx_buffer := "000" & serial_Rx_buffer(7 downto 3);
      	     when "01" =>
	            serial_Rx_buffer := "00" & serial_Rx_buffer(7 downto 2);
             when "10" =>
	            serial_Rx_buffer := "0" & serial_Rx_buffer(7 downto 1);
	     when "11" =>
	            serial_Rx_buffer := serial_Rx_buffer(7 downto 0);
	     when others =>
          end case;

  	-- CHECK PARITY (IF ENABLED)

  	 if (mode(4) = '1') then		   -- if parity enabled

	    parity := RxD;

	    parity :=  serial_Rx_buffer(0) xor serial_Rx_buffer(1) xor	       		              serial_Rx_buffer(2) xor serial_Rx_buffer(3) xor			             serial_Rx_buffer(4) xor serial_Rx_buffer(5) xor				    serial_Rx_buffer(6) xor serial_Rx_buffer(7) xor		     	           (not mode(5)) xor parity;
						    -- 	PARITY ERROR

		-- Set parity error flag (if error is detected)

	    if (command(0) = '1') then
	      status_Rx <= status(7 downto 4) & parity & status(2 downto 0);
	    else
	      status_Rx <= status(7 downto 4) & parity & '1' & status(1 downto 0);
	    end if;

            trigger_status_Rx <= not(trigger_status_Rx);

            wait until (RxC_BAR = '1') and (not RxC_BAR'stable);

	 end if;			       -- end if parity enabled

         status_var := status;

	  -- CHECK IF SYNC CHARACTER(S) HAVE BEEN DETECTED (THIS CHECKING
	  -- IS ONLY DONE AT "KNOWN" WORD BOUNDARIES)

		 -- if already got SYNC1 in Double Sync Mode

	 if (got_half_sync = '1') then

		  -- if this character is SYNC2

	   if (serial_Rx_buffer = SYNC2) then

		    -- Set SYNDET_BD to signify detection of SYNC1 and SYNC2
		
	      SYNDET_BD_Rx <= '1';
	      trigger_SYNDET_BD_Rx <= not(trigger_SYNDET_BD_Rx);

	      if (command(0) = '1') then
  	        status_var := status_var(7) & '1' & status_var(5 downto 0);
	      else
  	        status_var := status_var(7) & '1' & status_var(5 downto 3) &				      '1' & status_var(1 downto 0);
	      end if;

	   end if;

	   got_half_sync := '0';

	 else		-- if (not received SYNC1) or (Single sync mode)

		  -- if this character is SYNC1

	   if (serial_Rx_buffer = SYNC1) then	

	      if (mode(7) = '0') then		   -- if double sync mode

			-- In Double Sync mode, detection of SYNC1 is not
			-- sufficient to set SYNDET_BD. We need to check
			-- whether the next character is SYNC2
		
		got_half_sync := '1';

	      else				   -- if single sync mode

			-- In Single Sync mode, SYNDET_BD is set if SYNC1 is
			-- received

		SYNDET_BD_Rx <= '1';
	        trigger_SYNDET_BD_Rx <= not(trigger_SYNDET_BD_Rx);

	        if (command(0) = '1') then
  	          status_var := status_var(7) & '1' & status_var(5 downto 0);
	        else
  	          status_var := status_var(7) & '1' & status_var(5 downto 3) &				      '1' & status_var(1 downto 0);
	        end if;

	      end if;		  		   -- end if double sync mode
	   end if;				   -- end if we get SYNC1

	 end if;       		 -- end if already got SYNC1 (in Double Sync)

		-- transfer received character to parallel buffer
	
	 Rx_buffer <= serial_Rx_buffer;

		-- Check if RxRDY was already set (i.e. previous character 
		-- unread by CPU)

         if (status(1) = '1') then

		-- Set Overrun Error flag if previous character was unread

	      if (command(0) = '1') then
	        status_var := status_var(7 downto 5) & '1' &							 status_var(3 downto 0);
	      else
	        status_var := status_var(7 downto 5) & '1' & status_var(3) &					 '1' & status_var(1 downto 0);
	      end if;

         else					     

		-- Set RxRDY to tell CPU to read new character

	      RxRDY_Rx <= '1';
	      trigger_RxRDY_Rx <= not(trigger_RxRDY_Rx);

	      if (command(0) = '1') then
	          status_var := status_var(7 downto 2) & '1' & status_var(0);
	      else
  	          status_var := status_var(7 downto 3) & "11" & status_var(0);
	      end if;

         end if;				       -- end if Rx buffer full

         status_Rx <= status_var;
         trigger_status_Rx <= not(trigger_status_Rx);
	 
      else					      -- if async mode

	  -- ASYNCHRONOUS MODE

		-- Check whether RxD is high. If so, then it is ready to
		-- receive the Start Bit (low) of the next character

	 if (RxD = '1') then		 

		-- Set Break Detect (SYNDET_BD) low if RxD is high

	   brk_count := "00000000000";
	   SYNDET_BD_Rx <= '0';
	   trigger_SYNDET_BD_Rx <= not(trigger_SYNDET_BD_Rx);

	   if (command(0) = '1') then
  	     status_Rx <= status(7) & '0' & status(5 downto 0);
	   else
  	     status_Rx <= status(7) & '0' & status(5 downto 3) & '1' &					 status(1 downto 0);
	   end if;

           trigger_status_Rx <= not(trigger_status_Rx);

	    -- WAIT FOR FALLING EDGE ON RxD (START BIT)
	    -- IN CASE A RESET (INT/EXT) OCCURS, GET OUT OF WAIT

	   wait until ((RxD = '0') and (not RxD'stable)) or (RESET = '1') or (command(6) = '1');

		-- if not reset

	   if ((RESET = '0') and (command(6) = '0')) then 	

	     -- START BIT

	     -- To sample Start Bit at its mid-point (16X or 64X baud rate
	     -- only), wait for half the number of clock cycles per bit 
	     -- (equal to variable "half_baud")
	     -- Note: Variable "half_baud" is 0 for 1X baud rate, so we 
	     --       introduce a separate wait for the 1X mode. (*+*)

	     half_baud := '0' & baud_clocks(7 downto 1);   
	     clk_count := half_baud;			   

	     -- Loop to wait for half the number of clock cycles per bit

	     while (clk_count /= "00000000") loop
	      wait until (RxC_BAR = '1') and (not RxC_BAR'stable);
   	      clk_count := clk_count - "00000001";
	     end loop;

		-- Sample Start Bit at its mid-point (False Start Bit 
		-- Detection Scheme)

		-- If its a real Start Bit

	     if (RxD = '0') then	

		-- For 1X baud rate, we introduce a separate wait 
		--  (as mentioned above *+*)
		
	       if (mode(1 downto 0) = "01") then 
	         wait until (RxC_BAR = '1') and (not RxC_BAR'stable);
	       end if;

	        -- Loop to wait for half the number of clock cycles per bit

	       clk_count := half_baud;	-- half_baud is 0 for 1X mode

	       while (clk_count /= "00000000") loop
  	         wait until (RxC_BAR = '1') and (not RxC_BAR'stable);
	         clk_count := clk_count - "00000001";
	       end loop;				   -- END OF START BIT

	       brk_count := brk_count + ("000" & baud_clocks);

	       -- ASSEMBLE CHARACTER BITS

     	       serial_Rx_buffer := "00000000";		 
               char_bit_count := chars;		 

	          -- Loop for counting number of character bits

               while (char_bit_count /= "0000") loop      

	     -- To sample a Character Bit at its mid-point (16X or 64X baud
	     -- rate only), wait for half the number of clock cycles per bit 
	     -- (equal to variable "half_baud")
	     -- Note: Variable "half_baud" is 0 for 1X baud rate, so we 
	     --       introduce a separate wait for the 1X mode. (*@*)

	         clk_count := half_baud; 

	            -- Loop to wait for half the number of clock cycles per bit

	         while (clk_count /= "00000000") loop
  	           wait until (RxC_BAR = '1') and (not RxC_BAR'stable);
	           clk_count := clk_count - "00000001";
	         end loop;				   
		
			-- For 1X baud rate, we introduce a separate wait 
			--  (as mentioned above *@*)

	         if (mode(1 downto 0) = "01") then 
	           wait until (RxC_BAR = '1') and (not RxC_BAR'stable);
	         end if;

			-- Sample character bit at its nominal center

		 serial_Rx_buffer := RxD & serial_Rx_buffer(7 downto 1);

		 if (RxD = '1') then		

			-- Set Break Detect (SYNDET_BD) low if RxD is high

		   brk_count := "00000000000";
		   SYNDET_BD_Rx <= '0';
		   trigger_SYNDET_BD_Rx <= not(trigger_SYNDET_BD_Rx);

		   if (command(0) = '1') then
   	             status_var := status(7) & '0' & status(5 downto 0);
		   else
   	             status_var := status(7) & '0' & status(5 downto 3) & '1' &					   status(1 downto 0);
		   end if;

		   status_Rx <= status_var;
                   trigger_status_Rx <= not(trigger_status_Rx);
		 else

			-- If RxD is low, increase "brk_count" by the number
			-- of clock cycles per bit

		   brk_count := brk_count + ("000" & baud_clocks);
		 end if;

	         clk_count := half_baud;   -- NOTE : half_baud = 0 for 1X baud

	           -- Loop to wait for half the number of clock cycles per bit

	         while (clk_count /= "00000000") loop
  	           wait until (RxC_BAR = '1') and (not RxC_BAR'stable);
	           clk_count := clk_count - "00000001";
	         end loop;				   
		  
		 char_bit_count := char_bit_count - "0001";	   
 
               end loop;	         

		-- ALIGN ASSEMBLED CHARACTER CORRECTLY

	       case (mode(3 downto 2)) is	-- char. length
	          when "00" =>
	             serial_Rx_buffer := "000" & serial_Rx_buffer(7 downto 3);
	          when "01" =>
	             serial_Rx_buffer := "00" & serial_Rx_buffer(7 downto 2);
	          when "10" =>
	             serial_Rx_buffer := "0" & serial_Rx_buffer(7 downto 1);
	          when "11" =>
	             serial_Rx_buffer := serial_Rx_buffer(7 downto 0);
	          when others =>
	       end case;

	       -- PARITY BIT

  	       if (mode(4) = '1') then		   -- if parity enabled

	     -- To sample a Parity Bit at its mid-point (16X or 64X baud
	     -- rate only), wait for half the number of clock cycles per bit 
	     -- (equal to variable "half_baud")
	     -- Note: Variable "half_baud" is 0 for 1X baud rate, so we 
	     --       introduce a separate wait for the 1X mode. (*#*)

	         clk_count := half_baud;		

	           -- Loop to wait for half the number of clock cycles per bit

	         while (clk_count /= "00000000") loop
  	           wait until (RxC_BAR = '1') and (not RxC_BAR'stable);
	           clk_count := clk_count - "00000001";
	         end loop;				   

		   -- For 1X baud rate, we introduce a separate wait 
		   --  (as mentioned above *#*)

	         if (mode(1 downto 0) = "01") then 
	           wait until (RxC_BAR = '1') and (not RxC_BAR'stable);
	         end if;

  		   -- CHECK PARITY AT CENTRE OF PARITY BIT

		 parity := RxD;

		 if (RxD = '1') then	

			-- Set Break Detect (SYNDET_BD) low if RxD is high

		   brk_count := "00000000000";
		   SYNDET_BD_Rx <= '0';
		   trigger_SYNDET_BD_Rx <= not(trigger_SYNDET_BD_Rx);

		   if (command(0) = '1') then
  	             status_var := status(7) & '0' & status(5 downto 0);
		   else
  	             status_var := status(7) & '0' & status(5 downto 3) & '1' &					   status(1 downto 0);
		   end if;

		 else

			-- If RxD is low, increase "brk_count" by the number
			-- of clock cycles per bit

		   brk_count := brk_count + ("000" & baud_clocks);
		 end if;

		-- Verify Parity 

	         parity :=  serial_Rx_buffer(0) xor serial_Rx_buffer(1) xor	       		           serial_Rx_buffer(2) xor serial_Rx_buffer(3) xor		                  serial_Rx_buffer(4) xor serial_Rx_buffer(5) xor		                 serial_Rx_buffer(6) xor serial_Rx_buffer(7) xor	          	        (not mode(5)) xor parity;
						    -- 	PARITY ERROR

		 -- Set Parity Error flag if error is detected

		 if (command(0) = '1') then
	         status_var := status_var(7 downto 4) & parity &						 status_var(2 downto 0);
		 else
	         status_var := status_var(7 downto 4) & parity & '1' & 						status_var(1 downto 0);
		 end if;

		 if (mode(1) = '1') then		-- if 16X or 64X baud
		   status_Rx <= status_var;
                   trigger_status_Rx <= not(trigger_status_Rx);
		 end if;

	         clk_count := half_baud; 	-- half_baud = 0 for 1X baud

	           -- Loop to wait for half the number of clock cycles per bit

	         while (clk_count /= "00000000") loop
  	           wait until (RxC_BAR = '1') and (not RxC_BAR'stable);
	           clk_count := clk_count - "00000001";
	         end loop;				   

	       end if;			       -- end if parity enabled

	       -- Transfer received data to parallel buffer

	       Rx_buffer <= serial_Rx_buffer;	

		-- Check if RxRDY was already set (i.e. previous character 
		-- unread by CPU)		 

	       if (status(1) = '1') then	        -- if Rx buffer full
							
		-- Set Overrun Error flag if previous character was unread

		 if (command(0) = '1') then
	         status_var := status_var(7 downto 5) & '1' & 							status_var(3 downto 0);
		 else
	         status_var := status_var(7 downto 5) & '1' & status_var(3)					 & '1' & status_var(1 downto 0);
		 end if;

	       else

		-- Set RxRDY to tell CPU to read new character

	         RxRDY_Rx <= '1';
	         trigger_RxRDY_Rx <= not(trigger_RxRDY_Rx);

		 if (command(0) = '1') then
	           status_var := status_var(7 downto 2) & '1' & status_var(0);
		 else
	           status_var := status_var(7 downto 3) & "11" &						 status_var(0);
		 end if;

	       end if;	   			-- end if already RxRDY

	       status_Rx <= status_var;
               trigger_status_Rx <= not(trigger_status_Rx);

	       -- STOP BIT(S)
	
  	       wait until (RxC_BAR = '1') and (not RxC_BAR'stable);

			 -- check for framing error and break

      	       if (RxD = '1') then	 

			-- Set Break Detect (SYNDET_BD) low if RxD is high

	          brk_count := "00000000000";
	          SYNDET_BD_Rx <= '0';
                  trigger_SYNDET_BD_Rx <= not(trigger_SYNDET_BD_Rx);

		  if (command(0) = '1') then
  	            status_Rx <= status(7) & '0' & status(5 downto 0);
		  else
  	            status_Rx <= status(7) & '0' & status(5 downto 3) & '1' &					 status(1 downto 0);
		  end if;

                  trigger_status_Rx <= not(trigger_status_Rx);

	       else

			-- If RxD is low, set framing error flag. 

		  if (command(0) = '1') then
	            status_Rx <= status(7 downto 6) & '1' & status(4 downto 0);
		  else
	            status_Rx <= status(7 downto 6) & '1' & status(4 downto 3)					 & '1' & status(1 downto 0);
		  end if;

                  trigger_status_Rx <= not(trigger_status_Rx);

			-- Increase "brk_count" by the number
			-- of clock cycles per bit.

	          brk_count := brk_count + ("000" & stop_clocks);

	       end if;

	     end if;			      -- end if its an actual start bit

	   end if;					    -- end if not reset

	 else			       -- if not yet ready to receive start bit
				       --   (i.e. RxD is low)

	   wait until (RxC_BAR = '1') and (not RxC_BAR'stable);

	   if (RxD = '0') then	   -- if still not ready to receive start bit 

		-- RxD has been low for one more clock cycle.
		-- So increment "brk_count"

	      brk_count := brk_count + "00000000001";

		-- If RxD has stayed low for two consecutive character 
		-- sequence lengths, set Break Detect (SYNDET_BD)

	      if (brk_count >= brk_clocks) then	    
		SYNDET_BD_Rx <= '1';
	        trigger_SYNDET_BD_Rx <= not(trigger_SYNDET_BD_Rx);

		if (command(0) = '1') then
   	          status_Rx <= status(7) & '1' & status(5 downto 0);
		else
   	          status_Rx <= status(7) & '1' & status(5 downto 3) & '1' &					status(1 downto 0);
		end if;

                trigger_status_Rx <= not(trigger_status_Rx);
	      end if;				    -- end if break detected

	   end if;	       -- end if still not ready to receive start bit 

	 end if;			   -- end if ready to receive start bit

      end if;					      -- end if sync mode

   else						      -- if Rx disabled

	-- Reset RxRDY if receiver is disabled

      RxRDY_Rx <= '0';
      trigger_RxRDY_Rx <= not(trigger_RxRDY_Rx);

      wait until (RxC_BAR = '1') and (not RxC_BAR'stable);

   end if;					      -- end if RxENABLE

 end if;					      -- end if reset

 end process receiver;

-- ********************************************************************

 triggering : block

-- ********************************************************************

 begin

	-- The signal "status" and the ports "SYNDET_BD, RxRDY" are written
	-- to by more than one process. So, we split them up into many
	-- "sub-signals" (one for each writing-process).

	-- Whenever any process writes to its own "sub-signal", we assign the
	-- new value to the actual signal. This "writing" is monitored by the
	-- trigger signals.

	-- Whenever the signal has to be read, we read the actual signal and
	-- not the "sub-signal".
								       
 status <= status_main when (not trigger_status_main'stable) else
	   status_Rx when (not trigger_status_Rx'stable) else
	   status_Tx when (not trigger_status_Tx'stable) else
	   status;

 SYNDET_BD_temp <= SYNDET_BD_main when (not trigger_SYNDET_BD_main'stable) else
       	           SYNDET_BD_Rx when (not trigger_SYNDET_BD_Rx'stable) else
 	           SYNDET_BD_temp;

 SYNDET_BD <= SYNDET_BD_temp;

 RxRDY <= RxRDY_main when (not trigger_RxRDY_main'stable) else
   	  RxRDY_Rx when (not trigger_RxRDY_Rx'stable) else
          status(1);	-- RxRDY

 end block triggering;

-- ********************************************************************

 TxRDY_pin : block

-- ********************************************************************

 begin

	-- TxRDY pin is dependent on CTS_BAR and TxENABLE, in addition to
	-- the TxRDY status bit. 
	-- Since CTS_BAR can change at any time, we use a separate block for
	-- this.

 TxRDY <= (not CTS_BAR) and command(0) and status(0);

 end block TxRDY_pin;

-- ********************************************************************
	
 end USART;
