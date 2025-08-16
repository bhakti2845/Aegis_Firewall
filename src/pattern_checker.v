

module pattern_checker (
    input wire clk, //clock signal
    input wire rst, //reset
    input wire [31:0] data_in, //input data
    output reg pattern_violation, //High if any suspicious pattern is detected
    output reg repeat_flag, // High if same data repeats 3 times consecutively
    output reg signature_flag, // High if a known malicious signature is seen
    output reg [2:0] repeat_count, // Counter for repeated values (max count = 3)
    output reg [2:0] timeout_counter, // Counts the number of cycles since last repeated value
    output reg [31:0] prev_data // Stores last seen data value
);

    // Signature patterns
    parameter SIG1 = 32'hCAFEBABE;
    parameter SIG2 = 32'h0000BEEF;
    // Pattern Detection Logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset all flags and counters
            pattern_violation <= 0;
            repeat_flag       <= 0;
            signature_flag    <= 0;
            repeat_count      <= 1;  
            timeout_counter   <= 0;
            prev_data         <= 32'h0;
        end else begin
            // Check for known signature
            signature_flag <= (data_in == SIG1 || data_in == SIG2);

            // Check for repeat pattern
            if (data_in == prev_data) begin
                if (repeat_count < 3)
                    repeat_count <= repeat_count + 1;
                repeat_flag <= (repeat_count + 1 == 3);
                timeout_counter <= 0;
            end else begin
                // Reset repeat detection
                repeat_count <= 1;  
                repeat_flag <= 0;   
                timeout_counter <= timeout_counter + 1;
            end

            // Combine both conditions
            pattern_violation <= signature_flag || repeat_flag;

            // Update previous data
            prev_data <= data_in;
        end
    end
endmodule
