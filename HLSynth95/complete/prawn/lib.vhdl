--------------------------------------------------------------------------------
--
--   Prawn CPU Benchmark : Package for Behavioral Model
--
-- Derived from
--           Parwan : a reduced processor
--           from Chapter 9 of NAVABI : "VHDL: Analysis and Modeling of
--           Digital Systems" MacGraw-Hill,Inc. 1993
--
-- Author: Tadatoshi Ishii
--         Information and Computer Science,
--         University Of California, Irvine, CA 92717
--
-- Developed on Nov 1, 1992
--
-- Verification Information:
--
--                  Verified     By whom?           Date         Simulator
--                  --------   ------------        --------     ------------
--  Syntax            yes     Tadatoshi Ishii      01 Nov 92    Synopsys
--  Functionality     yes     Tadatoshi Ishii	   01 Nov 92    Synopsys
--------------------------------------------------------------------------------

library work;
use work.TYPES.all;
--
package LIB is

  subtype	NIBBLE		is	MVL7_VECTOR (3 downto 0);
  subtype	BYTE		is	MVL7_VECTOR (7 downto 0);
  subtype	TWELVE		is	MVL7_VECTOR (11 downto 0);

  subtype	WIRED_NIBBLE	is	BusX (3 downto 0);
  subtype	WIRED_BYTE	is	BusX (7 downto 0);
  subtype	WIRED_TWELVE	is	BusX (11 downto 0);

  constant ZERO_4		: NIBBLE		   := "0000";
  constant ZERO_8		: BYTE		           := "00000000";
  constant ZERO_12		: TWELVE		   := "000000000000";
  constant STACKP		: TWELVE		   := "111111111111";

  constant HI_IMP_8		: BusX			   := "ZZZZZZZZ";

  constant SINGLE_BYTE_INST	: MVL7_VECTOR (3 downto 0) := "1110";
  constant JRT			: MVL7_VECTOR (7 downto 0) := "11011111";
  constant NOP			: MVL7_VECTOR (3 downto 0) := "0000";
  constant CLA			: MVL7_VECTOR (3 downto 0) := "0001";
  constant CMA			: MVL7_VECTOR (3 downto 0) := "0010";
  constant BRT			: MVL7_VECTOR (3 downto 0) := "0011";
  constant CMC			: MVL7_VECTOR (3 downto 0) := "0100";
  constant STI			: MVL7_VECTOR (3 downto 0) := "0101";
  constant IRT			: MVL7_VECTOR (3 downto 0) := "0110";
  constant CLI			: MVL7_VECTOR (3 downto 0) := "0111";
  constant ASL			: MVL7_VECTOR (3 downto 0) := "1000";
  constant ASR			: MVL7_VECTOR (3 downto 0) := "1001";
  constant ROL			: MVL7_VECTOR (3 downto 0) := "1010";
  constant ROR			: MVL7_VECTOR (3 downto 0) := "1011";
  constant PUSHPOP		: MVL7_VECTOR (1 downto 0) := "11";
  constant JSR			: MVL7_VECTOR (3 downto 0) := "1100";
  constant BSR			: MVL7_VECTOR (7 downto 0) := "11111100";
  constant BR			: MVL7_VECTOR (3 downto 0) := "1111";
  constant INDIRECT		: MVL7			   := '1';
  constant JMP			: MVL7_VECTOR (2 downto 0) := "100";
  constant STA			: MVL7_VECTOR (2 downto 0) := "101";
  constant LDA			: MVL7_VECTOR (2 downto 0) := "000";
  constant ANN			: MVL7_VECTOR (2 downto 0) := "001";
  constant ADD			: MVL7_VECTOR (2 downto 0) := "010";
  constant SBB			: MVL7_VECTOR (2 downto 0) := "011";

  function add_cv (a, b : MVL7_VECTOR; cin : MVL7) return MVL7_VECTOR;
  function sub_cv (a, b : MVL7_VECTOR; cin : MVL7) return MVL7_VECTOR;

end LIB;
--
package body LIB is

  function add_cv (a, b : MVL7_VECTOR; cin : MVL7) return MVL7_VECTOR is
    variable r, c : MVL7_VECTOR (a'left + 2 downto 0);
    -- extra r bits: msb overflow, next carry
    variable a_sign, b_sign : MVL7;
  begin
    a_sign := a(a'left);
    b_sign := b(b'left);
    r(0) := a(0) xor b(0) xor cin;
    c(0) := ((a(0) xor b(0)) and cin) or (a(0) and b(0));
    for i in 1 to (a'left) loop
      r(i) := a(i) xor b(i) xor c(i-1);
      c(i) := ((a(i) xor b(i)) and c(i-1)) or (a(i) and b(i));
    end loop;
    r(a'left+1) := c(a'left);
    r(a'left+2) := nxor (a_sign, b_sign) and (r(a'left) xor a_sign);
    return r;
  end add_cv;
--
  function sub_cv (a, b : MVL7_VECTOR; cin : MVL7) return MVL7_VECTOR is
    variable r : MVL7_VECTOR (a'left + 2 downto 0);
    -- extra r bits: msb overflow, next carry
  begin
    r := add_cv (a, not b, not cin);
    r(a'left+1) := not r(a'left+1);
    return r;
  end sub_cv;

end LIB;
