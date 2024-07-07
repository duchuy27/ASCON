module SPI_MASTER_KL
(
input CLOCK_50,
input [0:0] KEY,
inout	[7:0] GPIO,
input [1:0]	SW,
output[1:0] LEDR	
);

wire clk_9;

pll pll_u(
		.refclk(CLOCK_50),   //  refclk.clk
		.rst(~KEY[0]),      //   reset.reset
		.outclk_0(clk_9), // outclk0.clk
		.locked()    //  locked.export
	);
	
	
 unsaved system
(
.clk_clk(CLOCK_50),
.reset_reset_n(KEY[0]),
.spi_master_h_0_clk_export(GPIO[1]),
.spi_master_h_0_miso_export(GPIO[3]),
.spi_master_h_0_mosi_export(GPIO[5]),
.spi_master_h_0_nss_export(GPIO[7])
);

assign LEDR = SW;
endmodule