-- VHDL model for Volume System generated from SpecCharts model in 'vol.sc'
-- Verification Information:
--								Compiler/
--                  Verified     By whom?           Date        Simulator
--                  --------   ------------        --------     ------------
--  Syntax            yes      Jie Gong			? 	Zycad
--  Functionality     yes      Jie Gong			?	Zycad
--
--

entity VolumeSystemE is 
   port(x_step_p : in bit_vector (7 downto 0) ; y_step_p : in bit_vector (7 downto 0) ; data_p : in integer ; initiate_p : in bit ; ready_p : in bit ; x_pos_p : out bit ; y_pos_p : out bit ; x_dir_p : out bit ; y_dir_p : out bit ; motor_reset_p : out bit ; output_p : out bit_vector (15 downto 0) ; strobe_p : out bit ; diskport_p : out integer );
end;


Architecture VolumeSystemA of VolumeSystemE is 
       signal inVolumeSystem   : boolean := false;
       signal doneVolumeSystem : boolean := false;
       --// package vol_pack begin
       function MAX(constant a : in time ; constant b : in time ) return time is
       begin
          if (a > b) then
             return a;
          else
             return b;
          end if;
       end;
       --// end package;
       type VolumeSystem_integer_RES is array (natural range <>) of integer;
       function VolumeSystem_integer_RESfct(constant INPUT : in VolumeSystem_integer_RES ) return integer is
       begin
          assert (INPUT'length = 1) report "overdriven signal, type: VolumeSystem_integer_RES" severity warning;
          return INPUT(0);
       end;
       signal diskport_p_sig : VolumeSystem_integer_RESfct integer register;
       type VolumeSystem_bit_RES is array (natural range <>) of bit;
       function VolumeSystem_bit_RESfct(constant INPUT : in VolumeSystem_bit_RES ) return bit is
       begin
          assert (INPUT'length = 1) report "overdriven signal, type: VolumeSystem_bit_RES" severity warning;
          return INPUT(0);
       end;
       signal strobe_p_sig : VolumeSystem_bit_RESfct bit register;
       type VolumeSystem_output_p_sig_RES is array (natural range <>) of bit_vector (15 downto 0);
       function VolumeSystem_output_p_sig_RESfct(constant INPUT : in VolumeSystem_output_p_sig_RES ) return bit_vector is
       begin
          assert (INPUT'length = 1) report "overdriven signal, type: VolumeSystem_output_p_sig_RES" severity warning;
          return INPUT(0);
       end;
       signal output_p_sig : VolumeSystem_output_p_sig_RESfct bit_vector (15 downto 0) register;
       signal motor_reset_p_sig : VolumeSystem_bit_RESfct bit register;
       signal y_dir_p_sig : VolumeSystem_bit_RESfct bit register;
       signal x_dir_p_sig : VolumeSystem_bit_RESfct bit register;
       signal y_pos_p_sig : VolumeSystem_bit_RESfct bit register;
       signal x_pos_p_sig : VolumeSystem_bit_RESfct bit register;
       --// package bit_functions begin
       function Shl(constant v2 : in bit_vector ; constant fill : in bit ) return bit_vector is
          variable sc_v1_2: bit_vector (v2'high downto v2'low);
          variable shift_val: bit_vector (sc_v1_2'low to sc_v1_2'high);
          variable I: integer;
       begin
          sc_v1_2 := v2;
          for sc_I_1 in sc_v1_2'high downto (sc_v1_2'low + 1) loop
             shift_val(sc_I_1) := sc_v1_2(sc_I_1 - 1);
          end loop ;
          shift_val(sc_v1_2'low) := fill;
          return shift_val;
       end;
       function Shl0(constant sc_v2_1 : in bit_vector ; constant dist : in integer ) return bit_vector is
          variable sc_v1_3: bit_vector (sc_v2_1'high downto sc_v2_1'low);
          variable sc_I_2: integer;
       begin
          sc_v1_3 := sc_v2_1;
          for sc_I_3 in 1 to dist loop
             sc_v1_3 := Shl(sc_v1_3,'0');
          end loop ;
          return sc_v1_3;
       end;
       function Shl1(constant sc_v2_2 : in bit_vector ; constant sc_dist_1 : in integer ) return bit_vector is
          variable sc_v1_4: bit_vector (sc_v2_2'high downto sc_v2_2'low);
          variable sc_I_4: integer;
       begin
          sc_v1_4 := sc_v2_2;
          for sc_I_5 in 1 to sc_dist_1 loop
             sc_v1_4 := Shl(sc_v1_4,'1');
          end loop ;
          return sc_v1_4;
       end;
       function Shr(constant sc_v2_3 : in bit_vector ; constant sc_fill_1 : in bit ) return bit_vector is
          variable sc_v1_5: bit_vector (sc_v2_3'high downto sc_v2_3'low);
          variable sc_shift_val_1: bit_vector (sc_v1_5'low to sc_v1_5'high);
       begin
          sc_v1_5 := sc_v2_3;
          for sc_I_6 in sc_v1_5'low to (sc_v1_5'high - 1) loop
             sc_shift_val_1(sc_I_6) := sc_v1_5(sc_I_6 + 1);
          end loop ;
          sc_shift_val_1(sc_v1_5'high) := sc_fill_1;
          return sc_shift_val_1;
       end;
       function Shr0(constant sc_v2_4 : in bit_vector ; constant sc_dist_2 : in integer ) return bit_vector is
          variable sc_v1_6: bit_vector (sc_v2_4'high downto sc_v2_4'low);
          variable sc_I_7: integer;
       begin
          sc_v1_6 := sc_v2_4;
          for sc_I_8 in 1 to sc_dist_2 loop
             sc_v1_6 := Shr(sc_v1_6,'0');
          end loop ;
          return sc_v1_6;
       end;
       function Shr1(constant sc_v2_5 : in bit_vector ; constant sc_dist_3 : in integer ) return bit_vector is
          variable sc_v1_7: bit_vector (sc_v2_5'high downto sc_v2_5'low);
          variable sc_I_9: integer;
       begin
          sc_v1_7 := sc_v2_5;
          for sc_I_10 in 1 to sc_dist_3 loop
             sc_v1_7 := Shr(sc_v1_7,'1');
          end loop ;
          return sc_v1_7;
       end;
       function Rotr(constant sc_v2_6 : in bit_vector ; constant sc_dist_4 : in integer ) return bit_vector is
          variable sc_v1_8: bit_vector (sc_v2_6'high downto sc_v2_6'low);
          variable sc_I_11: integer;
       begin
          sc_v1_8 := sc_v2_6;
          for sc_i_12 in 1 to sc_dist_4 loop
             sc_v1_8 := Shr(sc_v1_8,sc_v1_8(sc_v1_8'low));
          end loop ;
          return sc_v1_8;
       end;
       function Rotl(constant sc_v2_7 : in bit_vector ; constant sc_dist_5 : in integer ) return bit_vector is
          variable sc_v1_9: bit_vector (sc_v2_7'high downto sc_v2_7'low);
          variable sc_I_13: integer;
       begin
          sc_v1_9 := sc_v2_7;
          for sc_i_14 in 1 to sc_dist_5 loop
             sc_v1_9 := Shl(sc_v1_9,sc_v1_9(sc_v1_9'high));
          end loop ;
          return sc_v1_9;
       end;
       function I2B(constant Number : in integer ; constant len : in integer ) return bit_vector is
          variable temp: bit_vector (len - 1 downto 0);
          variable NUM: integer:=0;
          variable QUOTIENT: integer:=0;
       begin
          QUOTIENT := Number;
          for sc_I_15 in 0 to len - 1 loop
             NUM := 0;
             while QUOTIENT > 1 loop
                QUOTIENT := QUOTIENT - 2;
                NUM := NUM + 1;
             end loop ;
             case QUOTIENT is
                when 1 =>
                   temp(sc_I_15) := '1';
                when 0 =>
                   temp(sc_I_15) := '0';
                when others =>
                   null;
             end case;
             QUOTIENT := NUM;
          end loop ;
          return temp;
       end;
       function B2I(constant sc_v2_8 : in bit_vector ) return integer is
          variable sc_v1_10: bit_vector (sc_v2_8'high downto sc_v2_8'low);
          variable sc_Sum_1: integer:=0;
       begin
          sc_v1_10 := sc_v2_8;
          for N in sc_v1_10'low to sc_v1_10'high loop
             if sc_v1_10(N) = '1' then
                sc_Sum_1 := sc_Sum_1 + (2 ** (N - sc_v1_10'low));
             end if;
          end loop ;
          return sc_Sum_1;
       end;
       function Sub(constant x1 : in bit_vector ; constant x2 : in bit_vector ) return bit_vector is
          variable sc_v1_11: bit_vector (x1'high - x1'low downto 0);
          variable sc_v2_13: bit_vector (x2'high - x2'low downto 0);
          variable sc_Sum_2: bit_vector (sc_v1_11'low to sc_v1_11'high);
       begin
          sc_v1_11 := x1;
          sc_v2_13 := x2;
          assert sc_v1_11'length = sc_v2_13'length report "bit_vector -: operands of unequal lengths" severity FAILURE;
          sc_Sum_2 := I2B(B2I(sc_v1_11) - B2I(sc_v2_13),sc_Sum_2'length);
          return (sc_Sum_2);
       end;
       function Dec(constant x : in bit_vector ) return bit_vector is
          variable sc_v_1: bit_vector (x'high downto x'low);
       begin
          sc_v_1 := x;
          return I2B(B2I(sc_v_1) - 1,sc_v_1'length);
       end;
       function CarryAdd(constant sc_x1_1 : in bit_vector ; constant sc_x2_1 : in bit_vector ) return bit_vector is
          variable sc_v1_12: bit_vector (sc_x1_1'high - sc_x1_1'low downto 0);
          variable sc_v2_14: bit_vector (sc_x2_1'high - sc_x2_1'low downto 0);
          variable sc_Sum_3: bit_vector (sc_x1_1'high - sc_x1_1'low + 1 downto 0);
       begin
          sc_v1_12 := sc_x1_1;
          sc_v2_14 := sc_x2_1;
          assert sc_v1_12'length = sc_v2_14'length report "bit_vector +: operands of unequal lengths" severity FAILURE;
          sc_Sum_3 := I2B(B2I(sc_v1_12) + B2I(sc_v2_14),sc_Sum_3'length);
          return (sc_Sum_3);
       end;
       function Add(constant sc_x1_2 : in bit_vector ; constant sc_x2_2 : in bit_vector ) return bit_vector is
          variable sc_v1_13: bit_vector (sc_x1_2'high - sc_x1_2'low downto 0);
          variable sc_v2_15: bit_vector (sc_x2_2'high - sc_x2_2'low downto 0);
          variable sc_Sum_4: bit_vector (sc_v1_13'low to sc_v1_13'high);
       begin
          sc_v1_13 := sc_x1_2;
          sc_v2_15 := sc_x2_2;
          assert sc_v1_13'length = sc_v2_15'length report "bit_vector +: operands of unequal lengths" severity FAILURE;
          sc_Sum_4 := I2B(B2I(sc_v1_13) + B2I(sc_v2_15),sc_Sum_4'length);
          return (sc_Sum_4);
       end;
       function Inc(constant sc_x_1 : in bit_vector ) return bit_vector is
          variable sc_v_2: bit_vector (sc_x_1'high downto sc_x_1'low);
       begin
          sc_v_2 := sc_x_1;
          return I2B(B2I(sc_v_2) + 1,sc_v_2'length);
       end;
       function Mul(constant sc_x1_3 : in bit_vector ; constant sc_x2_3 : in bit_vector ) return bit_vector is
          variable sc_v1_14: bit_vector (sc_x1_3'high - sc_x1_3'low downto 0);
          variable sc_v2_16: bit_vector (sc_x2_3'high - sc_x2_3'low downto 0);
          variable PROD: bit_vector (sc_v1_14'low to sc_v1_14'high);
       begin
          sc_v1_14 := sc_x1_3;
          sc_v2_16 := sc_x2_3;
          assert sc_v1_14'length = sc_v2_16'length report "bit_vector +: operands of unequal lengths" severity FAILURE;
          PROD := I2B(B2I(sc_v1_14) * B2I(sc_v2_16),PROD'length);
          return (PROD);
       end;
       function Comp(constant sc_v2_9 : in bit_vector ) return bit_vector is
          variable sc_v1_15: bit_vector (sc_v2_9'high downto sc_v2_9'low);
          variable sc_temp_1: bit_vector (sc_v1_15'low to sc_v1_15'high);
          variable sc_I_16: integer;
       begin
          sc_v1_15 := sc_v2_9;
          for sc_I_17 in sc_v1_15'low to sc_v1_15'high loop
             if sc_v1_15(sc_I_17) = '0' then
                sc_temp_1(sc_I_17) := '1';
             else
                sc_temp_1(sc_I_17) := '0';
             end if;
          end loop ;
          return sc_temp_1;
       end;
       function TwosComp(constant sc_v2_10 : in bit_vector ) return bit_vector is
          variable sc_v1_16: bit_vector (sc_v2_10'high downto sc_v2_10'low);
          variable sc_temp_2: bit_vector (sc_v1_16'low to sc_v1_16'high);
       begin
          sc_v1_16 := sc_v2_10;
          sc_temp_2 := Comp(sc_v1_16);
          sc_temp_2 := Inc(sc_temp_2);
          return sc_temp_2;
       end;
       function Reverse(constant sc_v2_11 : in bit_vector ) return bit_vector is
          variable sc_v1_17: bit_vector (sc_v2_11'high downto sc_v2_11'low);
          variable sc_temp_3: bit_vector (sc_v1_17'low to sc_v1_17'high);
       begin
          sc_v1_17 := sc_v2_11;
          for sc_I_18 in sc_v1_17'high downto sc_v1_17'low loop
             sc_temp_3(sc_I_18) := sc_v1_17(sc_v1_17'high - sc_I_18 + sc_v1_17'low);
          end loop ;
          return sc_temp_3;
       end;
       function Sum(constant sc_v2_12 : in bit_vector ) return integer is
          variable sc_v1_18: bit_vector (sc_v2_12'high downto sc_v2_12'low);
          variable count: integer:=0;
       begin
          sc_v1_18 := sc_v2_12;
          for sc_I_19 in sc_v1_18'high downto sc_v1_18'low loop
             if (sc_v1_18(sc_I_19) = '1') then
                count := count + 1;
             end if;
          end loop ;
          return count;
       end;
       function Pad(constant v : in bit_vector ; constant width : in integer ) return bit_vector is
       begin
          return I2B(B2I(v),width);
       end;
       function OddParity(constant v1 : in bit_vector ) return bit is
       begin
          if ((Sum(v1) mod 2) = 1) then
             return '0';
          else
             return '1';
          end if;
       end;
       function EvenParity(constant sc_v1_1 : in bit_vector ) return bit is
       begin
          if ((Sum(sc_v1_1) mod 2) = 1) then
             return '1';
          else
             return '0';
          end if;
       end;
       --// end package;
       type memory_type is array (0 to 20) of integer;
       type VolumeSystem_x_step_var_RES is array (natural range <>) of bit_vector (7 downto 0);
       function VolumeSystem_x_step_var_RESfct(constant INPUT : in VolumeSystem_x_step_var_RES ) return bit_vector is
       begin
          assert (INPUT'length = 1) report "overdriven signal, type: VolumeSystem_x_step_var_RES" severity warning;
          return INPUT(0);
       end;
       signal x_step_var : VolumeSystem_x_step_var_RESfct bit_vector (7 downto 0) register;
       type VolumeSystem_y_step_var_RES is array (natural range <>) of bit_vector (7 downto 0);
       function VolumeSystem_y_step_var_RESfct(constant INPUT : in VolumeSystem_y_step_var_RES ) return bit_vector is
       begin
          assert (INPUT'length = 1) report "overdriven signal, type: VolumeSystem_y_step_var_RES" severity warning;
          return INPUT(0);
       end;
       signal y_step_var : VolumeSystem_y_step_var_RESfct bit_vector (7 downto 0) register;
       signal x_count : VolumeSystem_integer_RESfct integer register;
       signal y_count : VolumeSystem_integer_RESfct integer register;
       signal x_dir_var : VolumeSystem_bit_RESfct bit register;
       signal y_dir_var : VolumeSystem_bit_RESfct bit register;
       type VolumeSystem_memory_type_RES is array (natural range <>) of memory_type;
       function VolumeSystem_memory_type_RESfct(constant INPUT : in VolumeSystem_memory_type_RES ) return memory_type is
       begin
          assert (INPUT'length = 1) report "overdriven signal, type: VolumeSystem_memory_type_RES" severity warning;
          return INPUT(0);
       end;
       signal M : VolumeSystem_memory_type_RESfct memory_type register;
       signal found : VolumeSystem_bit_RESfct bit register;
       signal index : VolumeSystem_integer_RESfct integer register;
       signal volume : VolumeSystem_integer_RESfct integer register;
       signal num_data : VolumeSystem_integer_RESfct integer register;
       signal flat_level : VolumeSystem_integer_RESfct integer register;
       signal anterior_wall : VolumeSystem_integer_RESfct integer register;
       signal posterior_wall : VolumeSystem_integer_RESfct integer register;
       signal inInitiate : boolean :=false;
       signal doneInitiate : boolean :=false;
       signal inEmpty1 : boolean :=false;
       signal doneEmpty1 : boolean :=false;
       signal inMotorControl1 : boolean :=false;
       signal doneMotorControl1 : boolean :=false;
       signal inOutput : boolean :=false;
       signal doneOutput : boolean :=false;
       signal inEmpty2 : boolean :=false;
       signal doneEmpty2 : boolean :=false;
       signal inIncY : boolean :=false;
       signal doneIncY : boolean :=false;
       signal inXbody : boolean :=false;
       signal doneXbody : boolean :=false;
begin
   VolumeSystem: block 
   begin
       Initiate: block (inInitiate and not(inInitiate'stable))
       begin
           leaf_code: process
               variable TempVar_x_step_var: bit_vector (7 downto 0);
               variable TempVar_y_step_var: bit_vector (7 downto 0);
               variable TempVar_x_count: integer;
               variable TempVar_y_count: integer;
               variable TempVar_x_dir_var: bit;
               variable TempVar_y_dir_var: bit;
               variable TempVar_volume: integer;
               variable TempVar_num_data: integer;
           begin
           if guard then
              TempVar_num_data := num_data;
              num_data <= transport TempVar_num_data;
              TempVar_volume := volume;
              volume <= transport TempVar_volume;
              TempVar_y_dir_var := y_dir_var;
              y_dir_var <= transport TempVar_y_dir_var;
              TempVar_x_dir_var := x_dir_var;
              x_dir_var <= transport TempVar_x_dir_var;
              TempVar_y_count := y_count;
              y_count <= transport TempVar_y_count;
              TempVar_x_count := x_count;
              x_count <= transport TempVar_x_count;
              TempVar_y_step_var := y_step_var;
              y_step_var <= transport TempVar_y_step_var;
              TempVar_x_step_var := x_step_var;
              x_step_var <= transport TempVar_x_step_var;
              wait until (initiate_p = '1');
              TempVar_x_step_var := x_step_p;
              x_step_var <= transport TempVar_x_step_var;
              TempVar_y_step_var := y_step_p;
              y_step_var <= transport TempVar_y_step_var;
              motor_reset_p_sig <=  '1';
              wait for 10 ns;
              motor_reset_p_sig <=  '0';
              TempVar_y_count := 0;
              y_count <= transport TempVar_y_count;
              TempVar_x_count := 0;
              x_count <= transport TempVar_x_count;
              y_pos_p_sig <=  '1';
              wait for 10 ns;
              y_pos_p_sig <=  '0';
              TempVar_x_dir_var := '0';
              x_dir_var <= transport TempVar_x_dir_var;
              TempVar_y_dir_var := '0';
              y_dir_var <= transport TempVar_y_dir_var;
              TempVar_num_data := 10;
              num_data <= transport TempVar_num_data;
              TempVar_volume := 0;
              volume <= transport TempVar_volume;
              wait for 10 ns;
              wait for 0 ns;
              doneInitiate <= transport true;
              wait until not (inInitiate) ;
              doneInitiate <= transport false;
           end if;
           num_data <= transport null;
           volume <= transport null;
           y_dir_var <= transport null;
           x_dir_var <= transport null;
           y_count <= transport null;
           x_count <= transport null;
           y_step_var <= transport null;
           x_step_var <= transport null;
           motor_reset_p_sig <= transport null;
           y_pos_p_sig <= transport null;
           wait on guard;
           end process leaf_code;
       end block Initiate;
       Empty1: block (inEmpty1 and not(inEmpty1'stable))
       begin
           leaf_code: process
           begin
           if guard then
              null;
              doneEmpty1 <= transport true;
              wait until not (inEmpty1) ;
              doneEmpty1 <= transport false;
           end if;
           wait on guard;
           end process leaf_code;
       end block Empty1;
       MotorControl1: block (inMotorControl1 and not(inMotorControl1'stable))
       begin
           leaf_code: process
               variable TempVar_x_count: integer;
               variable TempVar_x_dir_var: bit;
           begin
           if guard then
              TempVar_x_dir_var := x_dir_var;
              x_dir_var <= transport TempVar_x_dir_var;
              TempVar_x_count := x_count;
              x_count <= transport TempVar_x_count;
              TempVar_x_count := 0;
              x_count <= transport TempVar_x_count;
              x_pos_p_sig <=  '1';
              y_pos_p_sig <=  '1';
              x_dir_p_sig <=  TempVar_x_dir_var;
              y_dir_p_sig <=  y_dir_var;
              wait for 1 ns;
              x_pos_p_sig <=  '0';
              y_pos_p_sig <=  '0';
              wait for 1 ns;
              if ((TempVar_x_dir_var) = '0') then
                 TempVar_x_dir_var := '1';
                 x_dir_var <= transport TempVar_x_dir_var;
              else
                 TempVar_x_dir_var := '0';
                 x_dir_var <= transport TempVar_x_dir_var;
              end if;
              wait for 0 ns;
              doneMotorControl1 <= transport true;
              wait until not (inMotorControl1) ;
              doneMotorControl1 <= transport false;
           end if;
           x_dir_var <= transport null;
           x_count <= transport null;
           x_pos_p_sig <= transport null;
           y_pos_p_sig <= transport null;
           x_dir_p_sig <= transport null;
           y_dir_p_sig <= transport null;
           wait on guard;
           end process leaf_code;
       end block MotorControl1;
       Output: block (inOutput and not(inOutput'stable))
       begin
           leaf_code: process
           begin
           if guard then
              output_p_sig <=  output_p_sig;
              output_p_sig <=  I2B(volume,16);
              wait for 1 ns;
              wait for 0 ns;
              doneOutput <= transport true;
              wait until not (inOutput) ;
              doneOutput <= transport false;
           end if;
           output_p_sig <= transport null;
           wait on guard;
           end process leaf_code;
       end block Output;
       Empty2: block (inEmpty2 and not(inEmpty2'stable))
       begin
           leaf_code: process
           begin
           if guard then
              null;
              doneEmpty2 <= transport true;
              wait until not (inEmpty2) ;
              doneEmpty2 <= transport false;
           end if;
           wait on guard;
           end process leaf_code;
       end block Empty2;
       IncY: block (inIncY and not(inIncY'stable))
       begin
           leaf_code: process
               variable TempVar_y_count: integer;
           begin
           if guard then
              TempVar_y_count := y_count;
              y_count <= transport TempVar_y_count;
              TempVar_y_count := (TempVar_y_count) + 1;
              y_count <= transport TempVar_y_count;
              wait for 0 ns;
              doneIncY <= transport true;
              wait until not (inIncY) ;
              doneIncY <= transport false;
           end if;
           y_count <= transport null;
           wait on guard;
           end process leaf_code;
       end block IncY;
       Xbody: block 
           signal inMotorControl2 : boolean :=false;
           signal doneMotorControl2 : boolean :=false;
           signal inDataAcquisition : boolean :=false;
           signal doneDataAcquisition : boolean :=false;
           signal inFlatLevel : boolean :=false;
           signal doneFlatLevel : boolean :=false;
           signal inAnteriorWall : boolean :=false;
           signal doneAnteriorWall : boolean :=false;
           signal inPosteriorWall : boolean :=false;
           signal donePosteriorWall : boolean :=false;
           signal inComputeVolume : boolean :=false;
           signal doneComputeVolume : boolean :=false;
           signal inDisk : boolean :=false;
           signal doneDisk : boolean :=false;
           signal inIncX : boolean :=false;
           signal doneIncX : boolean :=false;
       begin
           MotorControl2: block (inMotorControl2 and not(inMotorControl2'stable))
           begin
               leaf_code: process
               begin
               if guard then
                  x_pos_p_sig <=  '1';
                  wait for 1 ns;
                  x_pos_p_sig <=  '0';
                  wait for 1 ns;
                  wait for 0 ns;
                  doneMotorControl2 <= transport true;
                  wait until not (inMotorControl2) ;
                  doneMotorControl2 <= transport false;
               end if;
               x_pos_p_sig <= transport null;
               wait on guard;
               end process leaf_code;
           end block MotorControl2;
           DataAcquisition: block (inDataAcquisition and not(inDataAcquisition'stable))
           begin
               leaf_code: process
                   variable temp_index: integer;
                   variable TempVar_M: memory_type;
               begin
               if guard then
                  TempVar_M := M;
                  M <= transport TempVar_M;
                  temp_index := 0;
                  while (temp_index < num_data) loop
                     strobe_p_sig <=  '1';
                     wait until (ready_p = '1');
                     strobe_p_sig <=  '0';
                     TempVar_M(temp_index) := data_p;
                     M <= transport TempVar_M;
                     wait until (ready_p = '0');
                     temp_index := temp_index + 1;
                  end loop ;
                  wait for 0 ns;
                  doneDataAcquisition <= transport true;
                  wait until not (inDataAcquisition) ;
                  doneDataAcquisition <= transport false;
               end if;
               M <= transport null;
               strobe_p_sig <= transport null;
               wait on guard;
               end process leaf_code;
           end block DataAcquisition;
           FlatLevel: block (inFlatLevel and not(inFlatLevel'stable))
           begin
               leaf_code: process
                   variable temp2: integer;
                   variable TempVar_flat_level: integer;
               begin
               if guard then
                  TempVar_flat_level := flat_level;
                  flat_level <= transport TempVar_flat_level;
                  temp2 := 0;
                  for temp1 in (num_data - 2) to (num_data - 1) loop
                     temp2 := temp2 + M(temp1);
                  end loop ;
                  TempVar_flat_level := B2I(Shl0(I2B(temp2,8),3)) + 10;
                  flat_level <= transport TempVar_flat_level;
                  wait for 0 ns;
                  doneFlatLevel <= transport true;
                  wait until not (inFlatLevel) ;
                  doneFlatLevel <= transport false;
               end if;
               flat_level <= transport null;
               wait on guard;
               end process leaf_code;
           end block FlatLevel;
           AnteriorWall: block (inAnteriorWall and not(inAnteriorWall'stable))
           begin
               leaf_code: process
                   variable temp3: integer;
                   variable TempVar_found: bit;
                   variable TempVar_index: integer;
                   variable TempVar_anterior_wall: integer;
               begin
               if guard then
                  TempVar_anterior_wall := anterior_wall;
                  anterior_wall <= transport TempVar_anterior_wall;
                  TempVar_index := index;
                  index <= transport TempVar_index;
                  TempVar_found := found;
                  found <= transport TempVar_found;
                  TempVar_found := '0';
                  found <= transport TempVar_found;
                  TempVar_anterior_wall := 0;
                  anterior_wall <= transport TempVar_anterior_wall;
                  TempVar_index := 0;
                  index <= transport TempVar_index;
                  while ((TempVar_found) = '0') loop
                     temp3 := M(TempVar_index);
                     if (temp3 > flat_level) then
                        TempVar_index := (TempVar_index) + 1;
                        index <= transport TempVar_index;
                     else
                        TempVar_anterior_wall := TempVar_index;
                        anterior_wall <= transport TempVar_anterior_wall;
                        TempVar_found := '1';
                        found <= transport TempVar_found;
                     end if;
                  end loop ;
                  wait for 0 ns;
                  doneAnteriorWall <= transport true;
                  wait until not (inAnteriorWall) ;
                  doneAnteriorWall <= transport false;
               end if;
               anterior_wall <= transport null;
               index <= transport null;
               found <= transport null;
               wait on guard;
               end process leaf_code;
           end block AnteriorWall;
           PosteriorWall: block (inPosteriorWall and not(inPosteriorWall'stable))
           begin
               leaf_code: process
                   variable temp4: integer;
                   variable TempVar_found: bit;
                   variable TempVar_index: integer;
                   variable TempVar_posterior_wall: integer;
               begin
               if guard then
                  TempVar_posterior_wall := posterior_wall;
                  posterior_wall <= transport TempVar_posterior_wall;
                  TempVar_index := index;
                  index <= transport TempVar_index;
                  TempVar_found := found;
                  found <= transport TempVar_found;
                  TempVar_found := '0';
                  found <= transport TempVar_found;
                  TempVar_posterior_wall := 0;
                  posterior_wall <= transport TempVar_posterior_wall;
                  while (((TempVar_found) = '0') and ((TempVar_index) < num_data)) loop
                     temp4 := M(TempVar_index);
                     if (temp4 < flat_level) then
                        TempVar_index := (TempVar_index) + 1;
                        index <= transport TempVar_index;
                     else
                        TempVar_posterior_wall := TempVar_index;
                        posterior_wall <= transport TempVar_posterior_wall;
                        TempVar_found := '1';
                        found <= transport TempVar_found;
                     end if;
                  end loop ;
                  wait for 0 ns;
                  donePosteriorWall <= transport true;
                  wait until not (inPosteriorWall) ;
                  donePosteriorWall <= transport false;
               end if;
               posterior_wall <= transport null;
               index <= transport null;
               found <= transport null;
               wait on guard;
               end process leaf_code;
           end block PosteriorWall;
           ComputeVolume: block (inComputeVolume and not(inComputeVolume'stable))
           begin
               leaf_code: process
                   variable TempVar_volume: integer;
               begin
               if guard then
                  TempVar_volume := volume;
                  volume <= transport TempVar_volume;
                  if (found = '1') then
                     TempVar_volume := (TempVar_volume) + posterior_wall * posterior_wall * posterior_wall - anterior_wall * anterior_wall * anterior_wall;
                     volume <= transport TempVar_volume;
                  else
                     TempVar_volume := 0;
                     volume <= transport TempVar_volume;
                  end if;
                  wait for 0 ns;
                  doneComputeVolume <= transport true;
                  wait until not (inComputeVolume) ;
                  doneComputeVolume <= transport false;
               end if;
               volume <= transport null;
               wait on guard;
               end process leaf_code;
           end block ComputeVolume;
           Disk: block (inDisk and not(inDisk'stable))
           begin
               leaf_code: process
                   variable data_index: integer;
               begin
               if guard then
                  data_index := 0;
                  for sc_data_index_1 in 0 to (num_data - 1) loop
                     diskport_p_sig <=  M(sc_data_index_1);
                     wait for 1 ns;
                  end loop ;
                  wait for 0 ns;
                  doneDisk <= transport true;
                  wait until not (inDisk) ;
                  doneDisk <= transport false;
               end if;
               diskport_p_sig <= transport null;
               wait on guard;
               end process leaf_code;
           end block Disk;
           IncX: block (inIncX and not(inIncX'stable))
           begin
               leaf_code: process
                   variable TempVar_x_count: integer;
               begin
               if guard then
                  TempVar_x_count := x_count;
                  x_count <= transport TempVar_x_count;
                  TempVar_x_count := (TempVar_x_count) + 1;
                  x_count <= transport TempVar_x_count;
                  wait for 0 ns;
                  doneIncX <= transport true;
                  wait until not (inIncX) ;
                  doneIncX <= transport false;
               end if;
               x_count <= transport null;
               wait on guard;
               end process leaf_code;
           end block IncX;
           control: process begin
                 if (inXbody and not(inXbody'stable)) then
                    inMotorControl2 <= transport true;
                 elsif (doneMotorControl2 and (true)) then
                    inMotorControl2 <= transport false;
                    inDataAcquisition <= transport true;
                 elsif (doneDataAcquisition and (true)) then
                    inDataAcquisition <= transport false;
                    inFlatLevel <= transport true;
                 elsif (doneFlatLevel and (true)) then
                    inFlatLevel <= transport false;
                    inAnteriorWall <= transport true;
                 elsif (doneAnteriorWall and (true)) then
                    inAnteriorWall <= transport false;
                    inPosteriorWall <= transport true;
                 elsif (donePosteriorWall and (true)) then
                    inPosteriorWall <= transport false;
                    inComputeVolume <= transport true;
                 elsif (doneComputeVolume and (true)) then
                    inComputeVolume <= transport false;
                    inDisk <= transport true;
                 elsif (doneDisk and (true)) then
                    inDisk <= transport false;
                    inIncX <= transport true;
                 elsif (doneIncX and (true)) then
                    inIncX <= transport false;
                    wait until not((doneIncX and (true)) and (inIncX=false));
                    doneXbody <= transport true;
                    wait until (not inXbody);
                    doneXbody <= transport false;
              end if;
              wait until (not inXbody'stable) or (doneMotorControl2 and (true)) or (doneDataAcquisition and (true)) or (doneFlatLevel and (true)) or (doneAnteriorWall and (true)) or (donePosteriorWall and (true)) or (doneComputeVolume and (true)) or (doneDisk and (true)) or (doneIncX and (true));
           end process control;
       end block Xbody;
       control: process begin
             if (inVolumeSystem and not(inVolumeSystem'stable)) then
                inInitiate <= transport true;
             elsif (doneInitiate and (true)) then
                inInitiate <= transport false;
                inEmpty1 <= transport true;
             elsif (doneEmpty1 and (y_count < B2I(y_step_var))) then
                inEmpty1 <= transport false;
                inMotorControl1 <= transport true;
             elsif (doneEmpty1 and (y_count >= B2I(y_step_var))) then
                inEmpty1 <= transport false;
                inOutput <= transport true;
             elsif (doneMotorControl1 and (true)) then
                inMotorControl1 <= transport false;
                inEmpty2 <= transport true;
             elsif (doneOutput and (true)) then
                inOutput <= transport false;
             elsif (doneEmpty2 and (x_count < B2I(x_step_var))) then
                inEmpty2 <= transport false;
                inXbody <= transport true;
             elsif (doneEmpty2 and (x_count >= B2I(x_step_var))) then
                inEmpty2 <= transport false;
                inIncY <= transport true;
             elsif (doneIncY and (true)) then
                inIncY <= transport false;
                inEmpty1 <= transport true;
             elsif (doneXbody and (true)) then
                inXbody <= transport false;
                inEmpty2 <= transport true;
          end if;
          wait until (not inVolumeSystem'stable) or (doneInitiate and (true)) or (doneEmpty1 and (y_count < B2I(y_step_var))) or (doneEmpty1 and (y_count >= B2I(y_step_var))) or (doneMotorControl1 and (true)) or (doneOutput and (true)) or (doneEmpty2 and (x_count < B2I(x_step_var))) or (doneEmpty2 and (x_count >= B2I(x_step_var))) or (doneIncY and (true)) or (doneXbody and (true));
       end process control;
   end block VolumeSystem;

x_pos_p <= transport x_pos_p_sig;
y_pos_p <= transport y_pos_p_sig;
x_dir_p <= transport x_dir_p_sig;
y_dir_p <= transport y_dir_p_sig;
motor_reset_p <= transport motor_reset_p_sig;
output_p <= transport output_p_sig;
strobe_p <= transport strobe_p_sig;
diskport_p <= transport diskport_p_sig;
start: process begin
  inVolumeSystem <= transport true;
  wait;
end process start;

end VolumeSystemA;
