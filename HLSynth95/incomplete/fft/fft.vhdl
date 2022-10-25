-- VHDL description of Fast Fourier Transform design example
--
-- Author: Loganathan Ramchandran, University of California, Irvine
--
-- Last Modified: 27 Jan 95  By Preeti R. Panda 
--				(removed VSS specific constructs)
-- Verification Information:
--
--                  Verified     By whom?           Date        Simulator
--                  --------   ------------        --------     ------------
--  Syntax            yes     Preeti R. Panda      27 Jan 95    Synopsys
--  Functionality     No

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity FFT is 
port (
	M         :   in integer;                    ---  number of points
	N         :   in integer;                    ---  2 ** number of points
	sig_real_inp   :  in UNSIGNED(7 downto 0);
	sig_imag_inp   :  in UNSIGNED(7 downto 0);
	sig_real_outp   :  out UNSIGNED(7 downto 0);
	sig_imag_outp   :  out UNSIGNED(7 downto 0)
     );
end FFT;


architecture ARCH_TIMER of FFT is 
begin
P1: process

	type Memory is array (integer range <>) of UNSIGNED(7 downto 0);
	variable    le      : integer;
	variable    windex  : integer;
	variable    wptrind : integer;
	variable    i,j,l,k : integer;
	variable    lower  : integer;

	variable    SigReal : Memory (1023 downto 0);
	variable    SigImag : Memory (1023 downto 0);
	variable    WReal   : Memory (1023 downto 0);
	variable    WImag   : Memory (1023 downto 0);

	variable    Wptr_Real : UNSIGNED(7 downto 0);
	variable    Wptr_Imag : UNSIGNED(7 downto 0);
	variable    xuReal : UNSIGNED(7 downto 0);
	variable    xuImag : UNSIGNED(7 downto 0);
	variable    TempReal : UNSIGNED(7 downto 0);
	variable    TempImag : UNSIGNED(7 downto 0);
	variable    TmReal : UNSIGNED(7 downto 0);
	variable    TmImag : UNSIGNED(7 downto 0);
	variable    xlReal : UNSIGNED(7 downto 0);
	variable    xlImag : UNSIGNED(7 downto 0);
	variable    xmReal : UNSIGNED(7 downto 0);
	variable    xmImag : UNSIGNED(7 downto 0);
        
begin

    wait on M, N, sig_real_inp, sig_imag_inp;

    i := 0;                  -- load all the signal values
    while(i < N) loop
	SigReal(i) := sig_real_inp;
	SigImag(i) := sig_imag_inp;
    end loop;


    le := N;
    windex := 1;
    wptrind := 0;

    l := 0;  
    while (l < M) loop

       le  := le / 2;
       j := 0;  

       while (j < le) loop
           Wptr_Real := WREAL(wptrind);
           Wptr_Imag := WIMAG(wptrind);
           i := j;  
           while (i < N) loop
              xuReal := SigReal(i);
              xuImag := SigImag(i);

	      lower := i + le;
              xlReal := SigReal(lower);
              xlImag := SigImag(lower);

	      TempReal := xuReal + XlReal;
	      TempImag := xuImag + XmImag;

	      SigReal(i) :=  TempReal;
	      SigImag(i) :=  TempImag;

	      TmReal := xuReal - XlReal;
	      TmImag := xuImag - XmImag;

	      TempReal := TmReal * Wptr_Real - TmImag * Wptr_Imag;
	      TempImag := TmReal * Wptr_Imag - TmImag * Wptr_Real;

	      SigReal(lower) := TempReal;
	      SigImag(lower) := TempImag;

              i := 2 * le;
           end loop;
           
           wptrind := wptrind + windex;
           j := j + 1;
       end loop;

       windex := 2 * windex;
       l := l + 1;
    end loop;

    j := 0;
    i := 1;
    while (i < (n-1)) loop
       k := n / 2;
      
       while ( k <= j) loop
          j := j - k;
          k := k / 2;
       end loop;

       j := j + k;
       if ( i < j) then
          tempReal  := SigReal(j);
          tempImag  := SigImag(j);
          SigReal(j) := SigReal(i);
          SigImag(j) := SigImag(i);
          SigReal(i) := tempReal;
          SigImag(i) := tempImag;
       end if;
    i := i + 1; 
    end loop;

    i := 0;                  -- load all the signal values
    while(i < N) loop
	sig_real_outp <= SigReal(i);
	sig_imag_outp <= SigImag(i);
    end loop;

end process P1;
end  ARCH_TIMER;












