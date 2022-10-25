--------------------------------------------------------------------------------
--
-- Controlled Counter Benchmark
--
-- Source: "Chip Level Modeling with VHDL" by Jim Armstrong (Prentice-Hall 1989)
--
-- Benchmark author: Joe Lis
--
--    Copyright (c) by Joe Lis 1988
--
-- Modified by : Champaka Ramachandran on Aug 24th 1992
--
-- Verification Information:
--
--                Verified  By whom?               Date       Simulator
--                --------  ------------           --------   ------------
--  Syntax         yes      Champaka Ramachandran  24/8/92     ZYCAD
--  Functionality  yes      Champaka Ramachandran  24/8/92     ZYCAD
--------------------------------------------------------------------------------

use work.BIT_FUNCTIONS.all;

entity ARMS_COUNTER is
  port (
        CLK: in BIT;
        STRB : in bit;
        CON: in BIT_VECTOR(1 downto 0);
        DATA: in BIT_VECTOR(3 downto 0);
        COUT: out BIT_VECTOR(3 downto 0));

end ARMS_COUNTER;

--VSS: design_style behavioural

architecture ARMS_COUNTER of ARMS_COUNTER is

   signal ENIT, RENIT: BIT;
   signal EN: BIT;
   signal CONSIG, LIM: BIT_VECTOR(3 downto 0);
   signal CNT : BIT_VECTOR(3 downto 0);

begin

----------------  The decoder -------------------------------------

DECODE: process (STRB, RENIT)

variable CONREG: BIT_VECTOR(1 downto 0) := "00";

begin

  if (STRB = '1') and (not STRB'STABLE) then
    CONREG := CON;

    case CONREG is
         when "00" => CONSIG <= "0001";
         when "01" => CONSIG <= "0010";
         when "10" => CONSIG <= "0100"; ENIT <= '1';
         when "11" => CONSIG <= "1000"; ENIT <= '1';
         when others =>
    end case;

  end if; -- Rising edge of STRB

  if (RENIT = '1') and (not RENIT'STABLE) then
    ENIT <= '0';
  end if;

end process DECODE;


----------------  The limit loader -------------------------------------

LOAD_LIMIT: process (STRB)

begin

  if (CONSIG(1) = '1') and (not STRB'STABLE) and (STRB = '0') then
    LIM <= DATA;
  end if;

end process LOAD_LIMIT;


----------------  The counter -------------------------------------

CTR: process (CONSIG(0), EN, CLK)
			
variable CNTE : BIT := '0';

begin

  if (CONSIG(0) = '1') and (not CONSIG(0)'STABLE) then
    CNT <= "0000";
  end if;

  if (not EN'STABLE) then
    if (EN = '1') then
      CNTE := '1';
    else
      CNTE := '0';
    end if;
  end if;

  if (not CLK'STABLE) and (CLK = '1') and (CNTE = '1') then
    if (CONSIG(2) = '1') then
      CNT <= CNT + "0001";
    elsif (CONSIG(3) = '1') then
          CNT <= CNT - "0001";
    end if;
  end if;

end process CTR;

----------------  The comparator -------------------------------------

LIMIT_CHK: process (CNT, ENIT)

begin

  if (not ENIT'STABLE) then
    if (ENIT = '1') then
      EN <= '1'; RENIT <= '1';
    else
      RENIT <= '0';
    end if;
  end if;

  if (EN = '1') and (CNT = LIM) then
    EN <= '0';
  end if;

end process LIMIT_CHK;

COUT <= CNT;


end ARMS_COUNTER;
