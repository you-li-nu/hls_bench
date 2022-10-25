entity E is end;

architecture A of E is
   component VolumeSystemE
      port (
            x_step_p : in bit_vector (7 downto 0);
            y_step_p : in bit_vector (7 downto 0);
            data_p : in integer;
            initiate_p : in bit;
            ready_p : in bit;
            x_pos_p : out bit;
            y_pos_p : out bit;
            x_dir_p : out bit;
            y_dir_p : out bit;
            motor_reset_p : out bit;
            output_p : out bit_vector (15 downto 0);
            strobe_p : out bit;
            diskport_p : out integer
           );
   end component;

   signal x_step_p : bit_vector (7 downto 0);
   signal y_step_p : bit_vector (7 downto 0);
   signal data_p : integer;
   signal initiate_p : bit;
   signal ready_p : bit;
   signal x_pos_p : bit;
   signal y_pos_p : bit;
   signal x_dir_p : bit;
   signal y_dir_p : bit;
   signal motor_reset_p : bit;
   signal output_p : bit_vector (15 downto 0);
   signal strobe_p : bit;
   signal diskport_p : integer;

   for all : VolumeSystemE
      use entity work.VolumeSystemE(VolumeSystemA);

begin

   SpecChart : VolumeSystemE
      port map (
               x_step_p,
               y_step_p,
               data_p,
               initiate_p,
               ready_p,
               x_pos_p,
               y_pos_p,
               x_dir_p,
               y_dir_p,
               motor_reset_p,
               output_p,
               strobe_p,
               diskport_p
              );

process 
   type data_array_type is array (1 to 20) of integer;
   variable data_array : data_array_type := 
      (20,15,0,0,0,0,15,20,0,0,20,15,0,0,0,0,15,20,0,0);
begin

   wait for 1 ns;
   initiate_p 	<= '1';
   ready_p 	<= '0';
   data_p	<= 0;
   x_step_p 	<= "00000010";
   y_step_p 	<= "00000001";
   wait for 5 ns;
   initiate_p 	<= '0';

   for i in 1 to 20 loop
      wait until (strobe_p = '1');
      data_p <= data_array(i);
      wait for 5 ns;
      ready_p <= '1', '0' after 10 ns;
   end loop;

   wait for 200 ns;

   assert (output_p = X"01A0") report "ERROR1: incorrect volume computed"
      severity error;

   wait;
end process;

end A;

