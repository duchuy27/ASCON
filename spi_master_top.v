module spi_master_top
(
	input 				iClk,
	input 				iReset_n,
	input 				iChipSelect_n,
	input	[31:0] 		iData,
	input					iRead,
	input					iWrite,
	input [1:0] 		iAddress,
	output reg [31:0]	oData,
	
	output w_SPI_Clk,
   output w_SPI_MOSI,
   input w_SPI_MISO,
	output w_SPI_NSS
);

reg [15:0] TX_Data;
reg NSS;
wire [7:0] RX_Data;
wire TX_Ready, RX_DV;
reg Start;

assign w_SPI_NSS = NSS;

always@(posedge iClk, negedge iReset_n)
begin
	if(~iReset_n)	
	begin	
		oData		<= 32'd0;
		TX_Data 	<= 32'd0;
		Start		<= 0;
	end else 
	begin
		if( ~iChipSelect_n & iWrite)
		begin
			case (iAddress)
			2'd0: TX_Data[15:0] 	<= iData[15:0];
			2'd1:	NSS 				<= iData[0];
			2'd2: Start				<= iData[0]; 			
			endcase
		end 
		else if (~iChipSelect_n & iRead)
		begin
			case (iAddress)
			2'd0: oData[31:0] 	<= {22'b0, RX_Data[7:0], RX_DV, TX_Ready};  //0"****|DV|R
			endcase
		end
		else if(Start == 1) begin
			Start = ~Start;
		end
	end
end
	
spi_top_new dut(
	.i_Rst_L(iReset_n),
	.i_Clk(iClk),
	.i_Start(Start),
	.i_TX_Byte(TX_Data[15:0]),
	.o_TX_Ready(TX_Ready),
	.o_RX_DV(RX_DV),
	.o_RX_Byte(RX_Data[7:0]),
	.w_SPI_Clk(w_SPI_Clk),
   .w_SPI_MOSI(w_SPI_MOSI),
   .w_SPI_MISO(w_SPI_MISO)
);
endmodule