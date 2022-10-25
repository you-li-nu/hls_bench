--------------------------------------------------------------------------------
--
--   Intel 8251 Benchmark -- Transmitter 
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

-- library ZYCAD;
use work.types.all;
use work.MVL7_functions.all;
use work.synthesis_types.all;

 entity Intel_8251 is
 port (
	TxC_BAR   	 : in clock;
	RESET 	  	 : in MVL7;
	CTS_BAR   	 : in MVL7;
        mode	    	 : in MVL7_VECTOR(7 downto 0);
        baud_clocks	 : in MVL7_VECTOR(7 downto 0);
        stop_clocks	 : in MVL7_VECTOR(7 downto 0);
        chars            : in MVL7_VECTOR(3 downto 0);
        SYNC1	    	 : in MVL7_VECTOR(7 downto 0);
        SYNC2	    	 : in MVL7_VECTOR(7 downto 0);
        SYNC_mask	 : in MVL7_VECTOR(7 downto 0);
        command	    	 : in MVL7_VECTOR(7 downto 0);
        Tx_buffer   	 : in MVL7_VECTOR(7 downto 0);
        Tx_wr_while_cts  : in MVL7;
	TxD  	  	 : out MVL7;
	TxEMPTY   	 : out MVL7;			  
	TxRDY 	  	 : out MVL7;
        status	  	 : in MVL7_VECTOR(7 downto 0);
        trigger_status 	 : in MVL7
      );
 end;

 architecture USART of Intel_8251 is

 signal trigger_status_Tx : MVL7 := '0';
 signal status_sig : MVL7_VECTOR(7 downto 0);
 signal status_Tx : MVL7_VECTOR(7 downto 0);

 begin

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

      TxD <= '1';					-- marking
      TxEMPTY <= '1';
      status_Tx <= status_sig(7 downto 3) & '1' & status_sig(1 downto 0);
      trigger_status_Tx <= not(trigger_status_Tx);

      wait until ( TxC_BAR = '0' ) and ( not TxC_BAR'stable );

   else

      if (status_sig(0) = '0') then       -- if Tx_buffer full (TxRDY status bit)

	if ( ( (CTS_BAR = '0') and (command(0) = '1') ) or				    ( Tx_wr_while_cts = '1' ) ) then   -- if Tx enable or
		       		      -- data was written while it was enabled

	  serial_Tx_buffer := Tx_buffer;
	  store_Tx_buffer := Tx_buffer;		-- used for parity computation
	  TxEMPTY <= '0';

	  if (command(2) = '1') then
	    status_Tx  <= status_sig(7 downto 3) & '0' & status_sig(1) & '1';
	  else
	    status_Tx  <= status_sig(7 downto 3) & "001";
	  end if;

          trigger_status_Tx <= not(trigger_status_Tx);
			-- TxRDY  and TxEMPTY status bits

	  if (mode(1 downto 0) /= "00") then	-- if async mode (start)

	     clk_count := baud_clocks;		-- SEND START BIT

	     while ( clk_count /= "00000000") loop
	       TxD <= '0';		
	       wait until (TxC_BAR = '0') and (not TxC_BAR'stable);
	       clk_count := clk_count - "00000001";
	     end loop;	     

	  end if;				-- end if async mode (start)

	  char_bit_count := chars;      -- SEND CHARACTER BITS

	  while ( char_bit_count /= "0000") loop
		
             char_bit_count := char_bit_count - "0001";
	     clk_count := baud_clocks;

             while ( clk_count /= "00000000") loop
	       TxD <= serial_Tx_buffer(0);
               wait until (TxC_BAR = '0') and (not TxC_BAR'stable);
	       clk_count := clk_count - "00000001";
	     end loop;

	     serial_Tx_buffer := '0' & serial_Tx_buffer(7 downto 1);

          end loop;

	  if (mode(4) = '1') then		       -- if parity enabled

	    parity :=   store_Tx_buffer(0) xor store_Tx_buffer(1) xor	       		               store_Tx_buffer(2) xor store_Tx_buffer(3) xor			              store_Tx_buffer(4) xor store_Tx_buffer(5) xor				     store_Tx_buffer(6) xor store_Tx_buffer(7) xor				    (not mode(5));	-- even/odd parity

	    clk_count := baud_clocks;		-- SEND PARITY BIT

	    while ( clk_count /= "00000000") loop
	      TxD <= parity;		
              wait until (TxC_BAR = '0') and (not TxC_BAR'stable);
	      clk_count := clk_count - "00000001";
	    end loop;	     

	  end if;	  			       -- end if parity enabled

	  if ( not((((CTS_BAR = '0') and (command(0) = '1')) or 				   (Tx_wr_while_cts = '1')) and (status_sig(0) = '0'))) then
			         -- if data written and Tx enable
			         -- (or Tx was enabled when data was written)
	     TxEMPTY <= '1';
	     status_Tx  <= status_sig(7 downto 3) & '1' &							 status_sig(1 downto 0);
             trigger_status_Tx <= not(trigger_status_Tx);

	  end if;

	  if (mode(1 downto 0) /= "00") then	-- if async mode (stop)

	     clk_count := stop_clocks;		-- SEND STOP BIT

	     while ( clk_count /= "00000000") loop
	       TxD <= '1';		
	       wait until (TxC_BAR = '0') and (not TxC_BAR'stable);
	       clk_count := clk_count - "00000001";
	     end loop;	     

	  end if;				-- end if async mode (stop)

	else   -- if Tx not enable or data was written while it was not enabled

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

	       serial_Tx_buffer := SYNC1;
	       store_Tx_buffer := SYNC1;		-- for parity
	       char_bit_count := chars;      

	       while ( char_bit_count /= "0000") loop	  -- SEND SYNC1 char
		
		  char_bit_count := char_bit_count - "0001";
		  clk_count := baud_clocks;

		  while ( clk_count /= "00000000") loop
		    TxD <= serial_Tx_buffer(0);
		    wait until (TxC_BAR = '0') and (not TxC_BAR'stable);
		    clk_count := clk_count - "00000001";
		  end loop;

		  serial_Tx_buffer := '0' & serial_Tx_buffer(7 downto 1);

	       end loop;

               if (mode(4) = '1') then		       -- if parity enabled

	          parity :=     store_Tx_buffer(0) xor store_Tx_buffer(1) xor	       		               store_Tx_buffer(2) xor store_Tx_buffer(3) xor			              store_Tx_buffer(4) xor store_Tx_buffer(5) xor				     store_Tx_buffer(6) xor store_Tx_buffer(7) xor				    (not mode(5));	-- even/odd parity

	          clk_count := baud_clocks;		-- SEND PARITY BIT

	          while ( clk_count /= "00000000") loop
	            TxD <= parity;		
                    wait until (TxC_BAR = '0') and (not TxC_BAR'stable);
	            clk_count := clk_count - "00000001";
	          end loop;	     

	       end if;	  			       -- end if parity enabled

	       if (mode(7) = '0') then			-- if Double Sync

 	         serial_Tx_buffer := SYNC2;		
       	         store_Tx_buffer := SYNC2;		-- for parity
	         char_bit_count := chars;      

	         while ( char_bit_count /= "0000") loop  -- SEND SYNC2 char
		
		    char_bit_count := char_bit_count - "0001";
		    clk_count := baud_clocks;

		    while ( clk_count /= "00000000") loop
		      TxD <= serial_Tx_buffer(0);
		      wait until (TxC_BAR = '0') and (not TxC_BAR'stable);
		      clk_count := clk_count - "00000001";
		    end loop;

		    serial_Tx_buffer := '0' & serial_Tx_buffer(7 downto 1);

	         end loop;

                 if (mode(4) = '1') then	          -- if parity enabled

	            parity :=     store_Tx_buffer(0) xor store_Tx_buffer(1) xor	       		                 store_Tx_buffer(2) xor store_Tx_buffer(3) xor			                store_Tx_buffer(4) xor store_Tx_buffer(5) xor				       store_Tx_buffer(6) xor store_Tx_buffer(7) xor				      (not mode(5));	-- even/odd parity

	            clk_count := baud_clocks;		-- SEND PARITY BIT

	            while ( clk_count /= "00000000") loop
	              TxD <= parity;		
                      wait until (TxC_BAR = '0') and (not TxC_BAR'stable);
	              clk_count := clk_count - "00000001";
	            end loop;	     

	         end if;			     -- end if parity enabled

	       end if;					-- end if Double Sync

	     else					-- if Tx disabled

	        TxD <= '1';			-- mark

                wait until ( TxC_BAR = '0' ) and ( not TxC_BAR'stable );

	     end if;

	   else 				-- if Async mode

	     TxD <= '1';			-- mark

             wait until ( TxC_BAR = '0' ) and ( not TxC_BAR'stable );
	
	   end if; 				-- end if Sync mode

	end if;					-- end if send break

      end if;					-- end if Tx_buffer full

   end if;					-- end if reset

 end process transmitter;

-- ********************************************************************

 triggering : block

-- ********************************************************************

 begin

 status_sig <= status_Tx when (not trigger_status_Tx'stable) else
	       status when (trigger_status = '1') else
	       status_sig;

 end block triggering;

-- ********************************************************************

 TxRDY_pin : block

-- ********************************************************************

 begin

	-- TxRDY pin is dependent on CTS_BAR and TxENABLE, in addition to
	-- the TxRDY status bit. 
	-- Since CTS_BAR can change at any time, we use a separate block for
	-- this.

 TxRDY <= (not CTS_BAR) and command(0) and status_sig(0);

 end block TxRDY_pin;

-- ********************************************************************
	
 end USART;
