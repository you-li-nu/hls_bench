# run_bft_kintex7_project.tcl
# BFT sample design 
#    A Vivado script that demonstrates an RTL-to-bitstream project flow.
#    This script will create a project, copy sources into the project 
#    directory, run synthesis, implementation and generate a bitstream.
#    It will also write a few reports to disk and open the GUI when finished.
#
# NOTE:  -Typical usage would be "vivado -mode tcl -source run_bft_kintex7_project.tcl" 
#        -To use -mode batch comment out the "start_gui" and "open_run impl_1" to save time
#
create_project project_bft_batch ./Tutorial_Created_Data/project_bft_batch -part xc7k70tfbg484-2
add_files {./Sources/hdl/FifoBuffer.v ./Sources/hdl/async_fifo.v ./Sources/hdl/bft.vhdl}
add_files -fileset sim_1 ./Sources/hdl/bft_tb.v
add_files ./Sources/hdl/bftLib
set_property library bftLib [get_files  {./Sources/hdl/bftLib/round_4.vhdl ./Sources/hdl/bftLib/round_3.vhdl ./Sources/hdl/bftLib/round_2.vhdl ./Sources/hdl/bftLib/round_1.vhdl ./Sources/hdl/bftLib/core_transform.vhdl ./Sources/hdl/bftLib/bft_package.vhdl}]
import_files -force
import_files -fileset constrs_1 -force -norecurse ./Sources/bft_full_kintex7.xdc
# Mimic GUI behavior of automatically setting top and file compile order
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
# Launch Synthesis
launch_runs synth_1
wait_on_run synth_1
open_run synth_1 -name netlist_1
# Generate a timing and power reports and write to disk
report_timing_summary -delay_type max -report_unconstrained -check_timing_verbose -max_paths 10 -input_pins -file ./Tutorial_Created_Data/project_bft_batch/syn_timing.rpt
report_power -file ./Tutorial_Created_Data/project_bft_batch/syn_power.rpt
# Launch Implementation
launch_runs impl_1 -to_step write_bitstream
wait_on_run impl_1 
# Generate a timing and power reports and write to disk
# comment out the open_run for batch mode
open_run impl_1
report_timing_summary -delay_type min_max -report_unconstrained -check_timing_verbose -max_paths 10 -input_pins -file ./Tutorial_Created_Data/project_bft_batch/imp_timing.rpt
report_power -file ./Tutorial_Created_Data/project_bft_batch/imp_power.rpt
# comment out the for batch mode
start_gui
