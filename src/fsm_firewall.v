
module fsm_firewall (
    input clk, // Clock signal
    input rst, //reset signal
    input rule_violation, // Rule-based violation flag
    input pattern_violation, // Pattern-based violation flag


    output reg alert_out, // High when in ALERT state
    output reg firewall_block, // High when system is ISOLATED
    output reg [1:0] led_status // Current FSM state for visual status
);
    // State Encoding
    parameter NORMAL  = 2'b00;
    parameter ALERT   = 2'b01;
    parameter ISOLATE = 2'b10;
    parameter RECOVER = 2'b11;
    // Internal Registers and Wires
    reg [1:0] current_state, next_state;
    reg [1:0] alert_counter;
    reg [7:0] isolate_timer;

    wire violation = rule_violation || pattern_violation;

    // Sequential Logic – State Register & Counters
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_state   <= NORMAL;
            alert_counter   <= 2'd0;
            isolate_timer   <= 8'd0;
        end else begin
            current_state <= next_state;

            if (violation) begin
                alert_counter <= alert_counter + 1;
            end else if (current_state == NORMAL || current_state == RECOVER) begin
                alert_counter <= 0;  
            end

            if (current_state == ISOLATE)
                isolate_timer <= isolate_timer + 1;
            else
                isolate_timer <= 0;
        end
    end

    // Combinational Logic – Next State Transition Logic
    always @(*) begin
        case (current_state)
            NORMAL: begin
                if (violation)
                    next_state = ALERT;
                else
                    next_state = NORMAL;
            end

            ALERT: begin
                if (alert_counter >= 3)
                    next_state = ISOLATE;
                else if (!violation)
                    next_state = NORMAL;
                else
                    next_state = ALERT;
            end

            ISOLATE: begin
                if (isolate_timer >= 20)
                    next_state = RECOVER;
                else
                    next_state = ISOLATE;
            end

            RECOVER: begin
                if (!violation)
                    next_state = NORMAL;
                else
                    next_state = RECOVER;
            end

            default: next_state = NORMAL;
        endcase
    end

    // Output Logic – Based on Current State
    always @(*) begin
        alert_out      = (current_state == ALERT);
        firewall_block = (current_state == ISOLATE);
        led_status     = current_state;
    end

endmodule
