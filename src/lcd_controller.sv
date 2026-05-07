module lcd_controller
(
    input wire CLK, // FPGA's clock

    // The data that's read from memory
    input [15:0] pixel,
    // The address to read from memory
    output [7:0] pixel_address, 

	output wire LCD_CLK, // LCD clock. 
	output wire LCD_DEN,
	output logic[4:0] LCD_R,
	output logic[5:0] LCD_G,
	output logic[4:0] LCD_B
);

// The number of columns of pixels (width of the display)
parameter COLUMNS = 480;
// The size of the horizontal buffer
parameter COL_BUFFER = 45;

// The number of rows of pixels (height of the display)
parameter ROWS = 272;
// The size of the vertical buffer
parameter ROW_BUFFER = 13;

// Vertical position. Max value is COLUMNS + COL_BUFFER - 1. Min value is 0.
logic[8:0] cur_row = 0;
// Horizontal position. Max value is ROWS + ROW_BUFFER - 1. Min value is 0.
logic[9:0] cur_col = 0;

always @(posedge CLK) begin
    // Scan from left to right
    if (cur_col < COLUMNS + COL_BUFFER - 1) begin
        cur_col <= cur_col + 1;
    end
    // Move to the next row
    else begin
        cur_col <= 0;
        if (cur_row < ROWS + ROW_BUFFER - 1) begin
            cur_row <= cur_row + 1;
        end else begin
            cur_row <= 0;
        end
    end

    // Sprite column = cur_col % 16
    // Sprite row = cur_row % 16
    pixel_address <= (cur_col % 16) + 16*(cur_row %16);

    LCD_R <= (pixel >> 11);
    LCD_G <= (pixel >> 5) & 6'b1111111;
    LCD_B <= (pixel) & 5'b11111;
end

assign LCD_DEN = (cur_row < ROWS) && (cur_col < COLUMNS);

assign LCD_CLK = ~CLK;

endmodule 