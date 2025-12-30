set DESIGN sync_fifo
set GEN_EFF medium
set MAP_OPT_EFF medium

set_db / .init_lib_search_path {../library}
set_db / .init_hdl_search_path {../rtl}
set_db / .information_level 7

read_libs fast.lib
read_hdl fifo.v
elaborate
check_design -unresolved
read_sdc ../SDC/fifo.sdc

set_db / .syn_generic_effort $GEN_EFF
syn_generic
set_db / .syn_map_effort $MAP_OPT_EFF
syn_map
set_db / .syn_opt_effort $MAP_OPT_EFF
syn_opt

report_area > top_Area.rpt
report_power > top_power.rpt
report_timing > top_timing.rpt
write_hdl > top_netlist.v
write_sdc > top_sdc.sdc

gui_show
