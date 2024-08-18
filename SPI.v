module spi #(parameter N = 2, parameter cpol = 0, parameter cpha = 0)
(
    input clk, // clk of the system
    input startTx,
    input startRx,
    input [15:0] din,
    input which_slave_enabled,
    output reg [N-1 : 0] cs, // enable of the master to send data to the slave in active low
    output reg mosi,
    output reg miso,
    output reg tx_done,
    output reg rx_done,
    output reg [15:0] bits_sent,   // Register to track bits sent
    output sclk // clk of the master
);

    // Generate the clock of the master to be 100MHz
    integer count = 0;
    reg sclkt;

    generate
        if (cpol) begin
            initial sclkt = 1;
        end else begin
            initial sclkt = 0;
        end
    endgenerate
    always @(posedge clk) begin
        if (count < 5)
            count <= count + 1;
        else begin
            count  <= 0;
            sclkt  <= ~sclkt;
        end
    end
    assign sclk = sclkt;

    /////////////////////////////////////
    localparam idle = 0, start_tx = 1, send = 2, end_tx = 3, receive=4, end_rx = 5, start_rx = 6; 
    reg [3:0] state = idle;
    reg [15:0] temp;
    integer bitcount = 0;

    generate
        if (!cpha) begin
            always @(posedge sclkt) begin
                case(state)
                    idle: begin
                        mosi <= 1'b0;
                        temp <= 12'h000;
                        cs <= {N{1'b1}};
                        tx_done <= 1'b0; 
                        rx_done <= 1'b0; 
                        bits_sent <= 15'h000; // Initialize bits_sent
                        if (startTx && !startRx)
                            state <= start_tx;
                        else if (!startTx && startRx)
                            state <= start_rx;
                        else
                            state <= idle;
                    end

                    start_tx: begin
                        case (which_slave_enabled)
                            1'b0: begin
                                cs <= 2'b10;
                            end
                            1'b1: begin
                                cs <= 2'b01;
                            end
                        endcase
                        mosi <= 1'b1;
                        miso <= 1'b0;
                        temp <= din;
                        //bits_sent <= din; // Set bits_sent to the input data
                        state <= send;
                    end
                    start_rx: begin
                        case (which_slave_enabled)
                            1'b0: begin
                                cs <= 2'b10;
                            end
                            1'b1: begin
                                cs <= 2'b01;
                            end
                        endcase
                        mosi <= 1'b0;
                        miso  <= 1'b1;
                        state <= receive;
                    end
                    send: begin
                        if (bitcount <= 15) begin
                            bitcount <= bitcount + 1;
                            state <= send;
                        end else begin
                            bits_sent <= temp;
                            bitcount <= 0;
                            mosi <= 1'b0;
                            state <= end_tx;
                        end
                    end
                    receive: begin
                        if (bitcount <= 15) begin
                            bitcount <= bitcount + 1;
                            state <= receive;
                        end else begin
                            bits_sent <= din;
                            bitcount <= 0;
                            mosi <= 1'b0;
                            miso  <= 1'b0;
                            state <= end_rx;
                        end
                    end
                    end_tx: begin
                        cs <= {N{1'b1}};
                        tx_done <= 1'b1; 
                        state <= idle;
                    end
                    end_rx: begin
                        cs <= {N{1'b1}};
                        rx_done <= 1'b1; 
                        state <= idle;
                    end
                    default: state <= idle;
                endcase
            end
        end else begin
            always @(negedge sclkt) begin
                case(state)
                    idle: begin
                        mosi <= 1'b0;
                        temp <= 12'h000;
                        cs <= {N{1'b1}};
                        tx_done <= 1'b0; 
                        rx_done <= 1'b0; 
                        bits_sent <= 15'h000; // Initialize bits_sent
                        if (startTx && !startRx)
                            state <= start_tx;
                        else if (!startTx && startRx)
                            state <= start_rx;
                        else
                            state <= idle;
                    end

                    start_tx: begin
                        case (which_slave_enabled)
                            1'b0: begin
                                cs <= 2'b10;
                            end
                            1'b1: begin
                                cs <= 2'b01;
                            end
                        endcase
                        mosi <= 1'b1;
                        miso  <= 1'b0;
                        temp <= din;
                        bits_sent <= din; // Set bits_sent to the input data
                        state <= send;
                    end
                    start_rx: begin
                        case (which_slave_enabled)
                            1'b0: begin
                                cs <= 2'b10;
                            end
                            1'b1: begin
                                cs <= 2'b01;
                            end
                        endcase
                        mosi <= 1'b0;
                        miso  <= 1'b1;
                        state <= receive;
                    end
                    send: begin
                        if (bitcount <= 15) begin
                            bitcount <= bitcount + 1;
                            state <= send;
                        end else begin
                            bits_sent <= temp;
                            bitcount <= 0;
                            mosi <= 1'b0;
                            state <= end_tx;
                        end
                    end
                    receive: begin
                        if (bitcount <= 15) begin
                            bitcount <= bitcount + 1;
                            state <= receive;
                        end else begin
                            bits_sent <= din;
                            bitcount <= 0;
                            mosi <= 1'b0;
                            miso  <= 1'b0;
                            state <= end_rx;
                        end
                    end
                    end_tx: begin
                        cs <= {N{1'b1}};
                        tx_done <= 1'b1; 
                        state <= idle;
                    end
                    end_rx: begin
                        cs <= {N{1'b1}};
                        rx_done <= 1'b1; 
                        state <= idle;
                    end
                    default: state <= idle;
                endcase
            end
        end
    endgenerate
    
endmodule