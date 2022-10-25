--*********************************************************************
-- Copyright (c) 1994 Frank Vahid, Jie Gong, and Sanjiv Narayan
-- Department of Computer Science
-- University of California, Irvine
--*********************************************************************

-- SpecCharts model for Volume System
-- Verification Information:
--								Compiler/
--                  Verified     By whom?           Date        Simulator
--                  --------   ------------        --------     ------------
--  Syntax            yes      Jie Gong			? 	Zycad
--  Functionality     yes      Jie Gong			?	Zycad
--
--

use work.bit_functions.all;

entity VolumeSystemE is
   port
   (
      x_step_p		: in  bit_vector (7 downto 0) ;
      y_step_p		: in  bit_vector (7 downto 0) ;
      data_p		: in  integer ;
      initiate_p	: in  bit ; 
      ready_p		: in  bit ;
      x_pos_p		: out bit ;
      y_pos_p		: out bit ;
      x_dir_p		: out bit ;
      y_dir_p		: out bit ;
      motor_reset_p	: out bit ;
      output_p		: out bit_vector (15 downto 0) ;
      strobe_p		: out bit ;
      diskport_p	: out integer 
   );
end;

architecture VolumeSystemA of VolumeSystemE is
begin

behavior VolumeSystem type sequential subbehaviors is
   type memory_type is array (0 to 20) of integer;
   variable x_step_var		: bit_vector (7 downto 0);
   variable y_step_var		: bit_vector (7 downto 0);
   variable x_count		: integer;
   variable y_count		: integer;
   variable x_dir_var		: bit;
   variable y_dir_var		: bit;
   variable M			: memory_type;
   variable found		: bit;
   variable index		: integer;
   variable volume		: integer;
   variable num_data		: integer;
   variable flat_level		: integer;
   variable anterior_wall	: integer;
   variable posterior_wall	: integer;
begin
   Initiate 	: (TOC, true, Empty1);
   Empty1 	: (TOC, y_count < B2I(y_step_var), MotorControl1),
		  (TOC, y_count >= B2I(y_step_var), Output);
   MotorControl1: (TOC, true, Empty2);
   Output 	: (TOC, true, stop);
   Empty2 	: (TOC, x_count < B2I(x_step_var), Xbody),
		  (TOC, x_count >= B2I(x_step_var), IncY);
   IncY 	: (TOC, true, Empty1);
   Xbody 	: (TOC, true, Empty2);

   behavior Initiate type code is
   begin
      wait until (initiate_p = '1');
      x_step_var := x_step_p;  
      y_step_var := y_step_p;
      motor_reset_p <=  '1';
      wait for 10 ns;
      motor_reset_p <=  '0';
      y_count := 0;
      x_count := 0;
      y_pos_p <=  '1';
      wait for 10 ns;
      y_pos_p <=  '0';
      x_dir_var := '0';
      y_dir_var := '0';
      num_data := 10;
      volume := 0;
      wait for 10 ns;
   end Initiate;

   behavior Empty1 type code is
   begin
      null;
   end Empty1;

   behavior MotorControl1 type code is
   begin
      x_count := 0;
      x_pos_p <=  '1';
      y_pos_p <=  '1';
      x_dir_p <=  x_dir_var;
      y_dir_p <=  y_dir_var;
      wait for 1 ns;
      x_pos_p <=  '0';
      y_pos_p <=  '0';
      wait for 1 ns;
      if (x_dir_var = '0') then
         x_dir_var := '1';
      else
         x_dir_var := '0';
      end if;
   end MotorControl1;

   behavior Output type code is
   begin
      output_p <=  I2B(volume,16);
      wait for 1 ns;
   end Output;

   behavior Empty2 type code is
   begin
      null;
   end Empty2;

   behavior IncY type code is
   begin
      y_count := y_count + 1;
   end IncY;

   behavior Xbody type sequential subbehaviors is
   begin
      MotorControl2 	: (TOC, true, DataAcquisition);
      DataAcquisition 	: (TOC, true, FlatLevel);
      FlatLevel 	: (TOC, true, AnteriorWall);
      AnteriorWall 	: (TOC, true, PosteriorWall);
      PosteriorWall 	: (TOC, true, ComputeVolume);
      ComputeVolume 	: (TOC, true, Disk);
      Disk 		: (TOC, true, IncX);
      IncX 		: (TOC, true, stop);

      behavior MotorControl2 type code is
      begin
         x_pos_p <=  '1';
         wait for 1 ns;
         x_pos_p <=  '0';
         wait for 1 ns;
      end MotorControl2;

      behavior DataAcquisition type code is
         variable temp_index: integer;
      begin
         temp_index := 0;
         while (temp_index < num_data) loop
            strobe_p <=  '1';
            wait until (ready_p = '1');
            strobe_p <=  '0';
            M(temp_index) := data_p;
            wait until (ready_p = '0');
            temp_index := temp_index + 1;
         end loop ;
      end DataAcquisition;

      behavior FlatLevel type code is
         variable temp2: integer;
      begin
         temp2 := 0;
         for temp1 in (num_data - 2) to (num_data - 1) loop
            temp2 := temp2 + M(temp1);
         end loop ;
         flat_level := B2I(SHL0(I2B(temp2,8),3)) + 10;
      end FlatLevel;

      behavior AnteriorWall type code is
         variable temp3: integer;
      begin
         found := '0';
         anterior_wall := 0;
         index := 0;
         while (found = '0') loop
            temp3 := M(index);
            if (temp3 > flat_level) then
               index := index + 1;
            else
               anterior_wall := index;
               found := '1';
            end if;
         end loop ;
      end AnteriorWall;

      behavior PosteriorWall type code is
         variable temp4: integer;
      begin
         found := '0';
         posterior_wall := 0;
         while ((found = '0') and (index < num_data)) loop
            temp4 := M(index);
            if (temp4 < flat_level) then
               index := index + 1;
            else
               posterior_wall := index;
               found := '1';
            end if;
         end loop ;
      end PosteriorWall;

      behavior ComputeVolume type code is
      begin
         if (found = '1') then
            volume := volume 
                      + posterior_wall * posterior_wall * posterior_wall
	              - anterior_wall * anterior_wall * anterior_wall;
         else
            volume := 0;
         end if;
      end ComputeVolume;

      behavior Disk type code is
       variable data_index: integer;
      begin
         data_index := 0;
         for data_index in 0 to (num_data - 1) loop
            diskport_p <=  M(data_index);
            wait for 1 ns;
         end loop ;
      end Disk;

      behavior IncX type code is
      begin
         x_count := x_count + 1;
      end IncX;

   end Xbody;
end VolumeSystem;

end VolumeSystemA;
