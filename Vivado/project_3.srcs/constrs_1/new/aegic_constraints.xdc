# Define the primary clock from the top-level port
create_clock -name clk -period 20.000 [get_ports clk]

# Optional: Input delays (only if modeling external device latency, else skip)
#set_input_delay -clock clk 5.000 [get_ports rst]
#set_input_delay -clock clk 5.000 [get_ports wr_en]
#set_input_delay -clock clk 5.000 [get_ports rd_en]
#set_input_delay -clock clk 5.000 [get_ports addr*]
#set_input_delay -clock clk 5.000 [get_ports data_in*]

# Optional: Output delays (for output timing checks, can skip if not using physical board)
#set_output_delay -clock clk 5.000 [get_ports alert_out]
#set_output_delay -clock clk 5.000 [get_ports firewall_block]
#set_output_delay -clock clk 5.000 [get_ports led_status*]
