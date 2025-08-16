`timescale 1ns / 1ps

module tb_top_firewall;
    // Inputs
    reg clk, rst;
    reg [31:0] data_in;
    reg [15:0] addr;
    reg wr_en, rd_en;
    // Outputs
    wire alert_out, firewall_block;
    wire [1:0] led_status;
    

    // DUT instantiation
    top_firewall uut (
        .clk(clk),
        .rst(rst),
        .data_in(data_in),
        .addr(addr),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .alert_out(alert_out),
        .firewall_block(firewall_block),
        .led_status(led_status)
    );

    // Clock Generation – 50MHz (20ns period)
    initial clk = 0;
    always #10 clk = ~clk;
    // Simulation Sequence
    initial begin
        // Dump VCD for waveform view
        $dumpfile("top_firewall.vcd");
        $dumpvars(0, tb_top_firewall);
        $dumpvars(0, tb_top_firewall.uut.u1.rule_violation);
        $dumpvars(0, tb_top_firewall.uut.u2.pattern_violation);
        $dumpvars(0, tb_top_firewall.uut.u2.repeat_flag);
        $dumpvars(0, tb_top_firewall.uut.u2.signature_flag);

        // Initial Reset
        rst = 1; data_in = 0; addr = 0; wr_en = 0; rd_en = 0;
        #20;
        rst = 0;

        // Test 1: Clean Packet
        addr = 16'h1000; data_in = 32'h12345678; wr_en = 0; rd_en = 1;
        #20;

        // Test 2: Rule Violation (write to 0x1234)
        addr = 16'h1234; data_in = 32'hDEADBEEF; wr_en = 1; rd_en = 0;
        #20;

        // Test 3: Signature Pattern Match (CAFEBABE)
        addr = 16'h2000; data_in = 32'hCAFEBABE; wr_en = 0; rd_en = 1;
        #20;

        // Test 4: Another Signature Pattern (0000BEEF)
        addr = 16'h2000; data_in = 32'h0000BEEF; wr_en = 0; rd_en = 1;
        #20;
        
         addr = 16'h3000; data_in = 32'h11111111; wr_en = 0; rd_en = 1;
        #20;
         addr = 16'h3000; data_in = 32'h11111111; wr_en = 0; rd_en = 1;
        #20;

        // Test 5: Repeat Violation (3x same data)
        addr = 16'h2000; data_in = 32'hAAAA5555; wr_en = 0; rd_en = 1;
        #20;
        addr = 16'h2000; data_in = 32'hAAAA5555; wr_en = 0; rd_en = 1;
        #20;
        addr = 16'h2000; data_in = 32'hAAAA5555; wr_en = 0; rd_en = 1;
        #20;
        

        // Test 7: Both Violations (DEADBEEF + forbidden addr)
        addr = 16'h0000; data_in = 32'hDEADBEEF; wr_en = 1; rd_en = 0;
        #20;
         addr = 16'h0000; data_in = 32'hDEADBEEF; wr_en = 1; rd_en = 0;
        #20;
         addr = 16'h1234; data_in = 32'hDEADBEEF; wr_en = 1; rd_en = 0;
        #20;
        #400

        addr = 16'h2000; data_in = 32'hAAAA5555; wr_en = 0; rd_en = 1;
        #20;
        addr = 16'h2000; data_in = 32'hAAAA5555; wr_en = 0; rd_en = 1;
        #20;
        addr = 16'h2000; data_in = 32'hAAAA5555; wr_en = 0; rd_en = 1;
        #20;
        #400;
         addr = 16'h3000; data_in = 32'h11111111; wr_en = 0; rd_en = 1;
        #20;
        


        $finish;
    end

endmodule
