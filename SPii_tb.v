`timescale 1ns / 1ps

module tb_spi_ram_wrapper;

    // Parameters
    parameter N = 2;
    parameter cpol = 0;
    parameter cpha = 0;
    parameter MEM_DEPTH = 256;
    parameter ADDR_SIZE = 8;

    // Testbench signals
    reg clk;
    reg startTx;
    reg startRx;
    reg which_slave_enabled;
    reg [2*ADDR_SIZE-1:0] spi_din;
    reg ram_rst_n_b;              // Reset signal for port B of the RAM
    reg ram_rst_n_a;              // Reset signal for port A of the RAM
    wire spi_mosi;
    wire spi_miso;
    wire [2*ADDR_SIZE-1:0] spi_bits_sent;  // Corrected signal name
    wire [N-1:0] spi_cs;

    // Instantiate the spi_ram_wrapper module
    spi_ram_wrapper #(
        .N(N),
        .cpol(cpol),
        .cpha(cpha),
        .MEM_DEPTH(MEM_DEPTH),
        .ADDR_SIZE(ADDR_SIZE)
    ) uut (
        .clk(clk),
        .startTx(startTx),
        .startRx(startRx),
        .which_slave_enabled(which_slave_enabled),
        .spi_din(spi_din),
        .ram_rst_n_b(ram_rst_n_b),
        .ram_rst_n_a(ram_rst_n_a),
        .spi_mosi(spi_mosi),
        .spi_miso(spi_miso),
        .spi_bits_sent(spi_bits_sent),  // Corrected signal name
        .spi_cs(spi_cs)
    );

    // Initialize RAM memory (if necessary)
    initial begin
        // Example for direct RAM initialization if needed
        // Assuming you have access to `ram_inst.mem` for initialization
        // Replace this with correct initialization if `ram_inst` is not directly accessible
        integer i;
        for (i = 0; i < MEM_DEPTH; i = i + 1) begin
            uut.ram_inst.mem[i] = 0;  // Example initialization
        end
        // Uncomment if using memory file
        // parameter MEM_FILE = "C:\\Users\\hp\\Desktop\\project\\mem.dat";
        // if (MEM_FILE != 0) begin
        //     $readmemh(MEM_FILE, uut.ram_inst.mem);
        // end
    end

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 100 MHz clock
    end

    // Test sequence
    initial begin
        // Initialize inputs
        startTx = 0;
        startRx = 0;
        which_slave_enabled = 0;
        spi_din = 16'b0;
        ram_rst_n_b = 0;
        ram_rst_n_a = 0;

        // Wait for reset
        #20;

        // Test Case 1: Send data to slave 0
        which_slave_enabled = 0;
        spi_din = 16'hABCD;  // Example data
        startTx = 1;
        @(posedge spi_mosi); display; startTx = 0;
        #20;

        // Test Case 2: Receive data from slave 0
        startRx = 1;
        spi_din = 16'hABBB;
        @(posedge spi_miso); display; startRx = 0;
        #20;

        // Test Case 3: Send data to slave 1
        which_slave_enabled = 1;
        spi_din = 16'h1234;  // Example data
        startTx = 1;
        @(posedge spi_mosi); display; startTx = 0;
        #20;

        // Test Case 4: Receive data from slave 1
        startRx = 1;
        spi_din = 16'h12AB;
        @(posedge spi_miso); display; startRx = 0;
        #20;

        // Stop the simulation
        $stop;
    end

    // Display task to print SPI signals
    task display;
    begin
        $display("Time: %0t | MOSI: %b | MISO: %b", $time, spi_mosi, spi_miso);
    end
    endtask

endmodule

