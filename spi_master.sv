  module spi_master
    #(parameter SPI_MODE = 0,
      parameter CLKS_PER_HALF_BIT = 2)
    (
    // Control/Data Signals,
    input        i_Rst_L,     // FPGA Reset
    input        i_Clk,       // FPGA Clock
    
    // TX (MOSI) Signals
    input [7:0]  i_TX_Byte,        // Byte để truyền qua MOSI
    input        i_TX_DV,          // Data Valid Pulse với i_TX_Byte
    output reg   o_TX_Ready,       // Transmit Ready cho byte tiếp theo
    
    // RX (MISO) Signals
    output reg       o_RX_DV,     // Data Valid pulse (1 clock cycle)
    output reg [7:0] o_RX_Byte,   // Byte nhận được trên MISO

    // SPI Interface
    output reg o_SPI_Clk,
    input      i_SPI_MISO,
    output reg o_SPI_MOSI
    );
	 
	 

    // SPI Interface (All Runs at SPI Clock Domain)
    wire w_CPOL;     // Clock polarity
    wire w_CPHA;     // Clock phase

    reg [$clog2(CLKS_PER_HALF_BIT*2)-1:0] r_SPI_Clk_Count;
    reg r_SPI_Clk;                //lưu trạng thái tính hiệu clk
    reg [4:0] r_SPI_Clk_Edges;    //đếm số cạnh của clk để xác định khi nào phải truyền dữ liệu
    reg r_Leading_Edge;           //xác định cạnh dẫn
    reg r_Trailing_Edge;          //xác định cạnh lệch
    reg       r_TX_DV;            //lưu trữ tín hiệu DV
    reg [7:0] r_TX_Byte;          //lưu trữ dữ liệu cần truyền đi

    reg [2:0] r_RX_Bit_Count;     //đếm số bit nhận
    reg [2:0] r_TX_Bit_Count;     //đếm số bit truyền
	

    // CPOL: Clock Polarity
    // CPOL=0 nghĩa là clock ở trạng thái nghỉ là 0, cạnh trước là cạnh tăng.
    // CPOL=1 nghĩa là clock ở trạng thái nghỉ là 1, cạnh trước là cạnh giảm.
    assign w_CPOL  = (SPI_MODE == 2) | (SPI_MODE == 3);

    // CPHA: Clock Phase
    // CPHA=0 nghĩa là phía "out" thay đổi dữ liệu trên cạnh giảm của clock
    //              phía "in" nhận dữ liệu trên cạnh tăng của clock
    // CPHA=1 nghĩa là phía "out" thay đổi dữ liệu trên cạnh tăng của clock
    //              phía "in" nhận dữ liệu trên cạnh giảm của clock
    assign w_CPHA  = (SPI_MODE == 1) | (SPI_MODE == 3);

    // Mục đích: Tạo ra SPI Clock số lần đúng khi DV pulse đến
    always @(posedge i_Clk or negedge i_Rst_L)
    begin
      if (~i_Rst_L)//khi nhấn rst = 0 thì nó sẽ thiết lập lại
      begin
        o_TX_Ready      <= 1'b0;
        r_SPI_Clk_Edges <= 0;
        r_Leading_Edge  <= 1'b0;
        r_Trailing_Edge <= 1'b0;
        r_SPI_Clk       <= w_CPOL; // gán trạng thái mặc định là trạng thái nghỉ
        r_SPI_Clk_Count <= 0;
      end
      else
      begin
        r_Leading_Edge  <= 1'b0;
        r_Trailing_Edge <= 1'b0;
        
        if (i_TX_DV) //được kích hoạt ở mức 1
        begin
          o_TX_Ready      <= 1'b0;    //đặt về 0 để cb truyền dữ liệu
          r_SPI_Clk_Edges <= 16;  // Tổng số cạnh trong một byte LUÔN LUÔN là 16
        end
        else if (r_SPI_Clk_Edges > 0)
        begin
          o_TX_Ready <= 1'b0;
          
          if (r_SPI_Clk_Count == CLKS_PER_HALF_BIT*2-1)
          begin
            r_SPI_Clk_Edges <= r_SPI_Clk_Edges - 1'b1;
            r_Trailing_Edge <= 1'b1;
            r_SPI_Clk_Count <= 0;
            r_SPI_Clk       <= ~r_SPI_Clk;
          end
          else if (r_SPI_Clk_Count == CLKS_PER_HALF_BIT-1)
          begin
            r_SPI_Clk_Edges <= r_SPI_Clk_Edges - 1'b1;
            r_Leading_Edge  <= 1'b1;
            r_SPI_Clk_Count <= r_SPI_Clk_Count + 1'b1;
            r_SPI_Clk       <= ~r_SPI_Clk;
          end
          else
          begin
            r_SPI_Clk_Count <= r_SPI_Clk_Count + 1'b1;
          end
        end  
        else
        begin
          o_TX_Ready <= 1'b1;
        end
      end
    end

    // Mục đích: Đăng ký i_TX_Byte khi Data Valid được kích hoạt.
    // Giữ dữ liệu byte tại chỗ trong trường hợp mô-đun cấp cao thay đổi dữ liệu
    always @(posedge i_Clk or negedge i_Rst_L)
    begin
      if (~i_Rst_L)
      begin
        r_TX_Byte <= 8'h00;
        r_TX_DV   <= 1'b0;
      end
      else
        begin
          r_TX_DV <= i_TX_DV; // delay 1 chu kỳ clock
          if (i_TX_DV)
          begin
            r_TX_Byte <= i_TX_Byte;
          end
        end
    end

    // Mục đích: Tạo dữ liệu MOSI
    // Hoạt động với cả hai CPHA=0 và CPHA=1
    always @(posedge i_Clk or negedge i_Rst_L)
    begin
      if (~i_Rst_L)
      begin
        o_SPI_MOSI     <= 1'b0;
        r_TX_Bit_Count <= 3'b111; // gửi MSb trước
      end
      else
      begin
        // Nếu ready là cao, reset bit counts về mặc định
        if (o_TX_Ready)
        begin
          r_TX_Bit_Count <= 3'b111;
        end
        // Bắt trường hợp chúng ta bắt đầu giao dịch và CPHA = 0
        else if (r_TX_DV & ~w_CPHA)
        begin
          o_SPI_MOSI     <= r_TX_Byte[3'b111];
          r_TX_Bit_Count <= 3'b110;
        end
        else if ((r_Leading_Edge & w_CPHA) | (r_Trailing_Edge & ~w_CPHA))
        begin
          r_TX_Bit_Count <= r_TX_Bit_Count - 1'b1;
          o_SPI_MOSI     <= r_TX_Byte[r_TX_Bit_Count];
        end
      end
    end

    //Đọc dữ liệu MISO
    always @(posedge i_Clk or negedge i_Rst_L)
    begin
      if (~i_Rst_L)
      begin
        o_RX_Byte      <= 8'h00;
        o_RX_DV        <= 1'b0;
        r_RX_Bit_Count <= 3'b111;
      end
      else
      begin

        // Gán mặc định
        o_RX_DV   <= 1'b0;

        if (o_TX_Ready) // Kiểm tra nếu ready là cao, nếu đúng reset bit count về mặc định
        begin
          r_RX_Bit_Count <= 3'b111;
        end
        else if ((r_Leading_Edge & ~w_CPHA) | (r_Trailing_Edge & w_CPHA))
        begin
          o_RX_Byte[r_RX_Bit_Count] <= i_SPI_MISO;  // Lấy mẫu dữ liệu
          r_RX_Bit_Count            <= r_RX_Bit_Count - 1'b1;
          if (r_RX_Bit_Count == 3'b000)
          begin
            o_RX_DV   <= 1'b1;   // Byte xong, kích hoạt Data Valid
          end
        end
      end
    end
    
    //Thêm độ trễ clock cho các tín hiệu để căn chỉnh.
    always @(posedge i_Clk or negedge i_Rst_L)
    begin
      if (~i_Rst_L)
      begin
        o_SPI_Clk  <= w_CPOL;
      end
      else
        begin
          o_SPI_Clk <= r_SPI_Clk;
        end
    end

  endmodule
