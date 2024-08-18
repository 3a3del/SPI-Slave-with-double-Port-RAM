module spi_ram_wrapper #(
    parameter N = 2,
    parameter cpol = 0,
    parameter cpha = 0,
    parameter MEM_DEPTH = 256,
    parameter ADDR_SIZE = 8
)(
    input clk,                      // System clock
    input startTx,                  // Start transmission
    input startRx,                  // Start reception
    input which_slave_enabled,      // Select which SPI slave is enabled
    input [2*ADDR_SIZE-1:0] spi_din,// Data input for SPI
    input ram_rst_n_b,              // Reset signal for port B of the RAM
    input ram_rst_n_a,              // Reset signal for port A of the RAM
    output spi_mosi,                // SPI MOSI
    output spi_miso,                // SPI MISO
    output [2*ADDR_SIZE-1:0] spi_bits_sent, // SPI bits sent
    output [N-1:0] spi_cs           // SPI chip select
    // output spi_sclk // SPI clock
);
    wire [ADDR_SIZE-1:0] ram_addr_b;// Address for port B of the RAM
    // Internal wires
    wire spi_tx_done;             // SPI transmission done
    wire spi_rx_done;             // SPI reception done
    wire [ADDR_SIZE-1:0] ram_addr_a; // Address for port A of the RAM
    wire [ADDR_SIZE-1:0] ram_dout_a; // Data output for port A of the RAM
    wire [ADDR_SIZE-1:0] ram_dout_b; // Data output for port B of the RAM
    wire [ADDR_SIZE-1:0] ram_din_a;// Data input for port A of the RAM
    wire [ADDR_SIZE-1:0] ram_din_b;// Data input for port B of the RAM
    wire ram_tx_en_a;              // Transmit enable for port A of the RAM
    wire ram_rx_en_a;              // Receive enable for port A of the RAM
    wire ram_tx_en_b;              // Transmit enable for port B of the RAM
    wire ram_rx_en_b;              // Receive enable for port B of the RAM
    // Instantiate the SPI module
    spi #(
        .N(N),
        .cpol(cpol),
        .cpha(cpha)
    ) spi_inst (
        .clk(clk),
        .startTx(startTx),
        .startRx(startRx),
        .din(spi_din),
        .which_slave_enabled(which_slave_enabled),
        .cs(spi_cs),
        .mosi(spi_mosi),
        .miso(spi_miso),
        .tx_done(spi_tx_done),
        .rx_done(spi_rx_done),
        .bits_sent(spi_bits_sent),
        .sclk(spi_sclk) // Uncomment if needed
    );

    // Instantiate the Dual-Port RAM module
    RAM #(
        .MEM_DEPTH(MEM_DEPTH),
        .ADDR_SIZE(ADDR_SIZE)
    ) ram_inst (
        .din_a(spi_bits_sent[2*ADDR_SIZE-1:ADDR_SIZE]), 
        .din_b(spi_bits_sent[2*ADDR_SIZE-1:ADDR_SIZE]),
        .addr_a(spi_bits_sent[ADDR_SIZE-1:0]),
        .addr_b(spi_bits_sent[ADDR_SIZE-1:0]),
        .clk(spi_sclk),
        .tx_en_b(startTx && !which_slave_enabled),
        .rx_en_b(startRx && !which_slave_enabled),
        .rst_n_b(ram_rst_n_b),
        .tx_en_a(startTx && which_slave_enabled),
        .rx_en_a(startRx && which_slave_enabled),
        .rst_n_a(ram_rst_n_a),
        .dout_a(ram_dout_a),
        .dout_b(ram_dout_b),
        .tx_valid_a(ram_tx_en_a),
        .rx_valid_a(ram_rx_en_a),
        .tx_valid_b(ram_tx_en_b),
        .rx_valid_b(ram_rx_en_b)
    );

endmodule

