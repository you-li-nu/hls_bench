--------------------------------------------------------------------------------
--
--   Intel 8251 Benchmark -- Receiver
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
	RxC_BAR          : in clock;
	RESET 	         : in MVL7;
	RxD 	         : in MVL7;
        mode	    	 : in MVL7_VECTOR(7 downto 0);
        command	         : in MVL7_VECTOR(7 downto 0);
        SYNC1	    	 : in MVL7_VECTOR(7 downto 0);
        SYNC2	    	 : in MVL7_VECTOR(7 downto 0);
        SYNC_mask	 : in MVL7_VECTOR(7 downto 0);
        baud_clocks	 : in MVL7_VECTOR(7 downto 0);
        stop_clocks	 : in MVL7_VECTOR(7 downto 0);
        brk_clocks	 : in MVL7_VECTOR(10 downto 0);
        chars            : in MVL7_VECTOR(3 downto 0);
        status_in	 : in MVL7_VECTOR(7 downto 0); 
        trigger_status   : in MVL7;
	SYNDET_BD        : inout MVL7;			 
	RxRDY            : out MVL7;			 
        status_out	 : out MVL7_VECTOR(7 downto 0); 
        Rx_buffer   	 : out MVL7_VECTOR(7 downto 0)
      );
 end;

 architecture USART of Intel_8251 is

 signal status_Rx	       : MVL7_VECTOR(7 downto 0); 
 signal status_sig	       : MVL7_VECTOR(7 downto 0); 
 signal SYNDET_BD_temp	       : MVL7;       
 signal SYNDET_BD_Rx	       : MVL7;	
 signal RxRDY_Rx	       : MVL7;		
 signal trigger_status_Rx      : MVL7 := '0';
 signal trigger_SYNDET_BD_Rx   : MVL7 := '0';
 signal trigger_RxRDY_Rx       : MVL7 := '0';
					 
 begin

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
					-- mode to check whether sync has been
					-- detected (in internal sync mode).

 variable got_half_sync	   : MVL7;	-- This variable is used in Double
					-- Sync mode (outside hunt mode). Its
					-- assertion means that SYNC1 has been
					-- received and SYNDET_BD should be 
       					-- asserted if SYNC2 is received
 variable parity	   : MVL7;

 begin

 if ( RESET = '1') or ( command(6) = '1' ) then       -- if reset 

   SYNDET_BD_Rx <= '0';
   trigger_SYNDET_BD_Rx <= not(trigger_SYNDET_BD_Rx);
   RxRDY_Rx <= '0';
   trigger_RxRDY_Rx <= not(trigger_RxRDY_Rx);
   got_half_sync := '0';

   wait until (RxC_BAR = '1') and (not RxC_BAR'stable);

 else						      -- if not reset

   if (command(2) = '1') then			      -- if RxENABLE

      if (mode(1 downto 0) = "00") then		      -- if sync mode

	 if (command(7) = '1') then		      -- if enter hunt mode

	    if (mode(6) = '1') then		      -- if external sync mode

	       SYNDET_BD_Rx <= 'Z';
	       wait on SYNDET_BD_Rx;
	       trigger_SYNDET_BD_Rx <= not(trigger_SYNDET_BD_Rx);

	       wait until (SYNDET_BD = '1') and (not SYNDET_BD'stable);

	       SYNDET_BD_Rx <= '1';
	       trigger_SYNDET_BD_Rx <= not(trigger_SYNDET_BD_Rx);
   	       status_Rx <= status_sig(7) & '1' & status_sig(5 downto 0);
               trigger_status_Rx <= not(trigger_status_Rx);

	       wait until (RxC_BAR = '1') and (not RxC_BAR'stable);
 
	    else		     		      -- if internal sync mode

	      got_sync := '0';

	      while (got_sync = '0') loop 		-- while got_sync

	        serial_Rx_buffer := "00000000";
		sync_shift := "00000000";
		
	        while ( (SYNC_mask and sync_shift) /= SYNC1) loop

 		  serial_Rx_buffer := RxD & serial_Rx_buffer(7 downto 1);

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
 
	        if (mode(4) = '1') then		      -- if parity enabled
                  wait until (RxC_BAR = '1') and (not RxC_BAR'stable);
			-- parity is not checked for SYNC chars in hunt mode
	        end if;				      -- end if parity enabled

	        if (mode(7) = '1') then		      -- if single sync mode

		  got_sync := '1';
		 
	        else				     -- if double sync mode

  	          serial_Rx_buffer := "00000000";		 
		  char_bit_count := chars;		 

			-- ASSEMBLE POSSIBLE SYNC2 CHARACTER

		  while (char_bit_count /= "0000") loop
 		    serial_Rx_buffer := RxD & serial_Rx_buffer(7 downto 1);
		    char_bit_count := char_bit_count - "0001";
                    wait until (RxC_BAR = '1') and (not RxC_BAR'stable);
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

  	          if (mode(4) = '1') then		   -- if parity enabled
                    wait until (RxC_BAR = '1') and (not RxC_BAR'stable);
			-- parity is not checked for SYNC chars in hunt mode
	          end if;			       -- end if parity enabled
		 
		  if (serial_Rx_buffer = SYNC2) then    -- if got sync
		    got_sync := '1';
		  end if;			       -- end if got sync

	        end if;				     -- end if double sync mode

	      end loop;				     -- end while got_sync

	      SYNDET_BD_Rx <= '1'; 
	      trigger_SYNDET_BD_Rx <= not(trigger_SYNDET_BD_Rx);

	      if (command(0) = '1') then
  	        status_Rx <= status_sig(7) & '1' & status_sig(5 downto 0);
	      else
  	        status_Rx <= status_sig(7) & '1' & status_sig(5 downto 3) &				     '1' & status_sig(1 downto 0);
	      end if;

              trigger_status_Rx <= not(trigger_status_Rx);

	    end if;				      -- end if ext sync mode

	 end if;				      -- end if enter hunt mode

  	 serial_Rx_buffer := "00000000";		 
         char_bit_count := chars;		 

         while (char_bit_count /= "0000") loop	-- ASSEMBLE CHAR
	   serial_Rx_buffer := RxD & serial_Rx_buffer(7 downto 1);
	   char_bit_count := char_bit_count - "0001";
           wait until (RxC_BAR = '1') and (not RxC_BAR'stable);
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

  	 if (mode(4) = '1') then		   -- if parity enabled

	    parity := RxD;

	    parity :=  serial_Rx_buffer(0) xor serial_Rx_buffer(1) xor	       		              serial_Rx_buffer(2) xor serial_Rx_buffer(3) xor			             serial_Rx_buffer(4) xor serial_Rx_buffer(5) xor				    serial_Rx_buffer(6) xor serial_Rx_buffer(7) xor		     	           (not mode(5)) xor parity;
						    -- 	PARITY ERROR

	    if (command(0) = '1') then
	      status_Rx <= status_sig(7 downto 4) & parity &						    status_sig(2 downto 0);
	    else
	      status_Rx <= status_sig(7 downto 4) & parity & '1' &					    status_sig(1 downto 0);
	    end if;

            trigger_status_Rx <= not(trigger_status_Rx);

            wait until (RxC_BAR = '1') and (not RxC_BAR'stable);

	 end if;			       -- end if parity enabled

         status_var := status_sig;

	 if (got_half_sync = '1') then -- if already got SYNC1 (in Double Sync)

	   if (serial_Rx_buffer = SYNC2) then
	      SYNDET_BD_Rx <= '1';
	      trigger_SYNDET_BD_Rx <= not(trigger_SYNDET_BD_Rx);

	      if (command(0) = '1') then
  	        status_var := status_var(7) & '1' & status_var(5 downto 0);
	      else
  	        status_var := status_var(7) & '1' & status_var(5 downto 3) &				      '1' & status_var(1 downto 0);
	      end if;

	   end if;

	   got_half_sync := '0';

	 else				-- if single sync or got SYNC1 (Double)

	   if (serial_Rx_buffer = SYNC1) then	   -- if we get SYNC1
	      if (mode(7) = '0') then		   -- if double sync mode
		got_half_sync := '1';
	      else				   -- if single sync mode
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

	 Rx_buffer <= serial_Rx_buffer;	-- transfer to parallel buffer

         if (status_sig(1) = '1') then		       -- if Rx buffer full
							-- overrun error

	      if (command(0) = '1') then
	        status_var := status_var(7 downto 5) & '1' &							 status_var(3 downto 0);
	      else
	        status_var := status_var(7 downto 5) & '1' & status_var(3) &					 '1' & status_var(1 downto 0);
	      end if;

         else					       -- if Rx buffer empty
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

	 if (RxD = '1') then		       -- if ready to receive start bit

	   brk_count := "00000000000";
	   SYNDET_BD_Rx <= '0';
	   trigger_SYNDET_BD_Rx <= not(trigger_SYNDET_BD_Rx);

	   if (command(0) = '1') then
  	     status_Rx <= status_sig(7) & '0' & status_sig(5 downto 0);
	   else
  	     status_Rx <= status_sig(7) & '0' & status_sig(5 downto 3) & '1' &					 status_sig(1 downto 0);
	   end if;

           trigger_status_Rx <= not(trigger_status_Rx);

	   wait until ((RxD = '0') and (not RxD'stable)) or (RESET = '1') or (command(6) = '1');

	   if ((RESET = '0') and (command(6) = '0')) then 	-- if not reset

	     half_baud := '0' & baud_clocks(7 downto 1);   -- half_baud is 0
	     clk_count := half_baud;			   -- for 1X mode

	     -- START BIT

	     while (clk_count /= "00000000") loop
	      wait until (RxC_BAR = '1') and (not RxC_BAR'stable);
   	      clk_count := clk_count - "00000001";
	     end loop;

	     if (RxD = '0') then	      -- if its an actual start bit
		
	       if (mode(1 downto 0) = "01") then 
					-- IF 1X, WAIT FOR CENTRE OF START BIT
	         wait until (RxC_BAR = '1') and (not RxC_BAR'stable);
	       end if;

	       clk_count := half_baud;	-- half_baud is 0 for 1X mode

	       while (clk_count /= "00000000") loop
  	         wait until (RxC_BAR = '1') and (not RxC_BAR'stable);
	         clk_count := clk_count - "00000001";
	       end loop;				   -- END OF START BIT

	       brk_count := brk_count + ("000" & baud_clocks);

	       -- CHARACTER BITS

     	       serial_Rx_buffer := "00000000";		 
               char_bit_count := chars;		 

               while (char_bit_count /= "0000") loop      -- ASSEMBLE CHAR

	         clk_count := half_baud;   -- NOTE : half_baud = 0 for 1X baud

	         while (clk_count /= "00000000") loop
  	           wait until (RxC_BAR = '1') and (not RxC_BAR'stable);
	           clk_count := clk_count - "00000001";
	         end loop;				   
		   
	         if (mode(1 downto 0) = "01") then 
				    -- IF 1X, WAIT FOR CENTRE OF THIS CHAR BIT
	           wait until (RxC_BAR = '1') and (not RxC_BAR'stable);
	         end if;

					-- STORE CHAR BIT AT CENTRE OF CHAR BIT
		 serial_Rx_buffer := RxD & serial_Rx_buffer(7 downto 1);

		 if (RxD = '1') then		-- check for break
		   brk_count := "00000000000";
		   SYNDET_BD_Rx <= '0';
		   trigger_SYNDET_BD_Rx <= not(trigger_SYNDET_BD_Rx);

		   if (command(0) = '1') then
   	             status_var := status_sig(7) & '0' &								 status_sig(5 downto 0);
		   else
   	             status_var := status_sig(7) & '0' &							   status_sig(5 downto 3) & '1' &						  status_sig(1 downto 0);
		   end if;

		   status_Rx <= status_var;
                   trigger_status_Rx <= not(trigger_status_Rx);
		 else
		   brk_count := brk_count + ("000" & baud_clocks);
		 end if;

	         clk_count := half_baud;   -- NOTE : half_baud = 0 for 1X baud

	         while (clk_count /= "00000000") loop
  	           wait until (RxC_BAR = '1') and (not RxC_BAR'stable);
	           clk_count := clk_count - "00000001";
	         end loop;				   
		  
		 char_bit_count := char_bit_count - "0001";	   
 
               end loop;	          -- ASSEMBLE CHAR

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

	         clk_count := half_baud;		

	         while (clk_count /= "00000000") loop
  	           wait until (RxC_BAR = '1') and (not RxC_BAR'stable);
	           clk_count := clk_count - "00000001";
	         end loop;				   

	         if (mode(1 downto 0) = "01") then 
				    -- IF 1X, WAIT FOR CENTRE OF PARITY BIT
	           wait until (RxC_BAR = '1') and (not RxC_BAR'stable);
	         end if;

					-- CHECK PARITY AT CENTRE OF PARITY BIT
		 parity := RxD;

		 if (RxD = '1') then		-- check for break
		   brk_count := "00000000000";
		   SYNDET_BD_Rx <= '0';
		   trigger_SYNDET_BD_Rx <= not(trigger_SYNDET_BD_Rx);

		   if (command(0) = '1') then
  	             status_var := status_sig(7) & '0' &							    status_sig(5 downto 0);
		   else
  	             status_var := status_sig(7) & '0' &							    status_sig(5 downto 3) & '1' &						   status_sig(1 downto 0);
		   end if;

		 else
		   brk_count := brk_count + ("000" & baud_clocks);
		 end if;

	         parity :=  serial_Rx_buffer(0) xor serial_Rx_buffer(1) xor	       		           serial_Rx_buffer(2) xor serial_Rx_buffer(3) xor		                  serial_Rx_buffer(4) xor serial_Rx_buffer(5) xor		                 serial_Rx_buffer(6) xor serial_Rx_buffer(7) xor	          	        (not mode(5)) xor parity;
						    -- 	PARITY ERROR

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

	         while (clk_count /= "00000000") loop
  	           wait until (RxC_BAR = '1') and (not RxC_BAR'stable);
	           clk_count := clk_count - "00000001";
	         end loop;				   

	       end if;			       -- end if parity enabled
	       
	       Rx_buffer <= serial_Rx_buffer;	-- transfer to parallel buffer
		 
	       if (status_sig(1) = '1') then	        -- if already RxRDY
								--overrun error
		 if (command(0) = '1') then
	         status_var := status_var(7 downto 5) & '1' & 							status_var(3 downto 0);
		 else
	         status_var := status_var(7 downto 5) & '1' & status_var(3)					 & '1' & status_var(1 downto 0);
		 end if;

	       else	   				-- if not already RxRDY
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

      	       if (RxD = '1') then	  -- check for framing error and break
	          brk_count := "00000000000";
	          SYNDET_BD_Rx <= '0';
                  trigger_SYNDET_BD_Rx <= not(trigger_SYNDET_BD_Rx);

		  if (command(0) = '1') then
  	            status_Rx <= status_sig(7) & '0' & status_sig(5 downto 0);
		  else
  	            status_Rx <= status_sig(7) & '0' & status_sig(5 downto 3) 					 & '1' & status_sig(1 downto 0);
		  end if;

                  trigger_status_Rx <= not(trigger_status_Rx);
	       else

		  if (command(0) = '1') then
	            status_Rx <= status_sig(7 downto 6) & '1' &							 status_sig(4 downto 0);
		  else
	            status_Rx <= status_sig(7 downto 6) & '1' &							 status_sig(4 downto 3) & '1' &						        status_sig(1 downto 0);
		  end if;

                  trigger_status_Rx <= not(trigger_status_Rx);
	          brk_count := brk_count + ("000" & stop_clocks);
	       end if;

	     end if;			      -- end if its an actual start bit

	   end if;					    -- end if not reset

	 else			       -- if not yet ready to receive start bit

	   wait until (RxC_BAR = '1') and (not RxC_BAR'stable);

	   if (RxD = '0') then	   -- if not yet ready to receive start bit (2)

	      brk_count := brk_count + "00000000001";

	      if (brk_count >= brk_clocks) then	    -- if break detected
		SYNDET_BD_Rx <= '1';
	        trigger_SYNDET_BD_Rx <= not(trigger_SYNDET_BD_Rx);

		if (command(0) = '1') then
   	          status_Rx <= status_sig(7) & '1' & status_sig(5 downto 0);
		else
   	          status_Rx <= status_sig(7) & '1' & status_sig(5 downto 3) &					 '1' & status_sig(1 downto 0);
		end if;

                trigger_status_Rx <= not(trigger_status_Rx);
	      end if;				    -- end if break detected

	   end if;	       -- end if not yet ready to receive start bit (2)

	 end if;			   -- end if ready to receive start bit

      end if;					      -- end if sync mode

   else						      -- if Rx disabled

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

 status_sig <= status_Rx when (not trigger_status_Rx'stable) else
               status_in when (trigger_status = '1') else
   	       status_sig;

 status_out <= status_sig;

 SYNDET_BD_temp <= SYNDET_BD_Rx when (not trigger_SYNDET_BD_Rx'stable) else
 	           SYNDET_BD_temp;

 SYNDET_BD <= SYNDET_BD_temp;

 RxRDY <= RxRDY_Rx when (not trigger_RxRDY_Rx'stable) else
          status_sig(1);	

 end block triggering;

-- ********************************************************************

 end USART;
