--------------------------------------------------------------------------------
--
--   Intel 8251 Benchmark -- Main
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
	CLK 	 	 : in clock;
	RESET 	 	 : in MVL7;
	CS_BAR 	 	 : in MVL7;
	C_D_BAR  	 : in MVL7;
	RD_BAR 	 	 : in MVL7;
	WR_BAR 	 	 : in MVL7;
	DSR_BAR   	 : in MVL7;
	CTS_BAR   	 : in MVL7;
        Rx_buffer   	 : in MVL7_VECTOR(7 downto 0);
	D_0	 	 : inout MVL7;
	D_1	 	 : inout MVL7;
	D_2	 	 : inout MVL7;
	D_3	  	 : inout MVL7;
	D_4	 	 : inout MVL7;
	D_5	 	 : inout MVL7;
	D_6	  	 : inout MVL7;
	D_7	 	 : inout MVL7;
	SYNDET_BD 	 : inout MVL7;			 
	RxRDY     	 : out MVL7;			 
	DTR_BAR   	 : out MVL7;
	RTS_BAR   	 : out MVL7;
        Tx_wr_while_cts  : out MVL7;
        mode	    	 : out MVL7_VECTOR(7 downto 0);
        command	    	 : out MVL7_VECTOR(7 downto 0);
        SYNC1	    	 : out MVL7_VECTOR(7 downto 0);
        SYNC2	    	 : out MVL7_VECTOR(7 downto 0);
        SYNC_mask	 : out MVL7_VECTOR(7 downto 0);
        Tx_buffer   	 : out MVL7_VECTOR(7 downto 0);
        status   	 : out MVL7_VECTOR(7 downto 0);
        baud_clocks	 : out MVL7_VECTOR(7 downto 0);
        stop_clocks	 : out MVL7_VECTOR(7 downto 0);
        brk_clocks	 : out MVL7_VECTOR(10 downto 0);
        chars            : out MVL7_VECTOR(3 downto 0)
      );
 end;

 architecture USART of Intel_8251 is

 signal status_main	 : MVL7_VECTOR(7 downto 0); 
 signal RxRDY_main	 : MVL7;		
 signal SYNDET_BD_main	 : MVL7;		

 signal trigger_status_main    : MVL7 := '0'; 
 signal trigger_RxRDY_main     : MVL7 := '0';
 signal trigger_SYNDET_BD_main : MVL7 := '0';

 begin

-- ********************************************************************

 trigerring : block

-- ********************************************************************

 begin

 status <= status_main;

 RxRDY <= RxRDY_main;

 SYNDET_BD <= SYNDET_BD_main;

 end block trigerring;

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
					-- 00 = mode
					-- 01 = SYNC CHAR 1
					-- 10 = SYNC CHAR 2
					-- 11 = command
   variable SYNC_var       : MVL7_VECTOR(7 downto 0);
   variable temp   	   : MVL7_VECTOR(10 downto 0);

 begin

 wait until ( clk = '1' ) and ( not clk'stable );

 if (CS_BAR = '0') then			-- if chip select

   if ( RESET = '1') or ( command_var(6) = '1' ) then       -- if reset

	DTR_BAR <= '1';
	RTS_BAR <= '1';
	next_cpu_control_word := "00";
	status_var := "00000101"; 
	command_var := "00000000";
	status_main <= status_var;
	trigger_status_main <= not(trigger_status_main);
	command <= command_var;
        Tx_wr_while_cts <= '0';

   else					-- if not reset

	if (RD_BAR = '0') then		-- if read

	  if (C_D_BAR = '1') then	-- if read status

	     status_var := not(DSR_BAR) & status_main(6 downto 0);

	     D_0 <= status_var(0);
	     D_1 <= status_var(1);
	     D_2 <= status_var(2);
	     D_3 <= status_var(3);
	     D_4 <= status_var(4);
	     D_5 <= status_var(5);
	     D_6 <= status_var(6);
	     D_7 <= status_var(7);
	     
	     if ( mode_var(1 downto 0) = "00") then	   -- Sync mode
		SYNDET_BD_main <= '0';
		trigger_SYNDET_BD_main <= not(trigger_SYNDET_BD_main);
		status_var := status_main(7) & '0' & status_main(5 downto 0);
				-- reset SYNDET on status read
		status_main <= status_var;
		trigger_status_main <= not(trigger_status_main);
	     end if;	     

	  else				-- if read Rx data

	     if (command_var(2) = '1') then  -- if RxENABLE 

	        D_0 <= Rx_buffer(0);
	        D_1 <= Rx_buffer(1);
	        D_2 <= Rx_buffer(2);
	        D_3 <= Rx_buffer(3);
	        D_4 <= Rx_buffer(4);
	        D_5 <= Rx_buffer(5);
	        D_6 <= Rx_buffer(6);
	        D_7 <= Rx_buffer(7);

	        RxRDY_main <= '0';	
	        trigger_RxRDY_main <= not(trigger_RxRDY_main);
		status_var := status_main(7 downto 2) & '0' & status_main(0); -- RxRDY
		status_main <= status_var;
		trigger_status_main <= not(trigger_status_main);

	     end if;

	  end if;			-- end if command/data

	elsif (WR_BAR = '0') then		-- if write

	  D_0 <= 'Z';
          D_1 <= 'Z'; 
          D_2 <= 'Z';
          D_3 <= 'Z';
          D_4 <= 'Z';
          D_5 <= 'Z';
          D_6 <= 'Z';
          D_7 <= 'Z';

	  wait for 0 ns;	-- only for simulation ( resolution function)

	  if (C_D_BAR = '1') then	-- if write command/mode/sync-char

	     case (next_cpu_control_word) is

		when "00" =>	-- next_cpu_control_word = mode

		  mode_var(0) := D_0;
		  mode_var(1) := D_1;
		  mode_var(2) := D_2;
		  mode_var(3) := D_3;
		  mode_var(4) := D_4;
		  mode_var(5) := D_5;
		  mode_var(6) := D_6;
		  mode_var(7) := D_7;

		  mode <= mode_var;

		  -- no. of char bits

		  chars_var := "0101" + ("00" & mode_var(3 downto 2) ); 
	          chars <= chars_var;	-- no. of char bits

		  if ( mode_var(1 downto 0) = "00") then   -- Sync mode

		     if ( mode_var(6) = '1') then	     -- Ext Sync Mode
		       next_cpu_control_word := "11";	-- command word
		     else				     -- Int Sync Mode
		       next_cpu_control_word := "01";	-- SYNC1
		     end if;

		     stop_clocks <= "00000000";
		     stop_clocks_var := "00000000";
		     baud_clocks <= "00000001";
		     baud_clocks_var := "00000001";

		  else					   -- Async mode

		     next_cpu_control_word := "11";	-- command
		     
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
		
		     case ( mode_var(7 downto 6)) is	-- set stop bit clks
			when "00" =>

			when "01" =>
					stop_clocks_var := baud_clocks_var;
					stop_clocks <= stop_clocks_var;
			when "10" =>
					stop_clocks_var :=				 baud_clocks_var(7 downto 0) + ( '0' & baud_clocks_var(7 downto 1) );
					stop_clocks <= stop_clocks_var; 
			when "11" =>
					stop_clocks_var := 								 baud_clocks_var(6 downto 0) & '0';
					stop_clocks <= stop_clocks_var;
			when others =>

		     end case;

		-- Calculate no. of clocks that RxD has to be low for BRKDET

		-- Start bit clocks

		     temp := "000" & baud_clocks_var;

		-- Char bit clocks

		     while ( chars_var /= "0000") loop
			temp := temp + ( "000" & baud_clocks_var);
			chars_var := chars_var - "0001";
		     end loop;

		-- Parity bit clocks

		     if (mode_var(4) = '1') then	-- Parity enable
			temp := temp + ( "000" & baud_clocks_var);
		     end if;

		-- Stop bit clocks

		     temp := temp + ( "000" & stop_clocks_var);

		-- Double this number (RxD has to be low thru 2 sequences)

		     brk_clocks <= temp(9 downto 0) & '0';

		  end if;				-- end if sync mode

		when "01" =>	-- next_cpu_control_word = SYNC-CHAR 1

		  SYNC_var(0) := D_0;
		  SYNC_var(1) := D_1;
		  SYNC_var(2) := D_2;
		  SYNC_var(3) := D_3;
		  SYNC_var(4) := D_4;
		  SYNC_var(5) := D_5;
		  SYNC_var(6) := D_6;
		  SYNC_var(7) := D_7;
		  
		  if (mode_var(7) = '0') then	-- Double SYNC char
		     next_cpu_control_word := "10";
		  else
		     next_cpu_control_word := "11";
		  end if;	

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

		  SYNC_var(0) := D_0;
		  SYNC_var(1) := D_1;
		  SYNC_var(2) := D_2;
		  SYNC_var(3) := D_3;
		  SYNC_var(4) := D_4;
		  SYNC_var(5) := D_5;
		  SYNC_var(6) := D_6;
		  SYNC_var(7) := D_7;

		  next_cpu_control_word := "11";

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

		  command_var(0) := D_0;
		  command_var(1) := D_1;
		  command_var(2) := D_2;
		  command_var(3) := D_3;
		  command_var(4) := D_4;
		  command_var(5) := D_5;
		  command_var(6) := D_6;
		  command_var(7) := D_7;

		  command <= command_var;
		  next_cpu_control_word := "11";
		  status_var := status_main;

		  if (command_var(2) = '0') then	-- RxENABLE
		     RxRDY_main <= '0';
		     trigger_RxRDY_main <= not(trigger_RxRDY_main);
		     status_var := status_main(7 downto 2) & '0' & status_main(0);
		  end if;

		  if (command_var(4) = '1') then	-- error reset
		     status_var := status_var(7 downto 6) & "000" & 						  status_var(2 downto 0);	
		  end if;

		  status_main <= status_var;
	  	  trigger_status_main <= not(trigger_status_main);
		  RTS_BAR <= not(command_var(5));
		  DTR_BAR <= not(command_var(1)) ;

		when others =>	

	     end case;

	  else				-- if write data for Tx

             if (command_var(0) = '1') then		-- if TxENABLE

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

		status_var := status_main(7 downto 1) & '0';  -- TxRDY
		status_main <= status_var;
		trigger_status_main <= not(trigger_status_main);

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

 end USART;

