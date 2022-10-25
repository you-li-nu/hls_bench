-- VHDL model for Answering Machine generated from SpecCharts model in 'ans.sc'
-- Verification Information:
--								Compiler/
--                  Verified     By whom?           Date        Simulator
--                  --------   ------------        --------     ------------
--  Syntax            yes      Preeti R. Panda	   10 Feb 95 	Synopsys
--  Functionality     yes      Jie Gong			?	Zycad
--
--
entity ansE is 
   port(hangup_p : in bit ; offhook_p : out bit ; produce_beep_p : out bit ; ring_p : in bit ; tone_p : in bit_vector (3 downto 0) ; num_msgs_p : out integer range 0 to 31 ; on_light_p : out bit ; but_fwd_p : in bit ; but_hear_ann_p : in bit ; but_machine_on_p : in bit ; but_memo_p : in bit ; but_play_msgs_p : in bit ; but_play_p : in bit ; but_rec_ann_p : in bit ; but_rew_p : in bit ; but_stop_p : in bit ; system_on_p : in bit ; tollsaver_p : in bit ; ann_done_p : in bit ; ann_play_p : out bit ; ann_rec_p : out bit ; tape_fwd_p : out bit ; tape_play_p : out bit ; tape_rew_p : out bit ; tape_rec_p : out bit ; tape_count_p : in integer );
end;


Architecture ansA of ansE is 
       signal inans   : boolean := false;
       signal doneans : boolean := false;
       --// package ans_pack begin
       function MAX(constant a : in time ; constant b : in time ) return time is
       begin
          if (a > b) then
             return a;
          else
             return b;
          end if;
       end;
       --// end package;
       type ans_bit_RES is array (natural range <>) of bit;
       function ans_bit_RESfct(constant INPUT : in ans_bit_RES ) return bit is
       begin
          assert (INPUT'length = 1) report "overdriven signal, type: ans_bit_RES" severity warning;
          return INPUT(0);
       end;
       signal tape_rec_p_sig : ans_bit_RESfct bit register;
       signal tape_rew_p_sig : ans_bit_RESfct bit register;
       signal tape_play_p_sig : ans_bit_RESfct bit register;
       signal tape_fwd_p_sig : ans_bit_RESfct bit register;
       signal ann_rec_p_sig : ans_bit_RESfct bit register;
       signal ann_play_p_sig : ans_bit_RESfct bit register;
       signal on_light_p_sig : ans_bit_RESfct bit register;
       type ans_num_msgs_p_sig_RES is array (natural range <>) of integer range 0 to 31;
       function ans_num_msgs_p_sig_RESfct(constant INPUT : in ans_num_msgs_p_sig_RES ) return integer is
       begin
          assert (INPUT'length = 1) report "overdriven signal, type: ans_num_msgs_p_sig_RES" severity warning;
          return INPUT(0);
       end;
       signal num_msgs_p_sig : ans_num_msgs_p_sig_RESfct integer range 0 to 31 register;
       signal produce_beep_p_sig : ans_bit_RESfct bit register;
       signal offhook_p_sig : ans_bit_RESfct bit register;
       type four_buttons_type is array (1 to 4) of bit_vector (3 downto 0);
       type ans_four_buttons_type_RES is array (natural range <>) of four_buttons_type;
       function ans_four_buttons_type_RESfct(constant INPUT : in ans_four_buttons_type_RES ) return four_buttons_type is
       begin
          assert (INPUT'length = 1) report "overdriven signal, type: ans_four_buttons_type_RES" severity warning;
          return INPUT(0);
       end;
       signal user_code : ans_four_buttons_type_RESfct four_buttons_type register;
       signal machine_on : ans_bit_RESfct bit register;
       signal machine_on_toggle : ans_bit_RESfct bit register;
       type ans_num_msgs_RES is array (natural range <>) of integer range 0 to 31;
       function ans_num_msgs_RESfct(constant INPUT : in ans_num_msgs_RES ) return integer is
       begin
          assert (INPUT'length = 1) report "overdriven signal, type: ans_num_msgs_RES" severity warning;
          return INPUT(0);
       end;
       signal num_msgs : ans_num_msgs_RESfct integer range 0 to 31 register;
       signal machine_button_pushed : ans_bit_RESfct bit register;
       signal inMain : boolean :=false;
       signal doneMain : boolean :=false;
       signal inMachineOnToggler : boolean :=false;
       signal doneMachineOnToggler : boolean :=false;
       signal inConcAsgns1 : boolean :=false;
       signal doneConcAsgns1 : boolean :=false;
       signal inConcAsgns2 : boolean :=false;
       signal doneConcAsgns2 : boolean :=false;
begin
   ans: block 
   begin
       Main: block 
           procedure TerminateAnyActivity(signal produce_beep_p_sig : out bit ; signal ann_rec_p_sig : out bit ; signal ann_play_p_sig : out bit ; signal tape_fwd_p_sig : out bit ; signal tape_play_p_sig : out bit ; signal tape_rew_p_sig : out bit ; signal tape_rec_p_sig : out bit ; signal inState : in boolean ) is
           begin
              State_Loop : loop
                 produce_beep_p_sig <=  '0';
                 ann_rec_p_sig <=  '0';
                 ann_play_p_sig <=  '0';
                 tape_fwd_p_sig <=  '0';
                 tape_play_p_sig <=  '0';
                 tape_rew_p_sig <=  '0';
                 tape_rec_p_sig <=  '0';
                 exit State_Loop;
              end loop State_Loop;
           end;
           procedure Beep(constant len : in time ; signal produce_beep_p_sig : out bit ; signal inState : in boolean ) is
           begin
              State_Loop : loop
                 produce_beep_p_sig <=  '1';
                 wait until not (inState)  for len;
                 if (not inState ) then
                    exit State_Loop;
                 end if;
                 produce_beep_p_sig <=  '0';
                 exit State_Loop;
              end loop State_Loop;
           end;
           signal inSystemOff : boolean :=false;
           signal doneSystemOff : boolean :=false;
           signal inSystemOn : boolean :=false;
           signal doneSystemOn : boolean :=false;
       begin
           SystemOff: block (inSystemOff and not(inSystemOff'stable))
           begin
               leaf_code: process
               begin
               if guard then
                  SystemOff_Loop : loop
                     TerminateAnyActivity(produce_beep_p_sig,ann_rec_p_sig,ann_play_p_sig,tape_fwd_p_sig,tape_play_p_sig,tape_rew_p_sig,tape_rec_p_sig,inSystemOff);
                     if (not inSystemOff ) then
                        exit SystemOff_Loop;
                     end if;
                     on_light_p_sig <=  '0';
                     wait until not (inSystemOff)  for 0 ns;
                     if (not inSystemOff ) then
                        exit SystemOff_Loop;
                     end if;
                     doneSystemOff <= transport true;
                     wait until not (inSystemOff) ;
                     doneSystemOff <= transport false;
                     exit SystemOff_Loop;
                  end loop SystemOff_Loop;
               end if;
               produce_beep_p_sig <= transport null;
               ann_rec_p_sig <= transport null;
               ann_play_p_sig <= transport null;
               tape_fwd_p_sig <= transport null;
               tape_play_p_sig <= transport null;
               tape_rew_p_sig <= transport null;
               tape_rec_p_sig <= transport null;
               on_light_p_sig <= transport null;
               wait on guard;
               end process leaf_code;
           end block SystemOff;
           SystemOn: block 
               type SystemOn_integer_RES is array (natural range <>) of integer;
               function SystemOn_integer_RESfct(constant INPUT : in SystemOn_integer_RES ) return integer is
               begin
                  assert (INPUT'length = 1) report "overdriven signal, type: SystemOn_integer_RES" severity warning;
                  return INPUT(0);
               end;
               signal terminal_tape_count : SystemOn_integer_RESfct integer register;
               type SystemOn_bit_RES is array (natural range <>) of bit;
               function SystemOn_bit_RESfct(constant INPUT : in SystemOn_bit_RES ) return bit is
               begin
                  assert (INPUT'length = 1) report "overdriven signal, type: SystemOn_bit_RES" severity warning;
                  return INPUT(0);
               end;
               signal toggle_on_hangup : SystemOn_bit_RESfct bit register;
               procedure PlayAllMsgs(signal sc_terminal_tape_count_1 : inout integer ; signal tape_count : in integer ; signal tape_rew : out bit ; signal tape_play : out bit ; signal produce_beep_p_sig : inout bit ; signal inState : in boolean ) is
               begin
                  State_Loop : loop
                     sc_terminal_tape_count_1 <=  tape_count_p;
                     tape_rew <=  '1';
                     if not (tape_count = 0)  then
                        wait until (tape_count = 0) or not (inState) ;
                        if (not inState ) then
                           exit State_Loop;
                        end if;
                     end if;
                     tape_rew <=  '0';
                     tape_play <=  '1';
                     if (tape_count < sc_terminal_tape_count_1) then
                        wait until (tape_count = sc_terminal_tape_count_1) or not (inState) ;
                        if (not inState ) then
                           exit State_Loop;
                        end if;
                     end if;
                     tape_play <=  '0';
                     Beep(1 fs,produce_beep_p_sig,inState);
                     if (not inState ) then
                        exit State_Loop;
                     end if;
                     exit State_Loop;
                  end loop State_Loop;
               end;
               signal inInitializeSystem : boolean :=false;
               signal doneInitializeSystem : boolean :=false;
               signal inRespondToLine : boolean :=false;
               signal doneRespondToLine : boolean :=false;
               signal inRespondToMachineButton : boolean :=false;
               signal doneRespondToMachineButton : boolean :=false;
           begin
               InitializeSystem: block (inInitializeSystem and not(inInitializeSystem'stable))
               begin
                   leaf_code: process
                   begin
                   if guard then
                      InitializeSystem_Loop : loop
                         num_msgs <=  0;
                         tape_rew_p_sig <=  '1';
                         if (tape_count_p /= 0) then
                            wait until (tape_count_p = 0) or not (inInitializeSystem) ;
                            if (not inInitializeSystem ) then
                               exit InitializeSystem_Loop;
                            end if;
                         end if;
                         tape_rew_p_sig <=  '0';
                         toggle_on_hangup <=  '0';
                         wait until not (inInitializeSystem)  for 0 ns;
                         if (not inInitializeSystem ) then
                            exit InitializeSystem_Loop;
                         end if;
                         doneInitializeSystem <= transport true;
                         wait until not (inInitializeSystem) ;
                         doneInitializeSystem <= transport false;
                         exit InitializeSystem_Loop;
                      end loop InitializeSystem_Loop;
                   end if;
                   num_msgs <= transport null;
                   tape_rew_p_sig <= transport null;
                   toggle_on_hangup <= transport null;
                   wait on guard;
                   end process leaf_code;
               end block InitializeSystem;
               RespondToLine: block 
                   signal inMonitor : boolean :=false;
                   signal doneMonitor : boolean :=false;
                   signal inAnswer : boolean :=false;
                   signal doneAnswer : boolean :=false;
               begin
                   Monitor: block (inMonitor and not(inMonitor'stable))
                       function DetermineRingsToWait(constant sc_num_msgs_1 : in integer range 0 to 31 ; constant sc_machine_on_1 : in bit ; constant sc_tollsaver_p_1 : in bit ) return integer is
                       begin
                          if ((sc_num_msgs_1 > 0) and (sc_tollsaver_p_1 = '1') and (sc_machine_on_1 = '1')) then
                             return (2);
                          elsif (sc_machine_on_1 = '1') then
                             return (4);
                          else
                             return (15);
                          end if;
                       end;
                   begin
                       leaf_code: process
                           variable rings_to_wait: integer range 1 to 20;
                           variable i: integer range 0 to 20;
                       begin
                       if guard then
                          Monitor_Loop : loop
                             TerminateAnyActivity(produce_beep_p_sig,ann_rec_p_sig,ann_play_p_sig,tape_fwd_p_sig,tape_play_p_sig,tape_rew_p_sig,tape_rec_p_sig,inMonitor);
                             if (not inMonitor ) then
                                exit Monitor_Loop;
                             end if;
                             if (machine_on = '1') then
                                on_light_p_sig <=  '1';
                             else
                                on_light_p_sig <=  '0';
                             end if;
                             rings_to_wait := DetermineRingsToWait(num_msgs,machine_on,tollsaver_p);
                             i := 0;
                             while (i < rings_to_wait) loop
                                wait on inMonitor,ring_p,machine_on,tollsaver_p;
                                if (not inMonitor ) then
                                   exit Monitor_Loop;
                                end if;
                                if ring_p = '1' and ring_p'event then
                                   assert false report "Monitor: Caught ring." severity NOTE;
                                   i := i + 1;
                                end if;
                                if (machine_on'event or tollsaver_p'event) then
                                   rings_to_wait := DetermineRingsToWait(num_msgs,machine_on,tollsaver_p);
                                end if;
                             end loop ;
                             offhook_p_sig <=  '1';
                             wait until not (inMonitor)  for 0 ns;
                             if (not inMonitor ) then
                                exit Monitor_Loop;
                             end if;
                             doneMonitor <= transport true;
                             wait until not (inMonitor) ;
                             doneMonitor <= transport false;
                             exit Monitor_Loop;
                          end loop Monitor_Loop;
                       end if;
                       produce_beep_p_sig <= transport null;
                       ann_rec_p_sig <= transport null;
                       ann_play_p_sig <= transport null;
                       tape_fwd_p_sig <= transport null;
                       tape_play_p_sig <= transport null;
                       tape_rew_p_sig <= transport null;
                       tape_rec_p_sig <= transport null;
                       on_light_p_sig <= transport null;
                       offhook_p_sig <= transport null;
                       wait on guard;
                       end process leaf_code;
                   end block Monitor;
                   Answer: block 
                       signal inPlayAnnouncement : boolean :=false;
                       signal donePlayAnnouncement : boolean :=false;
                       signal inRecordMsg : boolean :=false;
                       signal doneRecordMsg : boolean :=false;
                       signal inHANGUP : boolean :=false;
                       signal doneHANGUP : boolean :=false;
                       signal inRemoteOperation : boolean :=false;
                       signal doneRemoteOperation : boolean :=false;
                   begin
                       PlayAnnouncement: block (inPlayAnnouncement and not(inPlayAnnouncement'stable))
                       begin
                           leaf_code: process
                           begin
                           if guard then
                              PlayAnnouncement_Loop : loop
                                 ann_play_p_sig <=  '1';
                                 wait until (ann_done_p = '1') or not (inPlayAnnouncement) ;
                                 if (not inPlayAnnouncement ) then
                                    exit PlayAnnouncement_Loop;
                                 end if;
                                 ann_play_p_sig <=  '0';
                                 wait until not (inPlayAnnouncement)  for 0 ns;
                                 if (not inPlayAnnouncement ) then
                                    exit PlayAnnouncement_Loop;
                                 end if;
                                 donePlayAnnouncement <= transport true;
                                 wait until not (inPlayAnnouncement) ;
                                 donePlayAnnouncement <= transport false;
                                 exit PlayAnnouncement_Loop;
                              end loop PlayAnnouncement_Loop;
                           end if;
                           ann_play_p_sig <= transport null;
                           wait on guard;
                           end process leaf_code;
                       end block PlayAnnouncement;
                       RecordMsg: block (inRecordMsg and not(inRecordMsg'stable))
                       begin
                           leaf_code: process
                           begin
                           if guard then
                              RecordMsg_Loop : loop
                                 Beep(1 fs,produce_beep_p_sig,inRecordMsg);
                                 if (not inRecordMsg ) then
                                    exit RecordMsg_Loop;
                                 end if;
                                 if not (hangup_p = '1')  then
                                    tape_rec_p_sig <=  '1';
                                    wait until (hangup_p = '1') or not (inRecordMsg)  for 1000 fs;
                                    if (not inRecordMsg ) then
                                       exit RecordMsg_Loop;
                                    end if;
                                    Beep(1 fs,produce_beep_p_sig,inRecordMsg);
                                    if (not inRecordMsg ) then
                                       exit RecordMsg_Loop;
                                    end if;
                                    num_msgs <=  num_msgs + 1;
                                    tape_rec_p_sig <=  '0';
                                 end if;
                                 wait until not (inRecordMsg)  for 0 ns;
                                 if (not inRecordMsg ) then
                                    exit RecordMsg_Loop;
                                 end if;
                                 doneRecordMsg <= transport true;
                                 wait until not (inRecordMsg) ;
                                 doneRecordMsg <= transport false;
                                 exit RecordMsg_Loop;
                              end loop RecordMsg_Loop;
                           end if;
                           produce_beep_p_sig <= transport null;
                           tape_rec_p_sig <= transport null;
                           num_msgs <= transport null;
                           wait on guard;
                           end process leaf_code;
                       end block RecordMsg;
                       HANGUP: block (inHANGUP and not(inHANGUP'stable))
                       begin
                           leaf_code: process
                           begin
                           if guard then
                              HANGUP_Loop : loop
                                 offhook_p_sig <=  '0';
                                 ann_play_p_sig <=  '0';
                                 if (toggle_on_hangup = '1') then
                                    toggle_on_hangup <=  '0';
                                    machine_on_toggle <=  '1';
                                    wait until not (inHANGUP)  for 1 fs;
                                    if (not inHANGUP ) then
                                       exit HANGUP_Loop;
                                    end if;
                                    machine_on_toggle <=  '0';
                                 end if;
                                 wait until not (inHANGUP)  for 0 ns;
                                 if (not inHANGUP ) then
                                    exit HANGUP_Loop;
                                 end if;
                                 doneHANGUP <= transport true;
                                 wait until not (inHANGUP) ;
                                 doneHANGUP <= transport false;
                                 exit HANGUP_Loop;
                              end loop HANGUP_Loop;
                           end if;
                           offhook_p_sig <= transport null;
                           ann_play_p_sig <= transport null;
                           toggle_on_hangup <= transport null;
                           machine_on_toggle <= transport null;
                           wait on guard;
                           end process leaf_code;
                       end block HANGUP;
                       RemoteOperation: block 
                           type RemoteOperation_bit_RES is array (natural range <>) of bit;
                           function RemoteOperation_bit_RESfct(constant INPUT : in RemoteOperation_bit_RES ) return bit is
                           begin
                              assert (INPUT'length = 1) report "overdriven signal, type: RemoteOperation_bit_RES" severity warning;
                              return INPUT(0);
                           end;
                           signal code_ok : RemoteOperation_bit_RESfct bit register;
                           signal inCheckUserId : boolean :=false;
                           signal doneCheckUserId : boolean :=false;
                           signal inRespondToCmds : boolean :=false;
                           signal doneRespondToCmds : boolean :=false;
                       begin
                           CheckUserId: block (inCheckUserId and not(inCheckUserId'stable))
                           begin
                               leaf_code: process
                                   variable entered_code: four_buttons_type;
                                   variable sc_i_1: integer range 1 to 5;
                               begin
                               if guard then
                                  CheckUserId_Loop : loop
                                     TerminateAnyActivity(produce_beep_p_sig,ann_rec_p_sig,ann_play_p_sig,tape_fwd_p_sig,tape_play_p_sig,tape_rew_p_sig,tape_rec_p_sig,inCheckUserId);
                                     if (not inCheckUserId ) then
                                        exit CheckUserId_Loop;
                                     end if;
                                     code_ok <=  '1';
                                     sc_i_1 := 1;
                                     while sc_i_1 <= 4 loop
                                        wait until (tone_p /= "1111" and tone_p'event) or not (inCheckUserId) ;
                                        if (not inCheckUserId ) then
                                           exit CheckUserId_Loop;
                                        end if;
                                        assert false report "CheckUserId: button pushed" severity note;
                                        if (tone_p /= user_code(sc_i_1)) then
                                           code_ok <=  '0';
                                        end if;
                                        sc_i_1 := sc_i_1 + 1;
                                     end loop ;
                                     wait until not (inCheckUserId)  for 0 ns;
                                     if (not inCheckUserId ) then
                                        exit CheckUserId_Loop;
                                     end if;
                                     doneCheckUserId <= transport true;
                                     wait until not (inCheckUserId) ;
                                     doneCheckUserId <= transport false;
                                     exit CheckUserId_Loop;
                                  end loop CheckUserId_Loop;
                               end if;
                               produce_beep_p_sig <= transport null;
                               ann_rec_p_sig <= transport null;
                               ann_play_p_sig <= transport null;
                               tape_fwd_p_sig <= transport null;
                               tape_play_p_sig <= transport null;
                               tape_rew_p_sig <= transport null;
                               tape_rec_p_sig <= transport null;
                               code_ok <= transport null;
                               wait on guard;
                               end process leaf_code;
                           end block CheckUserId;
                           RespondToCmds: block 
                               signal inHearMsgsCmds : boolean :=false;
                               signal doneHearMsgsCmds : boolean :=false;
                               signal inMiscCmds : boolean :=false;
                               signal doneMiscCmds : boolean :=false;
                               signal inResetTape : boolean :=false;
                               signal doneResetTape : boolean :=false;
                           begin
                               HearMsgsCmds: block (inHearMsgsCmds and not(inHearMsgsCmds'stable))
                               begin
                                   leaf_code: process
                                       variable sc_i_2: integer;
                                   begin
                                   if guard then
                                      HearMsgsCmds_Loop : loop
                                         if (tone_p = "1111") then
                                            wait until (tone_p /= "1111") or not (inHearMsgsCmds) ;
                                            if (not inHearMsgsCmds ) then
                                               exit HearMsgsCmds_Loop;
                                            end if;
                                         end if;
                                         tape_play_p_sig <=  '0';
                                         tape_fwd_p_sig <=  '0';
                                         tape_rew_p_sig <=  '0';
                                         if (tone_p /= "1000") then
                                            case tone_p is
                                               when "0010" =>
                                                  PlayAllMsgs(terminal_tape_count,tape_count_p,tape_rew_p_sig,tape_play_p_sig,produce_beep_p_sig,inHearMsgsCmds);
                                                  if (not inHearMsgsCmds ) then
                                                     exit HearMsgsCmds_Loop;
                                                  end if;
                                               when "0011" =>
                                                  tape_play_p_sig <=  '1';
                                               when "0100" =>
                                                  tape_fwd_p_sig <=  '1';
                                               when "0101" =>
                                                  tape_rew_p_sig <=  '1';
                                                  if (tape_count_p /= 0) then
                                                     wait until (tape_count_p = 0) or not (inHearMsgsCmds) ;
                                                     if (not inHearMsgsCmds ) then
                                                        exit HearMsgsCmds_Loop;
                                                     end if;
                                                  end if;
                                                  tape_rew_p_sig <=  '0';
                                               when "0110" =>
                                                  tape_play_p_sig <=  '0';
                                                  tape_fwd_p_sig <=  '0';
                                                  tape_rew_p_sig <=  '0';
                                               when "0111" =>
                                                  wait until not (inHearMsgsCmds)  for 5 fs;
                                                  if (not inHearMsgsCmds ) then
                                                     exit HearMsgsCmds_Loop;
                                                  end if;
                                                  sc_i_2 := 0;
                                                  while (sc_i_2 < num_msgs) loop
                                                     Beep(1 fs,produce_beep_p_sig,inHearMsgsCmds);
                                                     if (not inHearMsgsCmds ) then
                                                        exit HearMsgsCmds_Loop;
                                                     end if;
                                                     wait until not (inHearMsgsCmds)  for 1 fs;
                                                     if (not inHearMsgsCmds ) then
                                                        exit HearMsgsCmds_Loop;
                                                     end if;
                                                     sc_i_2 := sc_i_2 + 1;
                                                  end loop ;
                                               when others =>
                                                  assert false report "HearMsgsCmds: Invalid button" severity NOTE;
                                            end case;
                                         end if;
                                         wait until not (inHearMsgsCmds)  for 0 ns;
                                         if (not inHearMsgsCmds ) then
                                            exit HearMsgsCmds_Loop;
                                         end if;
                                         doneHearMsgsCmds <= transport true;
                                         wait until not (inHearMsgsCmds) ;
                                         doneHearMsgsCmds <= transport false;
                                         exit HearMsgsCmds_Loop;
                                      end loop HearMsgsCmds_Loop;
                                   end if;
                                   tape_play_p_sig <= transport null;
                                   tape_fwd_p_sig <= transport null;
                                   tape_rew_p_sig <= transport null;
                                   terminal_tape_count <= transport null;
                                   produce_beep_p_sig <= transport null;
                                   wait on guard;
                                   end process leaf_code;
                               end block HearMsgsCmds;
                               MiscCmds: block (inMiscCmds and not(inMiscCmds'stable))
                               begin
                                   leaf_code: process
                                   begin
                                   if guard then
                                      MiscCmds_Loop : loop
                                         Beep(1 fs,produce_beep_p_sig,inMiscCmds);
                                         if (not inMiscCmds ) then
                                            exit MiscCmds_Loop;
                                         end if;
                                         loop
                                            wait until (tone_p /= "1111" and tone_p'event) or not (inMiscCmds) ;
                                            if (not inMiscCmds ) then
                                               exit MiscCmds_Loop;
                                            end if;
                                            case tone_p is
                                               when "0010" =>
                                                  exit ;
                                               when "0011" =>
                                                  tape_rew_p_sig <=  '1';
                                                  if not (tape_count_p = 0)  then
                                                     wait until (tape_count_p = 0) or not (inMiscCmds) ;
                                                     if (not inMiscCmds ) then
                                                        exit MiscCmds_Loop;
                                                     end if;
                                                  end if;
                                                  tape_rew_p_sig <=  '0';
                                                  terminal_tape_count <=  0;
                                               when "0100" =>
                                                  ann_play_p_sig <=  '1';
                                                  wait until (ann_done_p = '1') or not (inMiscCmds) ;
                                                  if (not inMiscCmds ) then
                                                     exit MiscCmds_Loop;
                                                  end if;
                                                  ann_play_p_sig <=  '0';
                                               when "0101" =>
                                                  wait until not (inMiscCmds)  for 50 fs;
                                                  if (not inMiscCmds ) then
                                                     exit MiscCmds_Loop;
                                                  end if;
                                                  Beep(1 fs,produce_beep_p_sig,inMiscCmds);
                                                  if (not inMiscCmds ) then
                                                     exit MiscCmds_Loop;
                                                  end if;
                                                  wait until not (inMiscCmds)  for 0 fs;
                                                  if (not inMiscCmds ) then
                                                     exit MiscCmds_Loop;
                                                  end if;
                                                  ann_rec_p_sig <=  '1';
                                                  wait until (ann_done_p = '1') or not (inMiscCmds) ;
                                                  if (not inMiscCmds ) then
                                                     exit MiscCmds_Loop;
                                                  end if;
                                                  ann_rec_p_sig <=  '0';
                                                  Beep(1 fs,produce_beep_p_sig,inMiscCmds);
                                                  if (not inMiscCmds ) then
                                                     exit MiscCmds_Loop;
                                                  end if;
                                               when "0110" =>
                                                  toggle_on_hangup <=  '1';
                                               when others =>
                                                  assert false report "Invalid button in MiscCmds" severity note;
                                            end case;
                                         end loop ;
                                         wait until not (inMiscCmds)  for 0 ns;
                                         if (not inMiscCmds ) then
                                            exit MiscCmds_Loop;
                                         end if;
                                         doneMiscCmds <= transport true;
                                         wait until not (inMiscCmds) ;
                                         doneMiscCmds <= transport false;
                                         exit MiscCmds_Loop;
                                      end loop MiscCmds_Loop;
                                   end if;
                                   produce_beep_p_sig <= transport null;
                                   tape_rew_p_sig <= transport null;
                                   terminal_tape_count <= transport null;
                                   ann_play_p_sig <= transport null;
                                   ann_rec_p_sig <= transport null;
                                   toggle_on_hangup <= transport null;
                                   wait on guard;
                                   end process leaf_code;
                               end block MiscCmds;
                               ResetTape: block (inResetTape and not(inResetTape'stable))
                               begin
                                   leaf_code: process
                                       variable sc_tape_count_1: integer;
                                   begin
                                   if guard then
                                      ResetTape_Loop : loop
                                         if (tape_count_p > terminal_tape_count) then
                                            tape_rew_p_sig <=  '1';
                                            wait until ((tape_count_p <= terminal_tape_count)) or not (inResetTape) ;
                                            if (not inResetTape ) then
                                               exit ResetTape_Loop;
                                            end if;
                                            tape_rew_p_sig <=  '0';
                                         elsif (tape_count_p < terminal_tape_count) then
                                            tape_fwd_p_sig <=  '1';
                                            wait until ((tape_count_p >= terminal_tape_count)) or not (inResetTape) ;
                                            if (not inResetTape ) then
                                               exit ResetTape_Loop;
                                            end if;
                                            tape_fwd_p_sig <=  '0';
                                         end if;
                                         wait until not (inResetTape)  for 0 ns;
                                         if (not inResetTape ) then
                                            exit ResetTape_Loop;
                                         end if;
                                         doneResetTape <= transport true;
                                         wait until not (inResetTape) ;
                                         doneResetTape <= transport false;
                                         exit ResetTape_Loop;
                                      end loop ResetTape_Loop;
                                   end if;
                                   tape_rew_p_sig <= transport null;
                                   tape_fwd_p_sig <= transport null;
                                   wait on guard;
                                   end process leaf_code;
                               end block ResetTape;
                               control: process begin
                                     if (inRespondToCmds and not(inRespondToCmds'stable)) then
                                        inHearMsgsCmds <= transport true;
                                     elsif (inRespondToCmds=false and not(inRespondToCmds'stable)) then
                                        inHearMsgsCmds <= transport false;
                                        inMiscCmds <= transport false;
                                        inResetTape <= transport false;
                                     elsif (doneHearMsgsCmds and (true)) then
                                        inHearMsgsCmds <= transport false;
                                        inMiscCmds <= transport true;
                                     elsif (inHearMsgsCmds and (hangup_p = '1')) then
                                        inHearMsgsCmds <= transport false;
                                        inResetTape <= transport true;
                                     elsif (doneMiscCmds and (tone_p = "0010")) then
                                        inMiscCmds <= transport false;
                                        inHearMsgsCmds <= transport true;
                                     elsif (doneMiscCmds and (not (tone_p = "0010") )) then
                                        inMiscCmds <= transport false;
                                        inResetTape <= transport true;
                                     elsif (inMiscCmds and (hangup_p = '1')) then
                                        inMiscCmds <= transport false;
                                        inResetTape <= transport true;
                                     elsif (doneResetTape and (true)) then
                                        inResetTape <= transport false;
                                        wait until not((doneResetTape and (true)) and (inResetTape=false));
                                        doneRespondToCmds <= transport true;
                                        wait until (not inRespondToCmds);
                                        doneRespondToCmds <= transport false;
                                  end if;
                                  wait until (not inRespondToCmds'stable) or (doneHearMsgsCmds and (true)) or (inHearMsgsCmds and (hangup_p = '1')) or (doneMiscCmds and (tone_p = "0010")) or (doneMiscCmds and (not (tone_p = "0010") )) or (inMiscCmds and (hangup_p = '1')) or (doneResetTape and (true));
                               end process control;
                           end block RespondToCmds;
                           control: process begin
                                 if (inRemoteOperation and not(inRemoteOperation'stable)) then
                                    inCheckUserId <= transport true;
                                 elsif (inRemoteOperation=false and not(inRemoteOperation'stable)) then
                                    inCheckUserId <= transport false;
                                    inRespondToCmds <= transport false;
                                 elsif (doneCheckUserId and (code_ok = '1')) then
                                    inCheckUserId <= transport false;
                                    inRespondToCmds <= transport true;
                                 elsif (doneCheckUserId and (code_ok = '0')) then
                                    inCheckUserId <= transport false;
                                    wait until not((doneCheckUserId and (code_ok = '0')) and (inCheckUserId=false));
                                    doneRemoteOperation <= transport true;
                                    wait until (not inRemoteOperation);
                                    doneRemoteOperation <= transport false;
                                 elsif (inCheckUserId and (hangup_p = '1')) then
                                    inCheckUserId <= transport false;
                                    wait until not((inCheckUserId and (hangup_p = '1')) and (inCheckUserId=false));
                                    doneRemoteOperation <= transport true;
                                    wait until (not inRemoteOperation);
                                    doneRemoteOperation <= transport false;
                                 elsif (doneRespondToCmds and (true)) then
                                    inRespondToCmds <= transport false;
                                    wait until not((doneRespondToCmds and (true)) and (inRespondToCmds=false));
                                    doneRemoteOperation <= transport true;
                                    wait until (not inRemoteOperation);
                                    doneRemoteOperation <= transport false;
                              end if;
                              wait until (not inRemoteOperation'stable) or (doneCheckUserId and (code_ok = '1')) or (doneCheckUserId and (code_ok = '0')) or (inCheckUserId and (hangup_p = '1')) or (doneRespondToCmds and (true));
                           end process control;
                       end block RemoteOperation;
                       control: process begin
                             if (inAnswer and not(inAnswer'stable)) then
                                inPlayAnnouncement <= transport true;
                             elsif (inAnswer=false and not(inAnswer'stable)) then
                                inPlayAnnouncement <= transport false;
                                inRecordMsg <= transport false;
                                inHANGUP <= transport false;
                                inRemoteOperation <= transport false;
                             elsif (inPlayAnnouncement and (tone_p = "0001")) then
                                inPlayAnnouncement <= transport false;
                                inRemoteOperation <= transport true;
                             elsif (inPlayAnnouncement and (hangup_p = '1' and hangup_p'event)) then
                                inPlayAnnouncement <= transport false;
                                inHANGUP <= transport true;
                             elsif (donePlayAnnouncement and (true)) then
                                inPlayAnnouncement <= transport false;
                                inRecordMsg <= transport true;
                             elsif (inRecordMsg and (tone_p = "0001")) then
                                inRecordMsg <= transport false;
                                inRemoteOperation <= transport true;
                             elsif (doneRecordMsg and (true)) then
                                inRecordMsg <= transport false;
                                inHANGUP <= transport true;
                             elsif (doneHANGUP and (true)) then
                                inHANGUP <= transport false;
                                wait until not((doneHANGUP and (true)) and (inHANGUP=false));
                                doneAnswer <= transport true;
                                wait until (not inAnswer);
                                doneAnswer <= transport false;
                             elsif (doneRemoteOperation and (true)) then
                                inRemoteOperation <= transport false;
                                inHANGUP <= transport true;
                          end if;
                          wait until (not inAnswer'stable) or (inPlayAnnouncement and (tone_p = "0001")) or (inPlayAnnouncement and (hangup_p = '1' and hangup_p'event)) or (donePlayAnnouncement and (true)) or (inRecordMsg and (tone_p = "0001")) or (doneRecordMsg and (true)) or (doneHANGUP and (true)) or (doneRemoteOperation and (true));
                       end process control;
                   end block Answer;
                   control: process begin
                         if (inRespondToLine and not(inRespondToLine'stable)) then
                            inMonitor <= transport true;
                         elsif (inRespondToLine=false and not(inRespondToLine'stable)) then
                            inMonitor <= transport false;
                            inAnswer <= transport false;
                         elsif (doneMonitor and (true)) then
                            inMonitor <= transport false;
                            inAnswer <= transport true;
                         elsif (inMonitor and (hangup_p = '1' and hangup_p'event)) then
                            inMonitor <= transport false;
                         wait until not((inMonitor and (hangup_p = '1' and hangup_p'event)) and (inMonitor=false));
                         inMonitor <= transport true;
                         elsif (doneAnswer and (true)) then
                            inAnswer <= transport false;
                            inMonitor <= transport true;
                         elsif (inAnswer and (machine_on = '0' and machine_on'event)) then
                            inAnswer <= transport false;
                            inMonitor <= transport true;
                      end if;
                      wait until (not inRespondToLine'stable) or (doneMonitor and (true)) or (inMonitor and (hangup_p = '1' and hangup_p'event)) or (doneAnswer and (true)) or (inAnswer and (machine_on = '0' and machine_on'event));
                   end process control;
               end block RespondToLine;
               RespondToMachineButton: block (inRespondToMachineButton and not(inRespondToMachineButton'stable))
               begin
                   leaf_code: process
                       procedure HandlePlayPushed(signal tape_play_p_sig : out bit ; signal num_msgs : out integer ; signal inState : in boolean ) is
                       begin
                          State_Loop : loop
                             tape_play_p_sig <=  '1';
                             num_msgs <=  0;
                             exit State_Loop;
                          end loop State_Loop;
                       end;
                       procedure HandleFwdPushed(signal tape_fwd_p_sig : out bit ; signal num_msgs : out integer ; signal inState : in boolean ) is
                       begin
                          State_Loop : loop
                             tape_fwd_p_sig <=  '1';
                             num_msgs <=  0;
                             exit State_Loop;
                          end loop State_Loop;
                       end;
                       procedure HandleRewPushed(signal num_msgs : out integer ; signal tape_rew_p_sig : out bit ; signal inState : in boolean ) is
                       begin
                          State_Loop : loop
                             num_msgs <=  0;
                             tape_rew_p_sig <=  '1';
                             if (tape_count_p /= 0) then
                                wait until (tape_count_p = 0) or not (inState) ;
                                if (not inState ) then
                                   exit State_Loop;
                                end if;
                             end if;
                             tape_rew_p_sig <=  '0';
                             exit State_Loop;
                          end loop State_Loop;
                       end;
                       procedure HandleMemoPushed(signal produce_beep_p_sig : inout bit ; signal tape_rec_p_sig : out bit ; signal num_msgs : inout integer ; signal inState : in boolean ) is
                       begin
                          State_Loop : loop
                             Beep(1 fs,produce_beep_p_sig,inState);
                             if (not inState ) then
                                exit State_Loop;
                             end if;
                             tape_rec_p_sig <=  '1';
                             wait until (but_memo_p = '0') or not (inState)  for 1000 fs;
                             if (not inState ) then
                                exit State_Loop;
                             end if;
                             Beep(1 fs,produce_beep_p_sig,inState);
                             if (not inState ) then
                                exit State_Loop;
                             end if;
                             num_msgs <=  num_msgs + 1;
                             tape_rec_p_sig <=  '0';
                             exit State_Loop;
                          end loop State_Loop;
                       end;
                       procedure HandleStopPushed(signal num_msgs : out integer ; signal tape_play_p_sig : out bit ; signal tape_fwd_p_sig : out bit ; signal tape_rew_p_sig : out bit ; signal tape_rec_p_sig : out bit ; signal inState : in boolean ) is
                       begin
                          State_Loop : loop
                             num_msgs <=  0;
                             tape_play_p_sig <=  '0';
                             tape_fwd_p_sig <=  '0';
                             tape_rew_p_sig <=  '0';
                             tape_rec_p_sig <=  '0';
                             exit State_Loop;
                          end loop State_Loop;
                       end;
                       procedure HandleHearAnnPushed(signal ann_play_p_sig : out bit ; signal inState : in boolean ) is
                       begin
                          State_Loop : loop
                             ann_play_p_sig <=  '1';
                             wait until (ann_done_p = '1') or not (inState) ;
                             if (not inState ) then
                                exit State_Loop;
                             end if;
                             ann_play_p_sig <=  '0';
                             exit State_Loop;
                          end loop State_Loop;
                       end;
                       procedure HandleRecAnnPushed(signal produce_beep_p_sig : inout bit ; signal ann_rec_p_sig : out bit ; signal inState : in boolean ) is
                       begin
                          State_Loop : loop
                             wait until not (inState)  for 50 fs;
                             if (not inState ) then
                                exit State_Loop;
                             end if;
                             Beep(1 fs,produce_beep_p_sig,inState);
                             if (not inState ) then
                                exit State_Loop;
                             end if;
                             wait until not (inState)  for 0 fs;
                             if (not inState ) then
                                exit State_Loop;
                             end if;
                             ann_rec_p_sig <=  '1';
                             wait until (ann_done_p = '1') or not (inState) ;
                             if (not inState ) then
                                exit State_Loop;
                             end if;
                             ann_rec_p_sig <=  '0';
                             Beep(1 fs,produce_beep_p_sig,inState);
                             if (not inState ) then
                                exit State_Loop;
                             end if;
                             exit State_Loop;
                          end loop State_Loop;
                       end;
                       procedure HandlePlayMsgsPushed(signal terminal_tape_count : inout integer ; signal tape_rew_p_sig : out bit ; signal tape_play_p_sig : out bit ; signal inState : in boolean ) is
                       begin
                          State_Loop : loop
                             terminal_tape_count <=  tape_count_p;
                             tape_rew_p_sig <=  '1';
                             if not (tape_count_p = 0)  then
                                wait until (tape_count_p = 0) or not (inState) ;
                                if (not inState ) then
                                   exit State_Loop;
                                end if;
                             end if;
                             tape_rew_p_sig <=  '0';
                             tape_play_p_sig <=  '1';
                             if (tape_count_p < terminal_tape_count) then
                                wait until (tape_count_p = terminal_tape_count) or not (inState) ;
                                if (not inState ) then
                                   exit State_Loop;
                                end if;
                             end if;
                             tape_play_p_sig <=  '0';
                             exit State_Loop;
                          end loop State_Loop;
                       end;
                   begin
                   if guard then
                      RespondToMachineButton_Loop : loop
                         if (but_play_p = '1') then
                            HandlePlayPushed(tape_play_p_sig,num_msgs,inRespondToMachineButton);
                            if (not inRespondToMachineButton ) then
                               exit RespondToMachineButton_Loop;
                            end if;
                         elsif (but_fwd_p = '1') then
                            HandleFwdPushed(tape_fwd_p_sig,num_msgs,inRespondToMachineButton);
                            if (not inRespondToMachineButton ) then
                               exit RespondToMachineButton_Loop;
                            end if;
                         elsif (but_rew_p = '1') then
                            HandleRewPushed(num_msgs,tape_rew_p_sig,inRespondToMachineButton);
                            if (not inRespondToMachineButton ) then
                               exit RespondToMachineButton_Loop;
                            end if;
                         elsif (but_memo_p = '1') then
                            HandleMemoPushed(produce_beep_p_sig,tape_rec_p_sig,num_msgs,inRespondToMachineButton);
                            if (not inRespondToMachineButton ) then
                               exit RespondToMachineButton_Loop;
                            end if;
                         elsif (but_stop_p = '1') then
                            HandleStopPushed(num_msgs,tape_play_p_sig,tape_fwd_p_sig,tape_rew_p_sig,tape_rec_p_sig,inRespondToMachineButton);
                            if (not inRespondToMachineButton ) then
                               exit RespondToMachineButton_Loop;
                            end if;
                         elsif (but_hear_ann_p = '1') then
                            HandleHearAnnPushed(ann_play_p_sig,inRespondToMachineButton);
                            if (not inRespondToMachineButton ) then
                               exit RespondToMachineButton_Loop;
                            end if;
                         elsif (but_rec_ann_p = '1') then
                            HandleRecAnnPushed(produce_beep_p_sig,ann_rec_p_sig,inRespondToMachineButton);
                            if (not inRespondToMachineButton ) then
                               exit RespondToMachineButton_Loop;
                            end if;
                         elsif (but_play_msgs_p = '1') then
                            HandlePlayMsgsPushed(terminal_tape_count,tape_rew_p_sig,tape_play_p_sig,inRespondToMachineButton);
                            if (not inRespondToMachineButton ) then
                               exit RespondToMachineButton_Loop;
                            end if;
                         end if;
                         wait until not (inRespondToMachineButton)  for 0 ns;
                         if (not inRespondToMachineButton ) then
                            exit RespondToMachineButton_Loop;
                         end if;
                         doneRespondToMachineButton <= transport true;
                         wait until not (inRespondToMachineButton) ;
                         doneRespondToMachineButton <= transport false;
                         exit RespondToMachineButton_Loop;
                      end loop RespondToMachineButton_Loop;
                   end if;
                   tape_play_p_sig <= transport null;
                   num_msgs <= transport null;
                   tape_fwd_p_sig <= transport null;
                   tape_rew_p_sig <= transport null;
                   produce_beep_p_sig <= transport null;
                   tape_rec_p_sig <= transport null;
                   ann_play_p_sig <= transport null;
                   ann_rec_p_sig <= transport null;
                   terminal_tape_count <= transport null;
                   wait on guard;
                   end process leaf_code;
               end block RespondToMachineButton;
               control: process begin
                     if (inSystemOn and not(inSystemOn'stable)) then
                        inInitializeSystem <= transport true;
                     elsif (inSystemOn=false and not(inSystemOn'stable)) then
                        inInitializeSystem <= transport false;
                        inRespondToLine <= transport false;
                        inRespondToMachineButton <= transport false;
                     elsif (doneInitializeSystem and (true)) then
                        inInitializeSystem <= transport false;
                        inRespondToLine <= transport true;
                     elsif (inRespondToLine and (machine_button_pushed = '1' and machine_button_pushed'event)) then
                        inRespondToLine <= transport false;
                        inRespondToMachineButton <= transport true;
                     elsif (doneRespondToMachineButton and (true)) then
                        inRespondToMachineButton <= transport false;
                        inRespondToLine <= transport true;
                     elsif (inRespondToMachineButton and (machine_button_pushed = '1' and machine_button_pushed'event)) then
                        inRespondToMachineButton <= transport false;
                     wait until not((inRespondToMachineButton and (machine_button_pushed = '1' and machine_button_pushed'event)) and (inRespondToMachineButton=false));
                     inRespondToMachineButton <= transport true;
                  end if;
                  wait until (not inSystemOn'stable) or (doneInitializeSystem and (true)) or (inRespondToLine and (machine_button_pushed = '1' and machine_button_pushed'event)) or (doneRespondToMachineButton and (true)) or (inRespondToMachineButton and (machine_button_pushed = '1' and machine_button_pushed'event));
               end process control;
           end block SystemOn;
           control: process begin
                 if (inMain and not(inMain'stable)) then
                    inSystemOff <= transport true;
                 elsif (inSystemOff and (system_on_p = '1')) then
                    inSystemOff <= transport false;
                    inSystemOn <= transport true;
                 elsif (inSystemOn and (system_on_p = '0')) then
                    inSystemOn <= transport false;
                    inSystemOff <= transport true;
              end if;
              wait until (not inMain'stable) or (inSystemOff and (system_on_p = '1')) or (inSystemOn and (system_on_p = '0'));
           end process control;
       end block Main;
       MachineOnToggler: block (inMachineOnToggler and not(inMachineOnToggler'stable))
       begin
           leaf_code: process
           begin
           if guard then
              machine_on <=  '0';
              loop
                 wait until but_machine_on_p = '1' or machine_on_toggle = '1';
                 if machine_on = '0' then
                    machine_on <=  '1';
                 else
                    machine_on <=  '0';
                 end if;
              end loop ;
              wait for 0 ns;
              doneMachineOnToggler <= transport true;
              wait until not (inMachineOnToggler) ;
              doneMachineOnToggler <= transport false;
           end if;
           machine_on <= transport null;
           wait on guard;
           end process leaf_code;
       end block MachineOnToggler;
       ConcAsgns1: block (inConcAsgns1 and not(inConcAsgns1'stable))
       begin
           leaf_code: process
           begin
           if guard then
              loop
                 wait on but_play_msgs_p,but_rec_ann_p,but_hear_ann_p,but_stop_p,but_memo_p,but_rew_p,but_fwd_p,but_play_p;
                 if (but_play_p = '1' and but_play_p'event) or (but_fwd_p = '1' and but_fwd_p'event) or (but_rew_p = '1' and but_rew_p'event) or (but_memo_p = '1' and but_memo_p'event) or (but_stop_p = '1' and but_stop_p'event) or (but_hear_ann_p = '1' and but_hear_ann_p'event) or (but_rec_ann_p = '1' and but_rec_ann_p'event) or (but_play_msgs_p = '1' and but_play_msgs_p'event) then
                    machine_button_pushed <=  '1';
                 else
                    machine_button_pushed <=  '0';
                 end if;
              end loop ;
              wait for 0 ns;
              doneConcAsgns1 <= transport true;
              wait until not (inConcAsgns1) ;
              doneConcAsgns1 <= transport false;
           end if;
           machine_button_pushed <= transport null;
           wait on guard;
           end process leaf_code;
       end block ConcAsgns1;
       ConcAsgns2: block (inConcAsgns2 and not(inConcAsgns2'stable))
       begin
           leaf_code: process
           begin
           if guard then
              loop
                 wait on num_msgs;
                 if (num_msgs'event) then
                    num_msgs_p_sig <=  num_msgs;
                 end if;
              end loop ;
              wait for 0 ns;
              doneConcAsgns2 <= transport true;
              wait until not (inConcAsgns2) ;
              doneConcAsgns2 <= transport false;
           end if;
           num_msgs_p_sig <= transport null;
           wait on guard;
           end process leaf_code;
       end block ConcAsgns2;

       control: process begin
             if (inans and not(inans'stable)) then
                inMain <= transport true;
                inMachineOnToggler <= transport true;
                inConcAsgns1 <= transport true;
                inConcAsgns2 <= transport true;
             end if;
          wait until (not inans'stable);
       end process control;
   end block ans;

offhook_p <= transport offhook_p_sig;
produce_beep_p <= transport produce_beep_p_sig;
num_msgs_p <= transport num_msgs_p_sig;
on_light_p <= transport on_light_p_sig;
ann_play_p <= transport ann_play_p_sig;
ann_rec_p <= transport ann_rec_p_sig;
tape_fwd_p <= transport tape_fwd_p_sig;
tape_play_p <= transport tape_play_p_sig;
tape_rew_p <= transport tape_rew_p_sig;
tape_rec_p <= transport tape_rec_p_sig;
start: process begin
  inans <= transport true;
  wait;
end process start;

end ansA;
