ghdl -a ../rtl/button_synch.vhd ../tb/button_synch_tb.vhd
ghdl -s ../rtl/button_synch.vhd ../tb/button_synch_tb.vhd
ghdl -e button_synch_tb
ghdl -r button_synch_tb --vcd=button_synch_tb.vcd --stop-time=16000ns