module RAM #(parameter MEM_DEPTH = 256, parameter ADDR_SIZE = 8)
(   input  [ADDR_SIZE-1:0] din_a,
    input  [ADDR_SIZE-1:0] din_b,
    input  [ADDR_SIZE-1:0] addr_a,
    input  [ADDR_SIZE-1:0] addr_b,
    input  clk,
    input  tx_en_b,
    input  rx_en_b,
    input  rst_n_b,
    input  tx_en_a,
    input  rx_en_a,
    input  rst_n_a,
    output reg [ADDR_SIZE-1:0] dout_a,
    output reg [ADDR_SIZE-1:0] dout_b,
    output reg tx_valid_a,
    output reg rx_valid_a,
    output reg tx_valid_b,
    output reg rx_valid_b
);
reg [ADDR_SIZE-1:0] mem [MEM_DEPTH-1:0];
always @(posedge clk or negedge rst_n_a) begin
    if (!rst_n_a) begin
        tx_valid_a <= 0;
        rx_valid_a <= 0;
        dout_a <= 0;
    end 
    else begin
        if (tx_en_a) begin
            dout_a <= mem[addr_a];
            tx_valid_a <= 1'b1;
            rx_valid_a <= 1'b0;
        end
        else if (rx_en_a) begin
            mem[addr_a] <= din_a;
            tx_valid_a <= 1'b0;
            rx_valid_a <= 1'b1;            
        end
        else begin
            tx_valid_a <= 1'b0;
            rx_valid_a <= 1'b0;          
        end
    end
end
always @(posedge clk or negedge rst_n_b) begin
    if (!rst_n_b) begin
        tx_valid_b<= 0;
        rx_valid_b <= 0;
        dout_b <= 0;
    end 
    else begin
        if (tx_en_b) begin
            dout_b <= mem[addr_b];
            tx_valid_b <= 1'b1;
            rx_valid_b <= 1'b0;
        end
        else if (rx_en_b) begin
            mem[addr_b] <= din_b;
            tx_valid_b <= 1'b0;
            rx_valid_b <= 1'b1;            
        end
        else begin
            tx_valid_b <= 1'b0;
            rx_valid_b <= 1'b0;          
        end
    end
end
endmodule
