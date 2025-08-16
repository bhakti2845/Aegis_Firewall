

module packet_filter (
    input        clk, //clock signal
    input        rst, //reset
    input [15:0] addr_in, //input address 
    input [3:0]  cmd_in, //command input
    input [31:0] data_in, //data input
    output reg   rule_violation //High when rule is violated
);

    // Rule trigger signals
    wire r1_violation, r2_violation, r3_violation;
    // Rule Definitions
    assign r1_violation = (addr_in == 16'h0000);
    assign r2_violation = (data_in == 32'hDEADBEEF);
    assign r3_violation = ((cmd_in == 4'b0010) && (addr_in == 16'h1234)); 
    // Rule Violation Output Logic
    always @(posedge clk or posedge rst) begin
        if (rst)
            rule_violation <= 0;
        else
            rule_violation <= r1_violation | r2_violation | r3_violation;
    end

endmodule
