`include "src/lcd_controller.sv"
`include "src/spi.sv"
`include "src/dp_buffer.sv"
`include "src/sprite.sv"

module top (
    input wire CLK, //FPGA's clock

    input wire SCK,
    input wire SPI_IN,

	output wire LCD_CLK, // LCD clock. 
	output wire LCD_DEN,
	output wire [4:0] LCD_R,
	output wire [5:0] LCD_G,
	output wire [4:0] LCD_B
);

wire mem_we;
wire[7:0] mem_waddr;
wire[15:0] mem_wdata;
spi_rx spi (
    .sck(SCK),
    .in(SPI_IN),
    .we(mem_we), // Memory write enable
    .waddr(mem_waddr), // Memory write address
    .wdata(mem_wdata) // Memory write data
);

logic[7:0] mem_raddr;
wire[15:0] mem_rdata;
dp_buffer mem (
    .clk(CLK),
    .we(mem_we),
    .waddr(mem_waddr),
    .wdata(mem_wdata),
    .raddr(mem_raddr),
    .rdata(mem_rdata)
);
// sprite mem (
//     .clk(CLK),
//     .raddr(mem_raddr),
//     .rdata(mem_rdata)
// );

lcd_controller controller (
    .clk(CLK),

    .pixel(mem_rdata),
    .pixel_address(mem_raddr),

    .lcd_clk(LCD_CLK),
    .lcd_den(LCD_DEN),
    .lcd_r(LCD_R),
    .lcd_g(LCD_G),
    .lcd_b(LCD_B)
);

endmodule