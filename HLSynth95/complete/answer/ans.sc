--*********************************************************************
-- Copyright (c) 1994 Frank Vahid, Jie Gong, and Sanjiv Narayan
-- Department of Computer Science
-- University of California, Irvine
--*********************************************************************


--**************************************************
-- Answering machine controller
--**************************************************
--NOTE: when used in documentation, change fs to s
--NOTE: when used in documentation, remove asserts?

-- Verification Information:
--								Compiler/
--                  Verified     By whom?           Date        Simulator
--                  --------   ------------        --------     ------------
--  Syntax            yes      Preeti R. Panda	   10 Feb 95 	Synopsys
--  Functionality     yes      Jie Gong			?	Zycad
--
--

entity ansE is
   port
   (
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
end; 

architecture ansA of ansE is
begin

behavior ans type concurrent subbehaviors is
   -- Global declarations
   type four_buttons_type is array (1 to 4) of bit_vector(3 downto 0);
   signal user_code     : four_buttons_type; -- user id number
   signal machine_on    : bit;  -- current state of machine
   signal machine_on_toggle : bit; -- toggle on hangup
   signal num_msgs      : integer range 0 to 31; -- num of messages
   signal machine_button_pushed : bit; -- 1 if machine button pushed

begin

   Main : ;
   MachineOnToggler : ;
   ConcAsgns1 : ;
   ConcAsgns2 : ;


   --*****************************************
   behavior Main type sequential subbehaviors is
   --*****************************************
   -- main control behavior of the answering machine controller 

      -- Terminates any tape player, announcement player, or beep 
      -- activity.  Useful after exceptions such as hangup.
      --
      procedure TerminateAnyActivity is
      begin
         produce_beep_p  <= '0';
         ann_rec_p       <= '0';
         ann_play_p      <= '0';
         tape_fwd_p      <= '0';
         tape_play_p     <= '0';
         tape_rew_p      <= '0';
         tape_rec_p      <= '0';
      end;

      -- Produces a beep with the indicated length 
      --
      procedure Beep (len : in time) is
      begin
         produce_beep_p <= '1';
         wait for len;
         produce_beep_p <= '0';
      end;

   begin
      SystemOff : (TI,  system_on_p = '1', SystemOn);
      SystemOn  : (TI,  system_on_p = '0', SystemOff);

      behavior SystemOff type code is
      begin
         TerminateAnyActivity;
         on_light_p <= '0'; -- turn off led
      end SystemOff;

      behavior SystemOn type sequential subbehaviors is

         signal terminal_tape_count: integer; -- end of last message
         signal toggle_on_hangup : bit; -- toggle machine-on state 

         -- Plays all messages by saving tape count of end of last 
         -- message, rewinding to start of tape, and playing until 
         -- end tape count. 
         procedure PlayAllMsgs
               (signal terminal_tape_count : inout integer ; 
                signal tape_count : in integer ; 
                signal tape_rew : out bit ; 
                signal tape_play : out bit ) is
         begin
            -- Save tape count of end of last message
            terminal_tape_count <=  tape_count_p;  
            -- Rewind to start of tape
            tape_rew <=  '1';
            if not (tape_count = 0)  then
               wait until tape_count = 0;
            end if;
            tape_rew <=  '0';
            -- Play until end of last message
            tape_play <=  '1';
            if (tape_count < terminal_tape_count) then
               wait until tape_count = terminal_tape_count;
            end if;
            tape_play <=  '0';
            -- Beep to indicate that all messages have been played
            Beep(1 fs);
         end; -- PlayAllMsgs

      begin

         InitializeSystem :
            (TOC, true, RespondToLine);
         RespondToLine :   
            (TI, machine_button_pushed = '1' 
             and machine_button_pushed'event, 
             RespondToMachineButton);
         RespondToMachineButton :
            (TOC, true, RespondToLine),
            (TI, machine_button_pushed = '1' 
             and machine_button_pushed'event,
             RespondToMachineButton);


         -- Rewinds to beginning of tape, sets message number to 0
         --
         behavior InitializeSystem type code is
         begin
            num_msgs <=  0;
            tape_rew_p <=  '1';
            if (tape_count_p /= 0) then
               wait until tape_count_p = 0;
            end if;
            tape_rew_p <=  '0';
            toggle_on_hangup <=  '0';
         end InitializeSystem;

         -- Monitor and answer line as opposed to handling 
         -- machine buttons
         --
         behavior RespondToLine type sequential subbehaviors is
         begin

            Monitor : 
               (TOC, true, Answer),
               (TI, hangup_p = '1' and hangup_p'event, Monitor);
            Answer : 
               (TOC, true, Monitor),
               (TI, machine_on = '0' and machine_on'event, Monitor);


            -- Monitors line for required number of rings 
            -- If the machine is off, it answers after 15 rings 
            -- (just in case the owner forgot to turn the machine 
            -- on before leaving home).
            -- If the machine is on, it answers after 4 rings,
            -- UNLESS tollsaver is on and there is a message, in 
            -- which case it answers after 2 rings. 
            --
            behavior Monitor type code is

               variable rings_to_wait: integer range 1 to 20;
               variable i: integer range 0 to 20;

               -- Computes the number of rings to wait for
               function DetermineRingsToWait (
			num_msgs: in integer range 0 to 31;
			machine_on: in bit;
			tollsaver_p: in bit) return integer is
               begin
                  if ((num_msgs > 0) and (tollsaver_p = '1') and 
                      (machine_on = '1')) then
                     return(2);
                  elsif (machine_on = '1') then
                     return(4);
                  else
                     return(15);
                  end if;
               end;

            begin
               TerminateAnyActivity;
               -- Turn on led if machine is on
               if (machine_on='1') then 
                  on_light_p <= '1';
               else
                  on_light_p <= '0';
               end if;

               rings_to_wait := DetermineRingsToWait (num_msgs, machine_on, tollsaver_p);
               i := 0;
               -- Loop until required rings have been detected
               while (i < rings_to_wait) loop 
                  wait on tollsaver_p,machine_on,ring_p;
                  if ring_p = '1' and ring_p'event then
                     assert false 
                        report "Monitor: Caught ring." severity NOTE;
                     i := i + 1;
                  end if;
                  -- If machine_on or tollsaver has changed, the 
                  -- number of rings to wait may also change, 
                  -- so let's recompute
                  if (machine_on'event or tollsaver_p'event) then
                     rings_to_wait := DetermineRingsToWait (num_msgs, machine_on, tollsaver_p);
                  end if;
               end loop ;
               offhook_p <=  '1'; -- answer the line
            end Monitor;

            -- Answers the line. 
            -- Normal sequence: PlayAnnouncement, RecordMsg, Hangup.
            -- If a hangup is detected while playing or recording,
            -- machine hangs up.
            -- If tone 1 is detected, enters remote operation mode.
            -- 
            behavior Answer type sequential subbehaviors is
            begin

               PlayAnnouncement : 
                  (TI, tone_p = "0001", RemoteOperation),
                  (TI, hangup_p = '1' and hangup_p'event, HANGUP),
                  (TOC, true, RecordMsg);
               RecordMsg : 
                  (TI, tone_p = "0001", RemoteOperation),
                  (TOC, true, Hangup);
               Hangup : 
                  (TOC, true, stop);
               RemoteOperation : 
                  (TOC, true, HANGUP);

               -- Plays announcement until end of announcement 
               --
               behavior PlayAnnouncement type code is
               begin
                  ann_play_p <=  '1';
                  wait until ann_done_p = '1';
                  ann_play_p <=  '0';
               end PlayAnnouncement;

               -- Produces a beep, then records line until hangup or 
               -- until a maximum time is reached. 
               -- Places a beep at the end of the recorded message.
               --
               behavior RecordMsg type code is
               begin
                  Beep(1 fs);
                  if not (hangup_p = '1')  then
                     tape_rec_p <=  '1';
                     wait until hangup_p = '1' for 1000 fs;
                     Beep(1 fs);
                     num_msgs <=  num_msgs + 1;
                     tape_rec_p <=  '0';
                  end if;
               end RecordMsg;

               -- Hangs up.  Toggles machine-on state if necessary.
               --
               behavior Hangup type code is
               begin
                  offhook_p <=  '0';
                  ann_play_p <=  '0';
                  if (toggle_on_hangup = '1') then
                     toggle_on_hangup <=  '0';
                     machine_on_toggle <=  '1';
                     wait for 1 fs;
                     machine_on_toggle <=  '0';
                  end if;
               end Hangup;

               -- Processes remote commands given by machine owner if
               -- correct user identification number is entered
               --
               behavior RemoteOperation type sequential subbehaviors is
                  signal code_ok : bit; -- true if correct id 
               begin

                  CheckUserId : 
                     (TOC, code_ok = '1', RespondToCmds),
                     (TOC, code_ok = '0', stop),
                     (TI, hangup_p = '1', stop);
                  RespondToCmds : 
                     (TOC, true, stop);

                  -- Checks next four button-tones against user id,
                  -- sets code_ok to true if all four match
                  behavior CheckUserId type code is
                     variable entered_code: four_buttons_type;
                     variable i: integer range 1 to 5;
                  begin
                     TerminateAnyActivity;
                     code_ok <= '1';
                     i := 1;
                     while i <= 4 loop
                        wait until tone_p /= "1111" and tone_p'event;
                        assert false 
                           report "CheckUserId: button pushed" 
                           severity note;
                        if (tone_p /= user_code(i)) then  -- wrong 
                           code_ok <= '0';
                        end if;
                        i := i + 1;
                     end loop ;
                  end CheckUserId;

                  -- Processes user commands.  When done with 
                  -- commands, resets tape to end of last message, 
                  -- unless of course the user has erased all 
                  -- messages.  HearMsgsCmds is the initial mode 
                  -- which allows commands related simply to hearing 
                  -- messages.  If tone="0010" is detected, enters 
                  -- MiscCmds, in which miscellaneous, more advanced 
                  -- commands related to machine maintenance
                  -- can be applied.
                  --
                  behavior RespondToCmds type sequential subbehaviors is
                  begin

                     HearMsgsCmds : 
                        (TOC, true, MiscCmds),
                        (TI, hangup_p = '1', ResetTape);
                     MiscCmds : 
                        (TOC, tone_p = "0010", HearMsgsCmds),
                        (TOC, other, ResetTape),
                        (TI, hangup_p = '1', ResetTape);
                     ResetTape : 
                        (TOC, true, stop);

                     -- Normal command processing mode.  All commands
                     -- related to hearing messages can be applied.
                     --
                     behavior HearMsgsCmds type code is
                        variable i : integer;
                     begin

                        if (tone_p = "1111") then
                           wait until tone_p /= "1111";
                        end if;

                        tape_play_p <=  '0';
                        tape_fwd_p <=  '0';
                        tape_rew_p <=  '0';
                        -- "1000" enters MiscCmds
                        if (tone_p /= "1000") then 
                           case tone_p is
                              when "0010" => -- play all messages
                                 PlayAllMsgs(terminal_tape_count,
                                             tape_count_p,
                                             tape_rew_p,tape_play_p);
                              when "0011" => -- play tape
                                 tape_play_p <=  '1';
                              when "0100" => -- forward tape
                                 tape_fwd_p <=  '1';
                              when "0101" => -- rewind tape to start
                                 tape_rew_p <=  '1';
                                 if (tape_count_p /= 0) then 
                                    wait until tape_count_p = 0;
                                 end if;
                                 tape_rew_p <=  '0';
                              when "0110" => -- stop tape
                                 tape_play_p <=  '0';
                                 tape_fwd_p <=  '0';
                                 tape_rew_p <=  '0';
                              when "0111" => -- beep number messages
                                 wait for 5 fs;
                                 i := 0;
                                 -- one beep / msg
                                 while (i < num_msgs) loop 
                                    Beep(1 fs);
                                    wait for 1 fs;
                                    i := i + 1;
                                 end loop ;
                              when others => 
                                    assert false 
                                       report 
                                       "HearMsgsCmds: Invalid button" 
                                       severity NOTE;
                           end case;
                        end if;
                     end HearMsgsCmds;


                     -- In this mode the user can perform less 
                     -- common commands related to machine 
                     -- maintenance.
                     --
                     behavior MiscCmds type code is
                     begin
                        -- Indicate new mode with a beep
                        Beep(1 fs);
                        loop
                           wait until tone_p /= "1111" 
                                      and tone_p'event;
                           case tone_p is  
                              when "0010" => -- exit MiscCmds mode
                                 exit; -- exit loop
                              when "0011" => -- rewind tape
                                 tape_rew_p <=  '1';
                                 if not (tape_count_p = 0)  then
                                    wait until tape_count_p = 0;
                                 end if;
                                 tape_rew_p <=  '0';
                                 terminal_tape_count <=  0;
                              when "0100" => -- hear announcement
                                 ann_play_p <=  '1';
                                 wait until ann_done_p = '1';
                                 ann_play_p <=  '0';
                              when "0101" => -- record announcement
                                 -- preparation time
                                 wait for 50 fs; 
                                 -- beep indicates start
                                 Beep(1 fs); 
                                 wait for 0 fs;
                                 -- record for full length
                                 ann_rec_p <=  '1'; 
                                 wait until ann_done_p = '1';
                                 ann_rec_p <=  '0';
                                 -- beep indicates end
                                 Beep(1 fs); 
                              when "0110" => --toggle machine-on state
                                 toggle_on_hangup <=  '1';
                              when others =>
                                 assert false 
                                   report "Invalid button in MiscCmds"
                                   severity note;
                           end case;
                        end loop;
                     end MiscCmds;

                     -- Reset tape to end of last message.
                     -- Rewinds if past end, forwards if before end.
                     behavior ResetTape type code is
                        variable tape_count: integer;
                     begin
                        if (tape_count_p > terminal_tape_count) then
                           tape_rew_p <=  '1';
                           wait until 
                              (tape_count_p<=terminal_tape_count);
                           tape_rew_p <=  '0';
                        elsif (tape_count_p<terminal_tape_count) then
                           tape_fwd_p <=  '1';
                           wait until 
                              (tape_count_p >= terminal_tape_count) ;
                           tape_fwd_p <=  '0';
                        end if;
                     end ResetTape;
                  end RespondToCmds;
               end RemoteOperation;
            end Answer;
         end RespondToLine;

         -- Processes command indicated by a button being pressed 
         -- on the machine.
         behavior RespondToMachineButton type code is

            procedure HandlePlayPushed is
            begin
               tape_play_p <=  '1';
               num_msgs <=  0;
            end ;

            procedure HandleFwdPushed is
            begin
               tape_fwd_p <=  '1';
               num_msgs <=  0;
            end ;

            procedure HandleRewPushed is
            begin
               num_msgs <=  0;
               tape_rew_p <=  '1';
               if (tape_count_p /= 0) then
                  wait until tape_count_p = 0;
               end if;
               tape_rew_p <=  '0';
            end ;

            procedure HandleMemoPushed is -- record message via mic.
            begin
               Beep(1 fs);
               tape_rec_p <=  '1';
               wait until but_memo_p = '0' for 1000 fs;
               Beep(1 fs);
               num_msgs <=  num_msgs + 1;
               tape_rec_p <=  '0';
            end ;

            procedure HandleStopPushed is
            begin
               num_msgs <=  0;
               tape_play_p <=  '0';
               tape_fwd_p <=  '0';
               tape_rew_p <=  '0';
               tape_rec_p <=  '0';
            end ;

            procedure HandleHearAnnPushed is -- play announcement
            begin
               ann_play_p <=  '1';
               wait until ann_done_p = '1';
               ann_play_p <=  '0';
            end ;

            procedure HandleRecAnnPushed is -- record announcement
            begin
               wait for 50 fs;
               Beep(1 fs);
               wait for 0 fs;
               ann_rec_p <=  '1';
               wait until ann_done_p = '1';
               ann_rec_p <=  '0';
               Beep(1 fs);
            end ;

            procedure HandlePlayMsgsPushed is -- play all msgs 
            begin
               terminal_tape_count <=  tape_count_p;
               tape_rew_p <=  '1';
               if not (tape_count_p = 0)  then
                  wait until tape_count_p = 0;
               end if;
               tape_rew_p <=  '0';
               tape_play_p <=  '1';
               if (tape_count_p < terminal_tape_count) then
                  wait until tape_count_p = terminal_tape_count;
               end if;
               tape_play_p <=  '0';
            end ;

         begin -- RespondToMachineButton

            if (but_play_p='1') then
               HandlePlayPushed;
            elsif (but_fwd_p='1') then
               HandleFwdPushed;
            elsif (but_rew_p='1') then
               HandleRewPushed;
            elsif (but_memo_p='1') then
               HandleMemoPushed;
            elsif (but_stop_p='1') then
               HandleStopPushed;
            elsif (but_hear_ann_p='1') then
               HandleHearAnnPushed;
            elsif (but_rec_ann_p='1') then
               HandleRecAnnPushed;
            elsif (but_play_msgs_p='1') then
               HandlePlayMsgsPushed;
            end if;

         end RespondToMachineButton;
      end SystemOn;

   end Main;

   behavior MachineOnToggler type code is
   begin
      machine_on <=  '0';
      loop
         wait until but_machine_on_p = '1' or machine_on_toggle = '1';
         if machine_on = '0' then
            machine_on <=  '1';
         else
            machine_on <=  '0';
         end if;
      end loop ;
   end MachineOnToggler;

   -- Sets machine_button_pushed to 1 if any machine button is pushed.
   --
   behavior ConcAsgns1 type code is
   begin
      loop
         wait on but_play_p,but_fwd_p,but_rew_p,but_memo_p,but_stop_p,
              but_hear_ann_p,but_rec_ann_p,but_play_msgs_p;
         if (but_play_p = '1' and but_play_p'event) or 
            (but_fwd_p = '1' and but_fwd_p'event) or 
            (but_rew_p = '1' and but_rew_p'event) or 
            (but_memo_p = '1' and but_memo_p'event) or 
            (but_stop_p = '1' and but_stop_p'event) or 
            (but_hear_ann_p = '1' and but_hear_ann_p'event) or 
            (but_rec_ann_p = '1' and but_rec_ann_p'event) or 
            (but_play_msgs_p = '1' and but_play_msgs_p'event) then
            machine_button_pushed <=  '1';
         else
            machine_button_pushed <=  '0';
         end if;
      end loop ;
   end ConcAsgns1;

   -- Updates num_msgs_p port with current value of internal signal 
   -- num_msgs so that numerical display shows number of messages.
   -- 
   behavior ConcAsgns2 type code is
   begin
      loop
         wait on num_msgs;
         if (num_msgs'event) then
            num_msgs_p <=  num_msgs;
         end if;
      end loop ;
   end ConcAsgns2;
end ans;

end ansA;
