module spi_top_new(
    // Control/Data Signals
    input               i_Rst_L,            // FPGA Reset
    input               i_Clk,              // FPGA Clock
    input               i_Start,
    
    // TX (MOSI) Signals
    input [15:0]        i_TX_Byte,          // Byte để truyền qua MOSI
    output reg          o_TX_Ready,         // Transmit Ready cho byte tiếp theo
    
    // RX (MISO) Signals
    output reg          o_RX_DV,            // Data Valid pulse (1 clock cycle)
    output reg [7:0]    o_RX_Byte,          // Byte nhận được trên MISO
     
    output              w_SPI_Clk,
    output              w_SPI_MOSI,
    input               w_SPI_MISO          
);
    
    typedef enum logic [2:0]{
        WAIT_DATA,
        RECEIVED_DATA,
        TRANSMITTING_DATA,
        TRANSMITTING_ADDRESS,
        DONE
    } state_t;
    state_t current_state, next_state;
    
    reg r_TX_DV, next_r_TX_DV;
    reg TX_LOWHIGH, next_TX_LOWHIGH;
    reg [7:0] r_TX_Byte, next_r_TX_Byte;

    // Instantiate the SPI_Master module
    spi_master #(
        .SPI_MODE(0),
        .CLKS_PER_HALF_BIT(2)
    ) spi_master_UUT (
        .i_Rst_L(i_Rst_L),
        .i_Clk(i_Clk),

        // TX (MOSI) Signals
        .i_TX_Byte(r_TX_Byte),
        .i_TX_DV(r_TX_DV),
        .o_TX_Ready(o_TX_Ready),

        // RX (MISO) Signals
        .o_RX_Byte(o_RX_Byte),
        .o_RX_DV(o_RX_DV),

        .o_SPI_Clk(w_SPI_Clk),
        .i_SPI_MISO(w_SPI_MISO),
        .o_SPI_MOSI(w_SPI_MOSI)
    );

    always @(posedge i_Clk or negedge i_Rst_L) begin
        if (~i_Rst_L) begin
            current_state       <= WAIT_DATA;
				r_TX_Byte	    <= 0;
            TX_LOWHIGH          <= 0;
            r_TX_DV            <= 0;   
        end else begin
            current_state       <= next_state;
				TX_LOWHIGH		<= next_TX_LOWHIGH;
				r_TX_Byte		<= next_r_TX_Byte;
                r_TX_DV            <= next_r_TX_DV;
        end
    end

    always @(*) begin
        // Defaults
        next_state      = current_state;
		next_TX_LOWHIGH = TX_LOWHIGH;
		next_r_TX_Byte  = r_TX_Byte;
        next_r_TX_DV    = r_TX_DV;

        case (current_state)
            WAIT_DATA: begin
                if (i_Start || TX_LOWHIGH) begin
                    if (TX_LOWHIGH) begin
						next_r_TX_Byte  = i_TX_Byte[15:8];
                    end else begin
						next_r_TX_Byte  = i_TX_Byte[7:0];
                    end
                    next_state       = RECEIVED_DATA;
                end
            end

            RECEIVED_DATA: begin
                if (TX_LOWHIGH) begin
                        next_state      = TRANSMITTING_DATA;
                    end else begin
                        next_state       = TRANSMITTING_ADDRESS;
                    end
                next_r_TX_DV = 1;
            end

            TRANSMITTING_ADDRESS: begin
                next_r_TX_DV     = 0;
                if (o_RX_DV) begin
                    next_state = DONE;
                end
            end

            TRANSMITTING_DATA: begin
                next_r_TX_DV     = 0;
                if (o_RX_DV) begin
                    next_state = DONE;
                end
            end

            DONE: begin
                next_TX_LOWHIGH = ~next_TX_LOWHIGH;
                next_state = WAIT_DATA;
            end

            default: begin
					next_state = WAIT_DATA;
					next_TX_LOWHIGH = 0;
					next_r_TX_Byte = 0;
                    next_r_TX_DV     = 0;
				end
		  endcase
    end
endmodule
