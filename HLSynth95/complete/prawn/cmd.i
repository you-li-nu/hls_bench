--------------------------------------------------------------------------------
--
--   Prawn CPU Benchmark : command initialize file for Zycad VHDL Simulator v1.0
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
--------------------------------------------------------------------------------

open run.out
logtime -e run.out

-- monitor ACTIVE SIM/interrupt
-- monitor ACTIVE SIM/inta
-- monitor ACTIVE SIM/clock
-- monitor ACTIVE SIM/read
-- monitor ACTIVE SIM/write
-- monitor ACTIVE SIM/data
-- monitor ACTIVE SIM/mem/databus
-- monitor ACTIVE SIM/address
-- monitor WRITE SIM/mem/mem/finish
-- monitor WRITE  SIM/mem/mem/memory
-- monitor WRITE   SIM/mem/mem/memory1
-- monitor WRITE   SIM/mem/mem/memory2
-- monitor WRITE   SIM/mem/mem/memory3
-- monitor WRITE   SIM/mem/mem/memory4
-- monitor WRITE   SIM/mem/mem/memory6

list > run.out

run > run.out

quit
