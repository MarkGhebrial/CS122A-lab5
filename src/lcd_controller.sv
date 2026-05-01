module lcd_controller
(
    input wire CLK, //FPGA's clock

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

    // Set the first third of the display to red
    if (cur_col < COLUMNS / 3) begin
        LCD_R <= 5'b11111;
        LCD_G <= 6'b000000;
        LCD_B <= 5'b00000;
    end
    // Set the second third of the display to green
    else if (cur_col < (COLUMNS / 3) * 2) begin
        LCD_R <= 5'b00000;
        LCD_G <= 6'b111111;
        LCD_B <= 5'b00000;
    end
    // Set the last third of the display to blue
    else begin
        LCD_R <= 5'b00000;
        LCD_G <= 6'b000000;
        LCD_B <= 5'b11111;
    end

end

assign LCD_DEN = (cur_row < ROWS) && (cur_col < COLUMNS);

assign LCD_CLK = ~CLK;

endmodule 