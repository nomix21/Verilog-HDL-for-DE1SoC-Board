module clock_divider(
    input clk, 
    input reset_n, 
    output reg clk_ms
);
    parameter factor = 50000;
    reg [31:0] countQ;
    
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            countQ <= 32'd0;
            clk_ms <= 1'b0;         // Fixed: 1-bit
        end
        else begin
            // Increment and wrap counter
            if (countQ == factor - 1) begin
                countQ <= 32'd0;
            end
            else begin
                countQ <= countQ + 1;
            end
            
            // Set output based on counter
            if (countQ < factor / 2) begin
                clk_ms <= 1'b0;     // Fixed: 1-bit
            end
            else begin
                clk_ms <= 1'b1;     // Fixed: 1-bit
            end
        end
    end endmodule