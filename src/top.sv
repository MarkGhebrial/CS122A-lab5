`include "src/lcd_controller.sv"
`include "src/spi.sv"

module top (
    input wire CLK, //FPGA's clock

    input wire SCK,
    input wire SPI_IN,

	output wire LCD_CLK, // LCD clock. 
	output wire LCD_DEN,
	output logic [4:0] LCD_R,
	output logic [5:0] LCD_G,
	output logic [4:0] LCD_B
);

wire[7:0] mem_waddr;
wire[15:0] mem_wdata;
spi_rx s (
    .sck(SCK),
    .in(SPI_IN),
    .we(mem_we), // Memory write enable
    .waddr(mem_waddr), // Memory write address
    .wdata(mem_wdata) // Memory write data
);

logic[7:0] mem_raddr;
wire[15:0] mem_rdata;
dp_buffer a (
    .clk(CLK),
    .we(mem_we),
    .waddr(mem_waddr),
    .wdata(mem_wdata),
    .raddr(mem_raddr),
    .rdata(mem_rdata)
);

lcd_controller controller (
    .CLK(CLK),

    .pixel(mem_rdata),
    .pixel_address(mem_raddr),

    .LCD_CLK(LCD_CLK),
    .LCD_DEN(LCD_DEN),
    .LCD_R(LCD_R),
    .LCD_G(LCD_G),
    .LCD_B(LCD_B)
);

endmodule