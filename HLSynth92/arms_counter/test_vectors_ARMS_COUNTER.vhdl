--------------------------------------------------------------------------------
--
--   Controller Counter Benchmark -- Simulation Vectors
--
-- Model Source: Chip Level modelling with VHDL by Jim Armstrong
--
-- Authors : Sanjiv Narayan And Frank Vahid
--           University of California, Irvine.
--
-- Written on June 20th 1990
--
-- modified by: Champaka Ramachandran
--              University Of California, Irvine, CA 92717
--              champaka@balboa.eng.uci.edu
-- 
-- Modified on Aug24th 1992
--
-- Verification Information:
--
--                Verified  By whom?               Date       Simulator
--                --------  ------------           --------   ------------
--  Syntax         yes      Champaka Ramachandran  24/8/92     ZYCAD
--  Functionality  yes      Champaka Ramachandran  24/8/92     ZYCAD
--------------------------------------------------------------------------------

entity E is
end;

architecture A of E is
   component ARMS_COUNTER
      port (
            CLK       : in bit; 
            STRB      : in bit; 
            CON       : in bit_vector(1 downto 0);  
            DATA      : in bit_vector(3 downto 0);
            COUT   : out bit_vector(3 downto 0)
	   );
   end component;

   signal CLK       : bit;
   signal STRB      : bit;
   signal CON       : bit_vector (1 downto 0);
   signal DATA      : bit_vector (3 downto 0);
   signal COUT   : bit_vector ( 3 downto 0);

   for all : ARMS_COUNTER use entity work.ARMS_COUNTER(ARMS_COUNTER) ;

begin

   ARMS_COUNTER1 : ARMS_COUNTER port map (CLK, STRB, CON, DATA, COUT);


------- The Clock Process --------------

   process
   begin
      wait for 1 ns;
      CLK <= transport '0';
      wait for 49 ns; 
      CLK <= transport '1';
   end process;

------- The Counter Process --------------

   process 
   begin

      wait for 30 ns;

-- TEST 1 start off with simple test of reset, count up, and count down, and limit

      -- reset the counter
      CON <= "00";
      STRB <= '1' after 10 ns, '0' after 20 ns;
      wait for 50 ns;
      assert (COUT="0000") report "ERROR1: COUT not reset to 0"; 
      
      -- load the LIMIT to 2
      DATA <= "0010";
      CON <= "01";
      STRB <= '1' after 10 ns, '0' after 20 ns;
      wait for 50 ns;

      -- count up
      CON <= "10";
      STRB <= '1' after 10 ns, '0' after 20 ns;
      wait for 50 ns;
      assert (COUT="0001") report "ERROR2: COUT not incremented to 1"; 
      
      -- count up again
      wait for 50 ns;
      assert (COUT="0010") report "ERROR3: COUT not incremented to 2"; 

      -- count up, should not increment since hit limit
      wait for 50 ns;
      assert (COUT="0010") report "ERROR4: COUT should have hit limit at 2"; 
      
      -- count up, should not increment since limit is hit eventhough countup signal is enabled
      CON <= "10";
      STRB <= '1' after 10 ns, '0' after 20 ns;
      wait for 50 ns;
      assert (COUT="0010") report "ERROR5: COUT should have hit limit at 2"; 
      
      -- count down, cannot decrement since limit is hit and we do not know from which
      -- direction the limit is hit
      CON <= "11";
      STRB <= '1' after 10 ns, '0' after 20 ns;
      wait for 50 ns;
      assert (COUT="0010") report "ERROR6: COUT not decremented to 2"; 
      
      -- load the LIMIT to 0
      DATA <= "0000";
      CON <= "01";
      STRB <= '1' after 10 ns, '0' after 20 ns;
      wait for 50 ns;
      
      -- count down
      CON <= "11";
      STRB <= '1' after 10 ns, '0' after 20 ns;
      wait for 50 ns;
      assert (COUT="0001") report "ERROR7: COUT not decremented to 0"; 

-- TEST2 Perform some extensive testing of the counter's limit handling

      -- set limit to 13
      DATA <= "1101";
      CON <= "01";
      STRB <= '1' after 10 ns, '0' after 20 ns;
      wait for 50 ns;

      -- reset the counter
      CON <= "00";
      STRB <= '1' after 10 ns, '0' after 20 ns;
      wait for 50 ns;
      assert (COUT="0000") report "ERROR8: COUT not reset to 0"; 
      
      -- count up to 13
      CON <= "10";
      STRB <= '1' after 10 ns, '0' after 20 ns;
      for i in 1 to 13 loop
         wait for 50 ns;
      end loop;
      assert (COUT="1101") report "ERROR9: COUT not up to 13";
 
      -- count up, should not increment since hit limit
      wait for 50 ns;
      assert (COUT="1101") report "ERROR10: COUT should have hit limit at 13"; 
      
      -- count up, should not increment since hit limit
      CON <= "10";
      wait for 50 ns;
      assert (COUT="1101") report "ERROR11: COUT should have hit limit at 13";
      
      -- change limit to 15
      DATA <= "1111";
      CON <= "01";
      STRB <= '1' after 10 ns, '0' after 20 ns;
      wait for 50 ns;

      -- count up
      CON <= "10";
      STRB <= '1' after 10 ns, '0' after 20 ns;
      wait for 50 ns;
      assert (COUT="1110") report "ERROR12: COUT didn't increment to 14"; 

      -- count up
      wait for 50 ns;
      assert (COUT="1111") report "ERROR13: COUT didn't increment to 15"; 

      -- count up, should not increment since hit limit
      wait for 50 ns;
      assert (COUT="1111") report "ERROR14:COUT should have hit limit at 15"; 
      
      -- change limit to 7 
      DATA <= "0111";
      CON <= "01";
      STRB <= '1' after 10 ns, '0' after 20 ns;
      wait for 50 ns;

      -- count down, try counting below 7
      CON <= "11";
      STRB <= '1' after 10 ns, '0' after 20 ns;
      for i in 1 to 10 loop
         wait for 50 ns;
      end loop;
      assert (COUT="0111") report "ERROR15: COUT not equal to 7";
         
      -- change limit to 0 
      DATA <= "0000";
      CON <= "01";
      STRB <= '1' after 10 ns, '0' after 20 ns;
      wait for 50 ns;
 
      -- count down, try counting below 8
      CON <= "11";
      STRB <= '1' after 10 ns, '0' after 20 ns;
      for i in 1 to 8 loop
         wait for 50 ns;
      end loop;
      assert (COUT="0000") report "ERROR16: COUT not equal to 0";
         
      -- count up, should not increment since hit limit
      CON <= "10";
      STRB <= '1' after 10 ns, '0' after 20 ns;
      wait for 50 ns;
      assert (COUT="0000") report "ERROR17: did not increment to 0"; 
      
-- TEST3 Try counting beyond the range, i.e. above 15 and below 0

      -- reset the counter
      CON <= "00";
      STRB <= '1' after 10 ns, '0' after 20 ns;
      wait for 50 ns;
      assert (COUT="0000") report "ERROR18: COUT not reset to 0"; 

      -- change limit to 7 
      DATA <= "0111";
      CON <= "01";
      STRB <= '1' after 10 ns, '0' after 20 ns;
      wait for 50 ns;

      -- count up 1 
      CON <= "10";
      STRB <= '1' after 10 ns, '0' after 20 ns;
      wait for 50 ns;
      assert (COUT="0001") report "ERROR19: COUT not incremented to 1"; 
      
      -- count down  
      CON <= "11";
      STRB <= '1' after 10 ns, '0' after 20 ns;
      wait for 50 ns;
      assert (COUT="0000") report "ERROR20:COUT not decremented to 0"; 
    
      -- count down  
      wait for 50 ns;
      assert (COUT="1111") report "ERROR21: COUT not decremented to 15"; 
      
      -- count down  
      wait for 50 ns;
      assert (COUT="1110") report "ERROR22: COUT not decremented to 14"; 
      
      -- count up 
      CON <= "10";
      STRB <= '1' after 10 ns, '0' after 20 ns;
      wait for 50 ns;
      assert (COUT="1111") report "ERROR23: COUT not incremented to 15"; 
      
      -- count up 
      CON <= "10";
      STRB <= '1' after 10 ns, '0' after 20 ns;
      wait for 50 ns;
      assert (COUT="0000") report "ERROR24: COUT not incremented to 0"; 

-- TEST4 Checking for counting sequence from 0 to 15 and from 15 to 0

      -- reset the counter
      CON <= "00";
      STRB <= '1' after 10 ns, '0' after 20 ns;
      wait for 50 ns;
      assert (COUT="0000") report "ERROR25: COUT not reset to 0"; 

      -- change limit to 15
      DATA <= "1111";
      CON <= "01";
      STRB <= '1' after 10 ns, '0' after 20 ns;
      wait for 50 ns;

      -- count up 15 times
      CON <= "10";
      STRB <= '1' after 10 ns, '0' after 20 ns;

      wait for 50 ns;
      assert (COUT="0001") report "ERROR26: COUT not incremented to 1"; 

      wait for 50 ns;
      assert (COUT="0010") report "ERROR27: COUT not incremented to 2"; 

      wait for 50 ns;
      assert (COUT="0011") report "ERROR28: COUT not incremented to 3"; 

      wait for 50 ns;
      assert (COUT="0100") report "ERROR29: COUT not incremented to 4"; 

      wait for 50 ns;
      assert (COUT="0101") report "ERROR30: COUT not incremented to 5"; 

      wait for 50 ns;
      assert (COUT="0110") report "ERROR31: COUT not incremented to 6"; 

      wait for 50 ns;
      assert (COUT="0111") report "ERROR32: COUT not incremented to 7"; 

      wait for 50 ns;
      assert (COUT="1000") report "ERROR33: COUT not incremented to 8"; 

      wait for 50 ns;
      assert (COUT="1001") report "ERROR34: COUT not incremented to 9"; 

      wait for 50 ns;
      assert (COUT="1010") report "ERROR35: COUT not incremented to 10"; 

      wait for 50 ns;
      assert (COUT="1011") report "ERROR36: COUT not incremented to 11"; 

      wait for 50 ns;
      assert (COUT="1100") report "ERROR37: COUT not incremented to 12"; 

      wait for 50 ns;
      assert (COUT="1101") report "ERROR38: COUT not incremented to 13"; 

      wait for 50 ns;
      assert (COUT="1110") report "ERROR39: COUT not incremented to 14"; 

      wait for 50 ns;
      assert (COUT="1111") report "ERROR40: COUT not incremented to 15"; 
      
      -- change limit to 0
      DATA <= "0000";
      CON <= "01";
      STRB <= '1' after 10 ns, '0' after 20 ns;
      wait for 50 ns;

      -- count down 15 times 
      CON <= "11";
      STRB <= '1' after 10 ns, '0' after 20 ns;

      wait for 50 ns;
      assert (COUT="1110") report "ERROR41: COUT not decremented to 14"; 

      wait for 50 ns;
      assert (COUT="1101") report "ERROR42: COUT not decremented to 13"; 

      wait for 50 ns;
      assert (COUT="1100") report "ERROR43: COUT not decremented to 12"; 

      wait for 50 ns;
      assert (COUT="1011") report "ERROR44: COUT not decremented to 11"; 

      wait for 50 ns;
      assert (COUT="1010") report "ERROR45: COUT not decremented to 10"; 

      wait for 50 ns;
      assert (COUT="1001") report "ERROR46: COUT not decremented to 9"; 

      wait for 50 ns;
      assert (COUT="1000") report "ERROR47: COUT not decremented to 8"; 

      wait for 50 ns;
      assert (COUT="0111") report "ERROR48: COUT not decremented to 7"; 

      wait for 50 ns;
      assert (COUT="0110") report "ERROR49: COUT not decremented to 6"; 

      wait for 50 ns;
      assert (COUT="0101") report "ERROR50: COUT not decremented to 5"; 

      wait for 50 ns;
      assert (COUT="0100") report "ERROR51: COUT not decremented to 4"; 

      wait for 50 ns;
      assert (COUT="0011") report "ERROR52: COUT not decremented to 3"; 

      wait for 50 ns;
      assert (COUT="0010") report "ERROR53: COUT not decremented to 2"; 

      wait for 50 ns;
      assert (COUT="0001") report "ERROR54: COUT not decremented to 1"; 

      wait for 50 ns;
      assert (COUT="0000") report "ERROR55: COUT not decremented to 0"; 
    
   wait;
   end process;
end A;
