--*********************************************************************
-- Copyright (c) 1994 Frank Vahid, Jie Gong, and Sanjiv Narayan
-- Department of Computer Science
-- University of California, Irvine
--*********************************************************************

--*********************************************************************
-- ans_sim.vhd:  Test vectors for the answering machine of ans.sc
--*********************************************************************
-- Verification Information:
--								Compiler/
--                  Verified     By whom?           Date        Simulator
--                  --------   ------------        --------     ------------
--  Syntax            yes      Preeti R. Panda	   10 Feb 95 	Synopsys
--  Functionality     yes      Jie Gong			?	Zycad
--
--

entity E is end;

architecture A of E is
   component ansE port (
   	-- Interface to line circuitry
   	hangup_p        : in  bit; -- hangup detected 
   	offhook_p       : out bit; -- answers
   	produce_beep_p  : out bit; -- produces a beep 
   	ring_p          : in  bit; -- ring detected 
   	tone_p          : in  bit_vector (3 downto 0); -- binary tone 
   	-- Interface to display
   	num_msgs_p      : out integer range 0 to 31; -- msgs display
   	on_light_p      : out bit; -- turns on led
   	-- Touch-sensitive buttons
   	but_fwd_p       : in  bit; -- forward tape
   	but_hear_ann_p  : in  bit; -- play pre-recorded announcement
   	but_machine_on_p: in  bit; -- toggle machine-on state
   	but_memo_p      : in  bit; -- record message via microphone
   	but_play_msgs_p : in  bit; -- play all messages
   	but_play_p      : in  bit; -- play tape from curr position 
   	but_rec_ann_p   : in  bit; -- record a new announcement
   	but_rew_p       : in  bit; -- rewind tape 
   	but_stop_p      : in  bit; -- stop tape
   	-- Switches
   	system_on_p     : in  bit; -- power switch
   	tollsaver_p     : in  bit; -- answer after 2 rings if msg 
   	-- Interface to announcement player
   	ann_done_p      : in  bit; -- end of announcement reached
   	ann_play_p      : out bit; -- plays announcement 
   	ann_rec_p       : out bit; -- records announcement 
   	-- Interface to tape player
   	tape_fwd_p      : out bit; -- forwards tape
   	tape_play_p     : out bit; -- plays tape
   	tape_rew_p      : out bit; -- rewinds tape
   	tape_rec_p      : out bit; -- records on tape
   	tape_count_p    : in  integer -- tape position, start is 0
   );
   end component;

   -- Interface to line circuitry
   signal hangup_p        : bit; -- hangup detected 
   signal offhook_p       : bit; -- answers
   signal produce_beep_p  : bit; -- produces a beep 
   signal ring_p          : bit; -- ring detected 
   signal tone_p          : bit_vector (3 downto 0); -- binary tone 
   -- Interface to display
   signal num_msgs_p      : integer range 0 to 31; -- msgs display
   signal on_light_p      : bit; -- turns on led
   -- Touch-sensitive buttons
   signal but_fwd_p       : bit; -- forward tape
   signal but_hear_ann_p  : bit; -- play pre-recorded announcement
   signal but_machine_on_p: bit; -- toggle machine-on state
   signal but_memo_p      : bit; -- record message via microphone
   signal but_play_msgs_p : bit; -- play all messages
   signal but_play_p      : bit; -- play tape from curr position 
   signal but_rec_ann_p   : bit; -- record a new announcement
   signal but_rew_p       : bit; -- rewind tape 
   signal but_stop_p      : bit; -- stop tape
   -- Switches
   signal system_on_p     : bit; -- power switch
   signal tollsaver_p     : bit; -- answer after 2 rings if msg 
   -- Interface to announcement player
   signal ann_done_p      : bit; -- end of announcement reached
   signal ann_play_p      : bit; -- plays announcement 
   signal ann_rec_p       : bit; -- records announcement 
   -- Interface to tape player
   signal tape_fwd_p      : bit; -- forwards tape
   signal tape_play_p     : bit; -- plays tape
   signal tape_rew_p      : bit; -- rewinds tape
   signal tape_rec_p      : bit; -- records on tape
   signal tape_count_p    : integer; -- tape position, start is 0

   for all : ansE
      use entity work.ansE(ansA);

begin

   SpecChart : ansE
      port map (
   	hangup_p        ,
   	offhook_p       ,
   	produce_beep_p  ,
   	ring_p          ,
   	tone_p          ,
   	
   	num_msgs_p      ,
   	on_light_p      ,
   	
   	but_fwd_p       ,
   	but_hear_ann_p  ,
   	but_machine_on_p,
   	but_memo_p      ,
   	but_play_msgs_p ,
   	but_play_p      ,
   	but_rec_ann_p   ,
   	but_rew_p       ,
   	but_stop_p      ,
   	
   	system_on_p     ,
   	tollsaver_p     ,
   	
   	ann_done_p      ,
   	ann_play_p      ,
   	ann_rec_p       ,
   	
   	tape_fwd_p      ,
   	tape_play_p     ,
   	tape_rew_p      ,
   	tape_rec_p      ,
   	tape_count_p    
     );

stim: block 
   type voice_res is array (natural range <>) of string(8 downto 1);
   function voice_resfct(input:voice_res) return string is
   begin
      for i in input'low to input'high loop
         -- a beep always drowns out other voices
         if input(i)="beep    " then
            return("beep    ");
         end if;
      end loop;
      assert (input'length<=1) report "Overdriven voice line." severity warning;
      if (input'length=1) then
         return(input(0)); 
      else
         return("silence ");
      end if;
   end;

   signal voice_in  : voice_resfct string(8 downto 1) bus :="silence " ;
   signal voice_out : voice_resfct string(8 downto 1) bus :="silence " ;

   signal next_cmd  : bit;  -- for simulation command increments

begin

   USERS : process
      type call_status_type is (NO_ANSWER, BUSY, ANSWERED, BEEP_HEARD);
      variable call_status : call_status_type;

      procedure terminate_call is
      begin   
         hangup_p <= '1';
         assert false report "CALLER: Hanging up" severity note;
         wait for 1 ps;
      end ;

      procedure make_call(max_rings : in integer) is
         variable num_rings : integer:=0;
      begin
         if (offhook_p='1') then
            call_status := BUSY;
            terminate_call;
         else
            hangup_p <= '0';
            while (offhook_p='0') and (num_rings < max_rings) loop 
               num_rings := num_rings + 1;
               ring_p <= '1';
               wait until offhook_p='1' for 1 ps;
               ring_p <= '0';
               if offhook_p='0' then
                  wait until offhook_p='1' for 1 ps;
               end if;
            end loop;
            if (offhook_p ='1') then
               call_status := ANSWERED;
            else
               call_status := NO_ANSWER;
               terminate_call;
            end if;
         end if;
         wait for 1 ps;
      end ;

      procedure push_button (button: in bit_vector(3 downto 0)) is
      begin
         tone_p 		<= button;
         wait for 1 ps;
         tone_p 		<= "1111";
         wait for 1 ps;
      end ;
         
      procedure wait_for_beep is
      begin
         if (voice_out /= "beep    ") then
            wait until voice_out="beep    ";
         end if;
         if (voice_out = "beep    ") then
            wait until voice_out/="beep    ";
         end if;
         call_status := BEEP_HEARD;
      end;
   
      procedure say_word(word : in string(8 downto 1)) is
      begin
         voice_in <= word;
         assert false report "CALLER: Saying word" severity note;
         wait for 1 ps;
         voice_in <= "silence ";
      end;

      procedure push_machine_on_button is
      begin
         but_machine_on_p <= '1';
         wait for 1 ps;
         but_machine_on_p <= '0';
      end;
   
   begin

      -- All commands must complete within 500 ps

      ---------------------------------------------------------------------
      -- check that machine picks up after correct number of rings.
      -- Four possibilities: 15 (machine off), 4 (machine on, no messages
      -- or tollsaver off), 2 (message and tollsaver on), never (system off).
      
      tollsaver_p 	<= '0'; 

      -- check never

      assert (false) report "Test1" severity note;
      make_call(20);  -- should not pick up
      assert (call_status = NO_ANSWER) 
        report "should not have answered" severity warning;
      
      wait until next_cmd='1';

      -- check 15

      assert (false) report "Test2" severity note;
      system_on_p <= '1';
      wait for 1 ps;
      make_call(14);
      assert (call_status = NO_ANSWER) 
        report "should not have answered" severity warning;

      make_call(15);
      assert (call_status = ANSWERED) 
        report "should have answered" severity warning;
      terminate_call;

      wait until next_cmd='1';

      -- check 4

      assert (false) report "Test3" severity note;
      push_machine_on_button;
      wait for 1 ps;
      make_call(3);
      assert (call_status = NO_ANSWER) 
        report "should not have answered" severity warning;

      make_call(4);
      assert (call_status = ANSWERED) 
        report "should have answered" severity warning;
      terminate_call;

      wait until next_cmd='1';

      assert (false) report "Test4" severity note;
      tollsaver_p 	<= '1'; 
      wait for 1 ps;
      make_call(3);
      assert (call_status = NO_ANSWER) 
        report "should not have answered" severity warning;

      make_call(4);
      assert (call_status = ANSWERED) 
        report "should have answered" severity warning;
      terminate_call;


      assert (false) report "Test5" severity note;
      tollsaver_p 	<= '0'; 
      wait for 1 ps;
      make_call(4); 
      wait_for_beep; 
      wait for 20 ps;
      say_word("HI      ");
      say_word("THERE   ");
      terminate_call;

      wait for 5 ps;
      make_call(3);
      assert (call_status = NO_ANSWER) 
        report "should not have answered" severity warning;

      make_call(4);
      assert (call_status = ANSWERED) 
        report "should have answered" severity warning;
      terminate_call;

      wait until next_cmd='1';

      -- check 2
      assert (false) report "Test6" severity note;
      tollsaver_p 	<= '1'; 
      
      make_call(1);
      assert (call_status = NO_ANSWER) 
        report "should not have answered" severity warning;

      make_call(2);
      assert (call_status = ANSWERED) 
        report "should have answered" severity warning;
      terminate_call;


      wait until next_cmd='1';

      -- check turning system off
      assert (false) report "Test7" severity note;
      system_on_p 	<= '0'; 
      wait for 5 ps;
      assert (on_light_p = '0') 
        report "on_light should turn off" severity warning;

      make_call(20);
      assert (call_status = NO_ANSWER) 
        report "should not have answered" severity warning;





      wait;

   end process ;

   tape_player : process
      constant tape_size : integer := 15;
      type tape_type is array (0 to tape_size-1) of string(8 downto 1);
      variable tape           : tape_type;
      variable count          : integer:=0;
   begin
      for i in tape'low to tape'high loop
         tape(i) := "blank   ";
      end loop;
      tape_count_p <= count;

      loop
         voice_out <= null;
         if (tape_play_p = '1') then
            if (count + 1 < tape'high) then
               voice_out <= tape(count);
               count := count + 1;
            else
               count := tape'high;
            end if;
            tape_count_p <= count;
         elsif (tape_rec_p = '1') then
            if (count + 1 < tape'high) then
               tape(count) := voice_in;
               count       := count + 1;
            else
               count := tape'high;
            end if;
            tape_count_p <= count;
         elsif (tape_fwd_p = '1') then
            if (count + 5 < tape'high) then
               count := count + 5;
            else
               count := tape'high;
            end if;
            tape_count_p <= count;
         elsif (tape_rew_p = '1') then
            if (count - 5 > tape'low) then
               count := count - 5;
            else
               count := tape'low;
            end if;
            tape_count_p <= count;
         end if;
         if (tape_play_p='1' or tape_rec_p='1' or tape_rew_p='1'  
             or tape_fwd_p='1') then
            wait for 1 ps;
         else
            wait on tape_play_p,tape_rec_p,tape_rew_p,tape_fwd_p;
         end if;
      end loop;
   end process;

   announcement_player : process
      type ann_array is array (1 to 6) of string(8 downto 1);
      variable ann : ann_array:=("We're   ", "not     ", "home    ",
                                 "Leave   ", "a       ", "message ");
      variable i   : integer;
   begin
      voice_out <= transport null;
      wait until ann_play_p='1' or ann_rec_p='1';
      if (ann_play_p='1') then
         i := ann'low; 
         while (i <= ann'high) and (ann_play_p='1') loop
            voice_out <= ann(i);
            i := i + 1;
            wait on ann_play_p for 1 ps;
         end loop;     
         ann_done_p <= '1';
         if (ann_play_p='1') then
            wait until ann_play_p='0';
         end if;
         ann_done_p <= '0';
      elsif (ann_rec_p='1') then
         i := ann'low; 
         while (i <= ann'high) loop
            ann(i) := voice_in;
            i := i + 1;
            wait for 1 ps;
         end loop;     
         ann_done_p <= '1';
         if (ann_rec_p='1') then
            wait until ann_rec_p='0';
         end if;
         ann_done_p <= '0';
      end if;
       
     
      
   end process;

   beep_producer : process
   begin
      
      voice_in  <= transport null;
      voice_out <= transport null;
      wait until produce_beep_p='1';
      voice_in  <= transport "beep    ";
      voice_out <= transport "beep    ";
      wait until produce_beep_p='0';
   end process;

   gen_increments : process
   begin
      next_cmd <= '1';
      wait for 1 ps; 
      next_cmd <= '0';
      wait for 499 ps; 
   end process;

end block;

end A;

