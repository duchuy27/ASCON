// module spi_top(
//    // Control/Data Signals
//     input               i_Rst_L,            // FPGA Reset
//     input               i_Clk,              // FPGA Clock
    
//     // TX (MOSI) Signals
//     input [7:0]         i_TX_Byte,          // Byte để truyền qua MOSI
//     input               i_TX_DV,            // Data Valid Pulse với i_TX_Byte
//     output reg          o_TX_Ready,         // Transmit Ready cho byte tiếp theo
    
//     // RX (MISO) Signals
//     output reg          o_RX_DV,            // Data Valid pulse (1 clock cycle)
//     output reg [7:0]    o_RX_Byte,          // Byte nhận được trên MISO

//     output reg          o_SPI_Clk,
//     input               i_SPI_MISO,
//     output reg          o_SPI_MOSI
// );
//     // FSM state declarations
//     typedef enum logic [1:0]{
//         IDLE,
//         LOAD_DATA,
//         WAIT_TRANSFER
//     } state_t;
//     state_t current_state, next_state;

//     reg r_TX_DV;
//     reg [7:0] r_TX_Byte;

//     // Instantiate the SPI_Master module
//     spi_master #(
//         .SPI_MODE(0),
//         .CLKS_PER_HALF_BIT(2)
//     ) spi_master_UUT (
//         .i_Rst_L(i_Rst_L),
//         .i_Clk(i_Clk),

//         // TX (MOSI) Signals
//         .i_TX_Byte(r_TX_Byte),
//         .i_TX_DV(r_TX_DV),
//         .o_TX_Ready(o_TX_Ready),

//         // RX (MISO) Signals
//         .o_RX_Byte(o_RX_Byte),
//         .o_RX_DV(o_RX_DV),

//         .o_SPI_Clk(o_SPI_Clk),
//         .i_SPI_MISO(i_SPI_MISO),
//         .o_SPI_MOSI(o_SPI_MOSI)
//     );

//     // FSM for controlling data transmission
//     always @(posedge i_Clk or negedge i_Rst_L) begin
//         if (~i_Rst_L) begin
//             current_state       <= IDLE;
//             r_TX_Byte           <= 8'd0;
//             r_TX_DV             <= 1'b0;
//         end else begin
//             current_state       <= next_state;
//         end
//     end

//     always @(*) begin
//         // Default values
//         next_state = current_state;
//         r_TX_Byte = i_TX_Byte;
//         if (o_TX_Ready) begin
//             r_TX_DV = i_TX_DV;
//         end
        
        
//         // FSM behavior
//         case (current_state)
//             IDLE: begin
//                 if (r_TX_DV) begin
//                     next_state = LOAD_DATA;
//                 end
//             end

//             LOAD_DATA: begin
//                 if (r_TX_Byte != 8'd0 | ~i_Rst_L) begin
//                     r_TX_DV = 1'b0;
//                     if (~o_TX_Ready) begin
//                         next_state = WAIT_TRANSFER;
//                     end
//                 end
//             end

//             WAIT_TRANSFER: begin
//                 if (o_TX_Ready) begin
//                     next_state = IDLE;
//                 end
//             end

//             default: next_state = IDLE;
//         endcase
//     end
// endmodule

module spi_top_new(
   // Control/Data Signals
    input               i_Rst_L,            // FPGA Reset
    input               i_Clk,              // FPGA Clock
    
    // TX (MOSI) Signals
    input [7:0]         i_TX_Byte,          // Byte để truyền qua MOSI
    input               i_TX_DV,            // Data Valid Pulse với i_TX_Byte
    output reg          o_TX_Ready,         // Transmit Ready cho byte tiếp theo
    
    // RX (MISO) Signals
    output reg          o_RX_DV,            // Data Valid pulse (1 clock cycle)
    output reg [7:0]    o_RX_Byte,          // Byte nhận được trên MISO

    output reg          o_SPI_Clk,
    input               i_SPI_MISO,
    output reg          o_SPI_MOSI
);
    // FSM state declarations
    typedef enum logic [1:0]{
        WAIT_DATA,
        TRANSMITTING_DATA,
        DONE
    } state_t;
    state_t current_state, next_state;

    reg r_TX_DV;
    reg [7:0] r_TX_Byte;

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

        .o_SPI_Clk(o_SPI_Clk),
        .i_SPI_MISO(i_SPI_MISO),
        .o_SPI_MOSI(o_SPI_MOSI)
    );

    // FSM for controlling data transmission
    always @(posedge i_Clk or negedge i_Rst_L) begin
        if (~i_Rst_L) begin
            current_state       <= WAIT_DATA;
            r_TX_Byte           <= 8'd0;
            r_TX_DV             <= 1'b0;
        end else begin
            current_state       <= next_state;
        end
    end

    always @(posedge i_Clk or negedge i_Rst_L) begin
        // Default values
        next_state = current_state;
        r_TX_Byte = i_TX_Byte;
        
        // FSM behavior
        case (current_state)
            WAIT_DATA: begin
                if (r_TX_Byte != 8'd0 && o_RX_Byte != r_TX_Byte) begin
                    r_TX_DV = i_TX_DV;
                    if (r_TX_DV) begin
                        next_state = TRANSMITTING_DATA;
                    end
                end
                
            end

            TRANSMITTING_DATA: begin
                r_TX_DV = 1'b0;
                if (o_RX_DV) begin
                    next_state = DONE;
                end
            end

            DONE: begin
                if (o_TX_Ready) begin
                    next_state = WAIT_DATA;
                end
            end

            default: next_state = WAIT_DATA;
        endcase
    end
endmodule
