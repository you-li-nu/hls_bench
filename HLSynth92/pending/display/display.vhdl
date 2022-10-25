
ENTITY display IS
PORT(reset  : IN bit;                     -- Global reset
     clk    : IN bit;                     -- Global clock
     en     : IN boolean;
     unit0 : OUT bit_vector(6 DOWNTO 0);
     unit1 : OUT bit_vector(6 DOWNTO 0);
     unit2 : OUT bit_vector(6 DOWNTO 0);
     unit3 : OUT bit_vector(6 DOWNTO 0));
END display;


ARCHITECTURE algorithm OF display IS

  SUBTYPE nat4 is integer RANGE  15 DOWNTO 0;
  SUBTYPE nat3 is integer RANGE   7 DOWNTO 0;

BEGIN
  display: PROCESS
    VARIABLE   secs,  mins  : nat4; -- counters for seconds and minutes
    VARIABLE   tsecs, tmins : nat3; -- counters for ten seconds and ten minutes
  BEGIN 

    -- Initialization

    secs  := 0;
    tsecs := 0;
    mins  := 0;
    tmins := 0;
    unit0 <= "1000000";
    unit1 <= "1000000";
    unit2 <= "1000000";
    unit3 <= "1000000";

    RESET_LOOP: LOOP
    WAIT UNTIL clk = '1'; EXIT RESET_LOOP WHEN reset = '1';

-- decoder part of the display circuit:
-- 
--                   0                              6543210
--                -------                      0 :  1000000
--               |       |       unitX(6..0)   1 :  1111001
--              5|       |1                    2 :  0100100
--               |   6   |                     3 :  0110000
--                -------                      4 :  0011001
--               |       |                     5 :  0010010
--              4|       |2                    6 :  0000010
--               |       |                     7 :  1111000
--                -------                      8 :  0000000
--                   3                         9 :  0010000
--            0=light, 1=dark!
--

    CASE secs IS
        WHEN 0 => unit0 <= "1000000";
        WHEN 1 => unit0 <= "1111001";
        WHEN 2 => unit0 <= "0100100";
        WHEN 3 => unit0 <= "0110000";
        WHEN 4 => unit0 <= "0011001";
        WHEN 5 => unit0 <= "0010010";
        WHEN 6 => unit0 <= "0000010";
        WHEN 7 => unit0 <= "1111000";
        WHEN 8 => unit0 <= "0000000";
        WHEN 9 => unit0 <= "0010000";
        WHEN others => unit0 <= "0000000";
    END CASE;

    CASE tsecs IS
        WHEN 0 => unit1 <= "1000000";
        WHEN 1 => unit1 <= "1111001";
        WHEN 2 => unit1 <= "0100100";
        WHEN 3 => unit1 <= "0110000";
        WHEN 4 => unit1 <= "0011001";
        WHEN 5 => unit1 <= "0010010";
        WHEN others => unit1 <= "0000000";
    END CASE;

    CASE mins IS
        WHEN 0 => unit2 <= "1000000";
        WHEN 1 => unit2 <= "1111001";
        WHEN 2 => unit2 <= "0100100";
        WHEN 3 => unit2 <= "0110000";
        WHEN 4 => unit2 <= "0011001";
        WHEN 5 => unit2 <= "0010010";
        WHEN 6 => unit2 <= "0000010";
        WHEN 7 => unit2 <= "1111000";
        WHEN 8 => unit2 <= "0000000";
        WHEN 9 => unit2 <= "0010000";
        WHEN others => unit2 <= "0000000";
    END CASE;

    CASE tmins IS
        WHEN 0 => unit3 <= "1000000";
        WHEN 1 => unit3 <= "1111001";
        WHEN 2 => unit3 <= "0100100";
        WHEN 3 => unit3 <= "0110000";
        WHEN 4 => unit3 <= "0011001";
        WHEN 5 => unit3 <= "0010010";
        WHEN others => unit3 <= "0000000";
    END CASE;

    IF en THEN
      IF (secs = 9) THEN
        secs  := 0;
        IF tsecs = 5 THEN
            tsecs  := 0;
            IF mins = 9 THEN
                mins  := 0;
                IF tmins = 5 THEN
                    tmins := 0;
                ELSE
                    tmins := tmins + 1;
                END IF;
            ELSE 
                mins  := mins + 1;
            END IF;
        ELSE
            tsecs  := tsecs + 1;
        END IF;
      ELSE
        secs  := secs + 1;
      END IF;
    END IF;

  END LOOP RESET_LOOP;

  END PROCESS display;
END algorithm;
