ghdl -a ../rtl/rst_synch.vhd ../rtl/lcd_write.vhd ../rtl/lcd_controller.vhd ../tb/lcd_controller_tb.vhd
ghdl -s ../rtl/rst_synch.vhd ../rtl/lcd_write.vhd ../rtl/lcd_controller.vhd ../tb/lcd_controller_tb.vhd
ghdl -e lcd_controller_tb
ghdl -r lcd_controller_tb --vcd=lcd_controller_tb.vcd --stop-time=60000000ns