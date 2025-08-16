

module top_firewall (
    input clk, // clock signal
    input rst, // reset signal
    input [31:0] data_in, // data input
    input [15:0] addr, // address input
    input wr_en, // write enable
    input rd_en, // read enable

    output alert_out, // High if system is in ALERT state
    output firewall_block, // High if system is in ISOLATES state
    output [1:0] led_status // FSM current state for visual status
);
    // Internal Wires
    wire rule_violation;
    wire pattern_violation;
    wire [1:0] violation_code;
   
    assign violation_code = {pattern_violation, rule_violation};

    // Packet Filter Module – Rule-Based Violation Detection
    packet_filter u1 (
        .clk(clk),
        .rst(rst),
        .addr_in(addr),
        .cmd_in({2'b00, wr_en, rd_en}),
        .data_in(data_in),
        .rule_violation(rule_violation)
    );

// Pattern Checker Module – Signature and Repeat Detection
wire repeat_flag;
wire signature_flag;
wire [2:0] repeat_count;
wire [2:0] timeout_counter;
wire [31:0] prev_data;

pattern_checker u2 (
    .clk(clk),
    .rst(rst),
    .repeat_count(repeat_count),        
    .timeout_counter(timeout_counter),
    .prev_data(prev_data),         
    .data_in(data_in),
    .repeat_flag(repeat_flag),
    .signature_flag(signature_flag),
    .pattern_violation(pattern_violation)
);

    // FSM Firewall Controller – Handles State Transitions
    fsm_firewall u3 (
        .clk(clk),
        .rst(rst),
        .rule_violation(rule_violation),
        .pattern_violation(pattern_violation),
        .alert_out(alert_out),
        .firewall_block(firewall_block),
        .led_status(led_status)
    );
    wire [7:0] ascii_msg;
   
    // ASCII Converter – Converts Violation Code to Message
    ascii_converter u4 (
        .code(violation_code),
        .ascii(ascii_msg)
    );

endmodule
