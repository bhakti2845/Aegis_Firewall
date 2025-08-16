
module ascii_converter (
    input [1:0] code, // 2-bit input code representing violation type
    output reg [7:0] ascii // ASCII output corresponding to code
);

    always @(*) begin
        case (code)
            2'b01: ascii = "R";  // Rule Violation
            2'b10: ascii = "P";  // Pattern Violation
            2'b11: ascii = "B";  // Both Violations
            default: ascii = 8'h00;
        endcase
    end

endmodule
