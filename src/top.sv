`include "src/lcd_controller.sv"

module top (
    input wire CLK, //FPGA's clock

	output wire LCD_CLK, // LCD clock. 
	output wire LCD_DEN,
	output logic [4:0] LCD_R,
	output logic [5:0] LCD_G,
	output logic [4:0] LCD_B
);

lcd_controller controller (
    .CLK(CLK),
    .LCD_CLK(LCD_CLK),
    .LCD_DEN(LCD_DEN),
    .LCD_R(LCD_R),
    .LCD_G(LCD_G),
    .LCD_B(LCD_B)
);

endmodule