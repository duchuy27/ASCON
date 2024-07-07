`timescale 1ps/1ps

module tb_spi_top_new();
    parameter MAIN_CLK_DELAY = 2;  // 25 MHz

    logic r_Rst_L     = 1'b0;  
    logic w_SPI_Clk;
    logic r_Clk       = 1'b0;
    logic w_SPI_MOSI;

    // Master Specific
    logic [15:0] r_Master_TX_Byte = 0;
    logic Start;
    logic w_Master_TX_Ready;
    logic r_Master_RX_DV;
    logic [7:0] r_Master_RX_Byte;

    // Clock Generators:
    always #(MAIN_CLK_DELAY) r_Clk = ~r_Clk;

    // Instantiate the spi_top module
    spi_top_new dut (
        // Control/Data Signals,
        .i_Rst_L(r_Rst_L),     // FPGA Reset
        .i_Clk(r_Clk),         // FPGA Clock
        .i_Start(Start),
        
        // TX (MOSI) Signals
        .i_TX_Byte(r_Master_TX_Byte),     // Byte to transmit on MOSI
        .o_TX_Ready(w_Master_TX_Ready),   // Transmit Ready for Byte
        
        // RX (MISO) Signals
        .o_RX_DV(r_Master_RX_DV),       // Data Valid pulse (1 clock cycle)
        .o_RX_Byte(r_Master_RX_Byte),   // Byte received on MISO

        // SPI Interface
        .w_SPI_Clk(w_SPI_Clk),
        .w_SPI_MOSI(w_SPI_MOSI),
        .w_SPI_MISO(w_SPI_MOSI)
    );

    // Test sequence
    initial begin
        // Required for EDA Playground
        $dumpfile("dump.vcd"); 
        $dumpvars;

        r_Rst_L = 0;
        #20;
        r_Rst_L = 1;
        r_Master_TX_Byte = 16'hC1A2;
        Start = 1;
        #350;
        r_Rst_L = 0;
        #100
        r_Rst_L = 1;
        #400
        r_Master_TX_Byte = 16'hC1A3;
        Start = 1;
        #400;
        // Finish simulation
        #10;
        $finish();
    end
endmodule
